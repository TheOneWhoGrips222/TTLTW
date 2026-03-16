<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Register.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Login.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

</head>
<body>

<jsp:include page="common/header.jsp"/>

<main class="main_container">
    <form class="login" action="register" method="post">
        <h1>Đăng ký</h1>

        <c:if test="${not empty error}">
            <div style="color:red;text-align:center;margin-bottom:10px;">
                    ${error}
            </div>
        </c:if>

        <div class="input_group">
            <input type="text" name="username" placeholder="Tên đăng nhập" required>
            <input type="text" name="fullName" placeholder="Họ và tên" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="text" name="phone" placeholder="Số điện thoại" required>
            <input type="password" id="password" name="password" placeholder="Mật khẩu" required>
            <small id="passwordMessage" class="password-message"></small>
            <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu" required>
        </div>

        <button type="submit" class="register_button">
            ĐĂNG KÝ
        </button>

        <p style="text-align:center;margin-top:10px;">
            Đã có tài khoản? <a href="login">Đăng nhập</a>
        </p>
    </form>
</main>

<jsp:include page="common/footer.jsp"/>
<script src="assets/js/Register.js"></script>
</body>
</html>
