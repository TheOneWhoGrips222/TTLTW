<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Đăng Nhập</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/DangKy.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Login.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


</head>

<body>

<jsp:include page="common/header.jsp"></jsp:include>

<main>
    <main class="main_container">
        <form class="login" action="login" method="post">
            <h1>Đăng Nhập</h1>

            <%
                String error = (String) request.getAttribute("errorMessage");
                if (error != null) {
            %>
            <div style="color: red; text-align: center; margin-bottom: 10px; font-weight: bold;">
                <i class="fa fa-circle-exclamation"></i> <%= error %>
            </div>
            <% } %>
            <div class="input_group main_group">
                <div class="input_field">
                    <i class="fa fa-user"></i>
                    <input type="text" id="username" name="username" placeholder="Tên đăng nhập hoặc Email" required>
                </div>

                <div class="input_field">
                    <i class="fa fa-lock"></i>
                    <input type="password" id="password" name="password" placeholder="Mật khẩu" required>
                    <i class="fa fa-eye-slash toggle-password" data-target="password"></i>
                </div>
            </div>

            <div class="check_row">
                <label class="check_deal">
                    <input type="checkbox"> Ghi nhớ đăng nhập
                </label>
                <a href="register" class="no_account">Tôi chưa có tài khoản</a>
            </div>


            <button type="submit" class="register_button">ĐĂNG NHẬP</button>
            <div class="social_login">
                <p>Hoặc đăng nhập với</p>

                <div class="social_buttons">
                    <a href="https://accounts.google.com/o/oauth2/v2/auth?client_id=1088784303202-apea2bsp1bn1af9ibqn8cqtm46bq3s62.apps.googleusercontent.com&redirect_uri=http://localhost:8080/demo_war/login-google&response_type=code&scope=openid%20email%20profile"
                       class="google_btn">

                        <i class="fa-brands fa-google"></i> Google
                    </a>

                    <a href="#" class="facebook_btn">
                        <i class="fa-brands fa-facebook-f"></i> Facebook
                    </a>
                </div>
            </div>

        </form>
    </main>
</main>

<jsp:include page="common/footer.jsp"></jsp:include>

<script src="assets/js/Dangky.js"></script>
</body>
</html>