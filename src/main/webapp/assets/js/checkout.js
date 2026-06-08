document.addEventListener('DOMContentLoaded', function () {
    const addressRadios = document.querySelectorAll('input[name="addressId"]');
    const shippingFeeEl = document.getElementById('shipping-fee');
    const totalAmountEl = document.getElementById('total-amount');
    const tempTotalEl = document.getElementById('temp-total');
    const shippingFeeInput = document.getElementById('shippingFeeInput');

    const formatCurrency = (value) => {
        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
    };

    const calculateFee = async (districtId, wardCode) => {
        try {
            const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
            const apiUrl = `${contextPath}/api/shipping-fee?to_district_id=${districtId}&to_ward_code=${wardCode}`;

            const response = await fetch(apiUrl);

            if (!response.ok) {
                return { fee: -1, message: `Lỗi Server: ${response.status} ${response.statusText}` };
            }

            const data = await response.json();

            if (data.status === 'error') {
                return { fee: -1, message: data.message };
            }
            return { fee: data.fee, message: 'OK' };

        } catch (error) {
            console.error('Error calculating shipping fee:', error);
            return { fee: -1, message: 'Lỗi kết nối đến server. Vui lòng thử lại.' };
        }
    };

    const updateUI = (result) => {

        if (result.fee === -1) {

            shippingFeeEl.textContent = result.message;

            shippingFeeInput.value = 0;

            totalAmountEl.textContent =
                tempTotalEl.textContent;

            return;
        }

        shippingFeeEl.textContent =
            formatCurrency(result.fee);

        shippingFeeInput.value =
            result.fee;

        const tempTotalValue =
            parseFloat(tempTotalEl.dataset.value);

        const newTotal =
            tempTotalValue + result.fee;

        totalAmountEl.textContent =
            formatCurrency(newTotal);
    }


    const handleAddressChange = async (selectedRadio) => {
        if (!selectedRadio) return;

        const parentLabel = selectedRadio.closest('.address-box');
        if (!parentLabel) return;

        const districtId = parentLabel.dataset.districtId;
        const wardCode = parentLabel.dataset.wardCode;

        if (districtId && wardCode) {
            shippingFeeEl.textContent = "Đang tính...";
            const result = await calculateFee(districtId, wardCode);
            updateUI(result);
        } else {
            updateUI({ fee: -1, message: "Địa chỉ thiếu thông tin Quận/Huyện hoặc Phường/Xã. Vui lòng cập nhật lại địa chỉ." });
        }
    };

    addressRadios.forEach(radio => {
        radio.addEventListener('change', () => handleAddressChange(radio));
    });

    const defaultCheckedRadio = document.querySelector('input[name="addressId"]:checked');
    if (defaultCheckedRadio) {
        handleAddressChange(defaultCheckedRadio);
    }
});