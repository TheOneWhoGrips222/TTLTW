document.addEventListener('DOMContentLoaded', function () {

    const provinceSelect = document.getElementById("province");
    const districtSelect = document.getElementById("district");
    const wardSelect = document.getElementById("ward");

    const API = "https://provinces.open-api.vn/api/"

    async function fetchData(url) {
        const response = await fetch(url);

        if (!response.ok) {
            throw new Error("API lỗi.");
        }

        return await response.json();
    }

    function renderOptions(data, select, defaultText, valueKey, textKey) {

        select.innerHTML =
            `<option value="">-- ${defaultText} --</option>`;

        data.forEach(item => {

            const option = document.createElement("option");

            option.value = item[valueKey];
            option.textContent = item[textKey];

            select.appendChild(option);
        });
    }

    fetchData(`${API}/p/`)
        .then(data => {

            renderOptions(
                data,
                provinceSelect,
                "Chọn Tỉnh/Thành phố",
                "code",
                "name"
            );

        })
        .catch(console.error);

    provinceSelect.addEventListener('change', async () => {

        const provinceCode = provinceSelect.value;

        document.getElementById("province_name").value =
            provinceSelect.options[
                provinceSelect.selectedIndex
                ].text;

        districtSelect.innerHTML =
            '<option value="">-- Chọn Quận/Huyện --</option>';

        wardSelect.innerHTML =
            '<option value="">-- Chọn Phường/Xã --</option>';

        if (!provinceCode) return;

        const province =
            await fetchData(
                `${API}/p/${provinceCode}?depth=2`
            );

        renderOptions(
            province.districts,
            districtSelect,
            "Chọn Quận/Huyện",
            "code",
            "name"
        );

    });

    districtSelect.addEventListener('change', async () => {

        const districtCode = districtSelect.value;

        document.getElementById("district_name").value =
            districtSelect.options[
                districtSelect.selectedIndex
                ].text;

        wardSelect.innerHTML =
            '<option value="">-- Chọn Phường/Xã --</option>';

        if (!districtCode) return;

        const district =
            await fetchData(
                `${API}/d/${districtCode}?depth=2`
            );

        renderOptions(
            district.wards,
            wardSelect,
            "Chọn Phường/Xã",
            "code",
            "name"
        );

    });

    wardSelect.addEventListener('change', () => {

        document.getElementById("ward_name").value =
            wardSelect.options[
                wardSelect.selectedIndex
                ].text;

    });

    const getLocationBtn = document.getElementById("getLocationBtn");
    const locationStatus = document.getElementById("locationStatus");

    if (getLocationBtn) {
        getLocationBtn.addEventListener('click', () => {
            if (navigator.geolocation) {
                locationStatus.style.display = 'inline';
                locationStatus.textContent = 'Đang xác định vị trí...';

                navigator.geolocation.getCurrentPosition(
                    async (position) => {
                        const lat = position.coords.latitude;
                        const lon = position.coords.longitude;

                        try {
                            // Gọi API Reverse Geocoding của Nominatim
                            const response = await fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}`);
                            const data = await response.json();

                            if (data && data.address) {
                                autoFillAddress(data.address);
                                locationStatus.textContent = 'Đã xác định vị trí!';
                                setTimeout(() => { locationStatus.style.display = 'none'; }, 3000);
                            } else {
                                locationStatus.textContent = 'Không thể tìm thấy địa chỉ từ tọa độ.';
                                setTimeout(() => { locationStatus.style.display = 'none'; }, 3000);
                            }
                        } catch (error) {
                            console.error('Error fetching reverse geocoding:', error);
                            locationStatus.textContent = 'Lỗi khi tìm địa chỉ. Vui lòng thử lại.';
                            setTimeout(() => { locationStatus.style.display = 'none'; }, 3000);
                        }
                    },
                    (error) => {
                        console.error('Geolocation error:', error);
                        let errorMessage = 'Không thể lấy vị trí. Vui lòng cấp quyền.';
                        if (error.code === error.PERMISSION_DENIED) {
                            errorMessage = 'Bạn đã từ chối cấp quyền vị trí.';
                        } else if (error.code === error.POSITION_UNAVAILABLE) {
                            errorMessage = 'Thông tin vị trí không khả dụng.';
                        } else if (error.code === error.TIMEOUT) {
                            errorMessage = 'Hết thời gian chờ lấy vị trí.';
                        }
                        locationStatus.textContent = errorMessage;
                        setTimeout(() => { locationStatus.style.display = 'none'; }, 5000);
                    },
                    { enableHighAccuracy: false, timeout: 30000, maximumAge: 0 } // Tăng timeout lên 30s, tắt high accuracy
                );
            } else {
                alert("Trình duyệt của bạn không hỗ trợ Geolocation.");
                locationStatus.style.display = 'none';
            }
        });
    }

    async function autoFillAddress(address) {
        const provinceName = address.state || address.city;
        const districtName = address.county || address.city_district;
        const wardName = address.suburb || address.village || address.town;
        const road = address.road || '';
        const houseNumber = address.house_number || '';

        document.querySelector('input[name="address_detail"]').value = `${houseNumber} ${road}`.trim();

        try {
            const provinces = await fetchData(`${API}/p/`);
            const foundProvince = provinces.find(p => normalizeString(p.name) === normalizeString(provinceName));
            if (foundProvince) {
                provinceSelect.value = foundProvince.code;
                provinceSelect.dispatchEvent(new Event('change')); // Kích hoạt sự kiện để tải quận/huyện
                document.getElementById("province_name").value = foundProvince.name;

                await new Promise(resolve => setTimeout(resolve, 500));
                const districtsData = await fetchData(`${API}/p/${foundProvince.code}?depth=2`);
                const foundDistrict = districtsData.districts.find(d => normalizeString(d.name) === normalizeString(districtName));
                if (foundDistrict) {
                    districtSelect.value = foundDistrict.code;
                    districtSelect.dispatchEvent(new Event('change')); // Kích hoạt sự kiện để tải phường/xã
                    document.getElementById("district_name").value = foundDistrict.name;

                    await new Promise(resolve => setTimeout(resolve, 500));
                    const wardsData = await fetchData(`${API}/d/${foundDistrict.code}?depth=2`);
                    const foundWard = wardsData.wards.find(w => normalizeString(w.name) === normalizeString(wardName));
                    if (foundWard) {
                        wardSelect.value = foundWard.code;
                        wardSelect.dispatchEvent(new Event('change'));
                        document.getElementById("ward_name").value = foundWard.name;
                    } else {
                        console.warn("Không tìm thấy Phường/Xã tương ứng:", wardName);
                    }
                } else {
                    console.warn("Không tìm thấy Quận/Huyện tương ứng:", districtName);
                }
            } else {
                console.warn("Không tìm thấy Tỉnh/Thành phố tương ứng:", provinceName);
            }
        } catch (error) {
            console.error("Lỗi khi tự động điền dropdowns:", error);
            locationStatus.textContent = 'Lỗi khi điền địa chỉ tự động.';
        }
    }

    function normalizeString(str) {
        if (!str) return '';
        return str.toLowerCase()
            .replace(/^(thành phố|tỉnh|quận|huyện|phường|xã|thị xã|thị trấn)\s/,'')
            .trim();
    }

});