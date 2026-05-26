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

});