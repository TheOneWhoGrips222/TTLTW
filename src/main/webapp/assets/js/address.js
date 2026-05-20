const host = "https://provinces.open-api.vn/api/";
const callAPI = (api) => {
    return fetch(api)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        });
}
const renderData = (data, selectElementId) => {
    const select = document.getElementById(selectElementId);
    select.innerHTML = '<option value="">-- Chọn --</option>'; // Reset dropdown
    for (const item of data) {
        const option = document.createElement("option");
        option.value = item.code;
        option.text = item.name;
        select.add(option);
    }
}

document.addEventListener('DOMContentLoaded', function() {
    callAPI(host + 'p/').then(data => {
        renderData(data, "province");
    });

    const provinceSelect = document.getElementById("province");
    const districtSelect = document.getElementById("district");
    const wardSelect = document.getElementById("ward");

    provinceSelect.addEventListener('change', () => {
        const provinceCode = provinceSelect.value;
        document.getElementById("province_name").value = provinceSelect.options[provinceSelect.selectedIndex].text;

        callAPI(host + "p/" + provinceCode + "?depth=2").then(data => {
            renderData(data.districts, "district");
            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>'; // Reset phường xã
        });
    });

    districtSelect.addEventListener('change', () => {
        const districtCode = districtSelect.value;
        document.getElementById("district_name").value = districtSelect.options[districtSelect.selectedIndex].text;

        callAPI(host + "d/" + districtCode + "?depth=2").then(data => {
            renderData(data.wards, "ward");
        });
    });

    wardSelect.addEventListener('change', () => {
        document.getElementById("ward_name").value = wardSelect.options[wardSelect.selectedIndex].text;
    });
});