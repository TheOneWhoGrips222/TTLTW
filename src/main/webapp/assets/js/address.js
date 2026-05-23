document.addEventListener('DOMContentLoaded', function() {

    const ghnToken = "26a33ce0-56ac-11f1-a973-aee5264794df";
    const ghnApiBase = "https://dev-online-gateway.ghn.vn/shiip/public-api";

    const provinceSelect = document.getElementById("province");
    const districtSelect = document.getElementById("district");
    const wardSelect = document.getElementById("ward");

    const callGhnApi = (endpoint) => {
        return fetch(ghnApiBase + endpoint, {
            method: 'GET',
            headers: {
                'Token': ghnToken
            }
        }).then(response => response.json());
    };

    const renderData = (data, selectElement, defaultText) => {
        selectElement.innerHTML = `<option value="">-- ${defaultText} --</option>`;
        for (const item of data) {
            const option = document.createElement("option");
            option.value = item.ProvinceID || item.DistrictID || item.WardCode;
            option.text = item.ProvinceName || item.DistrictName || item.WardName;
            selectElement.add(option);
        }
    };

    callGhnApi('/v2/master-data/province').then(response => {
        if (response.code === 200) {
            renderData(response.data, provinceSelect, "Chọn Tỉnh/Thành phố");
        }
    });

    provinceSelect.addEventListener('change', () => {
        const provinceId = provinceSelect.value;
        document.getElementById("province_name").value = provinceSelect.options[provinceSelect.selectedIndex].text;

        districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';

        if (provinceId) {
            callGhnApi(`/v2/master-data/district?province_id=${provinceId}`).then(response => {
                if (response.code === 200) {
                    renderData(response.data, districtSelect, "Chọn Quận/Huyện");
                }
            });
        }
    });

    districtSelect.addEventListener('change', () => {
        const districtId = districtSelect.value;
        document.getElementById("district_name").value = districtSelect.options[districtSelect.selectedIndex].text;

        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';

        if (districtId) {
            callGhnApi(`/v2/master-data/ward?district_id=${districtId}`).then(response => {
                if (response.code === 200) {
                    renderData(response.data, wardSelect, "Chọn Phường/Xã");
                }
            });
        }
    });

    wardSelect.addEventListener('change', () => {
        document.getElementById("ward_name").value = wardSelect.options[wardSelect.selectedIndex].text;
    });

});