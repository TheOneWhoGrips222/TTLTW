document.addEventListener("DOMContentLoaded", function () {
    const passwordInput = document.getElementById("password");
    passwordInput.addEventListener("input", function () {
        const value = passwordInput.value;

        const rules = {
            length: value.length >= 8,
            uppercase: /[A-Z]/.test(value),
            lowercase: /[a-z]/.test(value),
            number: /\d/.test(value),
            special: /[@$!%*?&]/.test(value)
        };
        for (let rule in rules) {
            const element = document.getElementById(rule);

            if (value.length === 0) {
                element.classList.remove("valid", "invalid");
                element.classList.add("neutral");
                continue;
            }

            // 👉 nếu đang nhập → cập nhật realtime
            if (rules[rule]) {
                element.classList.remove("invalid", "neutral");
                element.classList.add("valid");
            } else {
                element.classList.remove("valid", "neutral");
                element.classList.add("invalid");
            }
        }
    });
});
const toggle = document.getElementById("togglePassword");
const password = document.getElementById("password");

toggle.addEventListener("click", function () {
    const type = password.getAttribute("type") === "password" ? "text" : "password";
    password.setAttribute("type", type);

    this.classList.toggle("fa-eye");
    this.classList.toggle("fa-eye-slash");
});
