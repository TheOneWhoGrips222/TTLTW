document.addEventListener("DOMContentLoaded", function () {
    const passwordInput = document.getElementById("password");
    const message = document.getElementById("passwordMessage");

    const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$/;

    passwordInput.addEventListener("input", function () {
        const value = passwordInput.value;

        if (value.length === 0) {
            message.textContent = "";
            return;
        }

        if (regex.test(value)) {
            message.textContent = "✓ Mật khẩu hợp lệ";
            message.style.color = "green";
        } else {
            message.textContent =
                "✗ Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt";
            message.style.color = "red";
        }
    });
});
