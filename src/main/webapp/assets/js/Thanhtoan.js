document.addEventListener("DOMContentLoaded", () => {
  const btn = document.getElementById("submitOrder");
  const checkout = document.querySelector(".checkout-container");
  const done = document.getElementById("successMessage");
  const load = document.getElementById("loading");
  const orderCode = document.getElementById("orderCode");

  btn.addEventListener("click", () => {
   
    const requiredFields = ["fullName", "phone", "address", "city", "district"];
    let isValid = true;

   
    document.querySelectorAll(".error-text").forEach(e => e.remove());

  
    requiredFields.forEach(id => {
      const el = document.getElementById(id);
      if (!el.value.trim()) {
        isValid = false;
        showError(el, "Vui lòng nhập thông tin này");
      }
    });

    
    const paymentSelected = document.querySelector('input[name="payment"]:checked');
    if (!paymentSelected) {
      isValid = false;
      const payBox = document.querySelector(".payment-methods");
      showError(payBox, "Vui lòng chọn phương thức thanh toán.");
    }

    // Nếu có lỗi thì dừng lại
    if (!isValid) return;

    // Hiện loading
    load.style.display = "block";
    btn.disabled = true;

    // Giả lập xử lý đơn hàng
    setTimeout(() => {
      load.style.display = "none";
      checkout.style.display = "none";
      done.style.display = "block";
      orderCode.textContent = "DH" + Math.floor(100000 + Math.random() * 900000);
    }, 1200);
  });

  // Khi người dùng nhập lại → xóa lỗi tương ứng
  document.querySelectorAll("input, select, textarea").forEach(el => {
    el.addEventListener("input", () => {
      const next = el.nextElementSibling;
      if (next && next.classList.contains("error-text")) next.remove();
    });
  });

  // Hàm hiển thị lỗi
  function showError(element, message) {
    const error = document.createElement("p");
    error.className = "error-text";
    error.textContent = message;
    element.insertAdjacentElement("afterend", error);
  }
});
