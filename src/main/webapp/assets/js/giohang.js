// ===== LOGIC CHO TRANG GIỎ HÀNG =====

// Hàm định dạng số sang tiền tệ (Vd: 15000000 -> "15.000.000đ")
function formatCurrency(number) {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(number);
}

// Hàm tính toán và cập nhật toàn bộ giỏ hàng
function updateCart() {
    let totalSub = 0;

    // Duyệt qua từng hàng sản phẩm
    document.querySelectorAll('.com.webthietbibep.cart-item-row').forEach(row => {
        const price = parseFloat(row.getAttribute('data-price'));
        const quantityInput = row.querySelector('.quantity-input');
        const quantity = parseInt(quantityInput.value);

        if (quantity < 1) {
            quantityInput.value = 1; // Ngăn số lượng < 1
            return;
        }

        const subtotal = price * quantity;
        totalSub += subtotal;

        // Cập nhật cột "Tạm tính" cho hàng đó
        row.querySelector('.com.webthietbibep.cart-item-subtotal').textContent = formatCurrency(subtotal);
    });

    // Cập nhật phần Tóm tắt đơn hàng
    const subtotalEl = document.getElementById('com.webthietbibep.cart-subtotal');
    const totalEl = document.getElementById('com.webthietbibep.cart-total');

    if (subtotalEl && totalEl) {
        subtotalEl.textContent = formatCurrency(totalSub);
        // (Giả sử phí vận chuyển = 0)
        totalEl.textContent = formatCurrency(totalSub);
    }
}

// Lắng nghe sự kiện click trên các nút +/-
document.addEventListener('click', function(e) {
    // Nếu click nút Tăng (+)
    if (e.target.classList.contains('quantity-up')) {
        const input = e.target.previousElementSibling;
        input.value = parseInt(input.value) + 1;
        updateCart(); // Tính lại giỏ hàng
    }

    // Nếu click nút Giảm (-)
    if (e.target.classList.contains('quantity-down')) {
        const input = e.target.nextElementSibling;
        if (parseInt(input.value) > 1) {
            input.value = parseInt(input.value) - 1;
            updateCart(); // Tính lại giỏ hàng
        }
    }

    // Nếu click nút Xóa
    if (e.target.closest('.com.webthietbibep.cart-remove-btn')) {
        e.preventDefault();
        const row = e.target.closest('.com.webthietbibep.cart-item-row');
        row.remove(); // Xóa hàng khỏi DOM
        updateCart(); // Tính lại giỏ hàng
    }
});

// Lắng nghe sự kiện khi người dùng tự gõ số lượng
document.querySelectorAll('.quantity-input').forEach(input => {
        input.addEventListener('change', updateCart);
    }
);

// Chạy updateCart() một lần khi tải trang để đảm bảo giá đúng
// (chỉ chạy nếu chúng ta đang ở trang giỏ hàng)
if (document.querySelector('.com.webthietbibep.cart-section')) {
    updateCart();
}