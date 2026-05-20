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
const renderData = (data, selectElementId,text) => {
    const select = document.getElementById(selectElementId);
    select.innerHTML = `<option value="">-- ${text} --</option>`;
    for (const item of data) {
        const option = document.createElement("option");
        option.value = item.code;
        option.text = item.name;
        select.add(option);
    }
}

document.addEventListener('DOMContentLoaded', function() {
    callAPI(host + 'p/').then(data => {
        renderData(data, "province","Chọn Tỉnh/Thành phố");
    });

    const provinceSelect = document.getElementById("province");
    const districtSelect = document.getElementById("district");
    const wardSelect = document.getElementById("ward");

    provinceSelect.addEventListener('change', () => {
        const provinceCode = provinceSelect.value;
        document.getElementById("province_name").value = provinceSelect.options[provinceSelect.selectedIndex].text;

        callAPI(host + "p/" + provinceCode + "?depth=2").then(data => {
            renderData(data.districts, "district","Chọn Quận/Huyện");
            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        });
    });

    districtSelect.addEventListener('change', () => {
        const districtCode = districtSelect.value;
        document.getElementById("district_name").value = districtSelect.options[districtSelect.selectedIndex].text;

        callAPI(host + "d/" + districtCode + "?depth=2").then(data => {
            renderData(data.wards, "ward","Chọn Phường/Xã");
        });
    });

    wardSelect.addEventListener('change', () => {
        document.getElementById("ward_name").value = wardSelect.options[wardSelect.selectedIndex].text;
    });

        const getLocationBtn = document.getElementById("getLocationBtn");
        const locationStatus = document.getElementById("locationStatus");

        getLocationBtn.addEventListener('click', () => {
            if (navigator.geolocation) {
                locationStatus.style.display = 'inline';
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        const lat = position.coords.latitude;
                        const lon = position.coords.longitude;

                        // Gọi API Reverse Geocoding
                        fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}`)
                            .then(response => response.json())
                            .then(data => {
                                if (data && data.address) {
                                    const address = data.address;

                                    // Tự động điền các thông tin
                                    autoFillAddress(address);
                                    locationStatus.textContent = 'Đã xác định vị trí!';
                                    setTimeout(() => { locationStatus.style.display = 'none'; }, 3000);
                                } else {
                                    locationStatus.textContent = 'Không thể tìm thấy địa chỉ.';
                                }
                            })
                            .catch(error => {
                                console.error('Error fetching reverse geocoding:', error);
                                locationStatus.textContent = 'Lỗi khi tìm địa chỉ.';
                            });
                    },
                    (error) => {
                        console.error('Geolocation error:', error);
                        locationStatus.textContent = 'Không thể lấy vị trí. Vui lòng cấp quyền.';
                    }
                );
            } else {
                alert("Trình duyệt của bạn không hỗ trợ Geolocation.");
            }
        });


    async function autoFillAddress(address) {
        const provinceName = address.state || address.city;
        const districtName = address.county || address.city_district;
        const wardName = address.suburb || address.village || address.town;
        const road = address.road || '';
        const houseNumber = address.house_number || '';
        document.querySelector('input[name="address_detail"]').value = `${houseNumber} ${road}`.trim();

        try {
            await setDropdownByText("province", provinceName);

            await new Promise(resolve => setTimeout(resolve, 500));
            await setDropdownByText("district", districtName);
            await new Promise(resolve => setTimeout(resolve, 500));
            await setDropdownByText("ward", wardName);

        } catch (error) {
            console.error("Lỗi khi tự động điền địa chỉ:", error);
            const locationStatus = document.getElementById("locationStatus");
            locationStatus.textContent = 'Lỗi khi điền địa chỉ tự động.';
        }
    }

        async function setDropdownByText(selectId, textToFind) {
            if (!textToFind) return;
            const select = document.getElementById(selectId);

            for (let i = 0; i < select.options.length; i++) {
                const optionText = select.options[i].text;
                if (normalizeString(optionText) === normalizeString(textToFind)) {
                    select.value = select.options[i].value;
                    select.dispatchEvent(new Event('change'));
                    return;
                }
            }
        }

        function normalizeString(str) {
            if (!str) return '';
            return str.toLowerCase()
                .replace(/^(thành phố|tỉnh|quận|huyện|phường|xã|thị xã|thị trấn)\s/,'')
                .trim();
        }
});