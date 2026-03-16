const PasswordIcons = document.querySelectorAll(".toggle-password");
PasswordIcons.forEach(icon => {
    icon.addEventListener('click', function() {

        const targetId = this.getAttribute('data-target');
        const targetInput = document.getElementById(targetId);


        const type = targetInput.getAttribute('type') === 'password' ? 'text' : 'password';
        targetInput.setAttribute('type', type);


        this.classList.toggle('fa-eye');
        this.classList.toggle('fa-eye-slash');
    });
});