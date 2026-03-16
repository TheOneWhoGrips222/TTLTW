
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đổi mật khẩu</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/change-password.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

</head>

<body>

<jsp:include page="common/header.jsp"/>

<main class="profile-page">
  <div class="container profile-layout">

    <!-- SIDEBAR -->
    <aside class="profile-sidebar">
      <h3>${sessionScope.user.username}</h3>
      <ul>
        <li><a href="profile">Hồ sơ</a></li>
        <li><a href="addresses">Địa chỉ</a></li>
        <li class="active"><a href="change-password">Đổi mật khẩu</a></li>
        <li><a href="orders">Đơn mua</a></li>
      </ul>
    </aside>

    <!-- CONTENT -->
    <section class="profile-content">
      <h2>Đổi mật khẩu</h2>

      <!-- MESSAGE -->
      <c:if test="${not empty error}">
        <p class="error-msg">${error}</p>
      </c:if>

      <c:if test="${not empty success}">
        <p class="success-msg">${success}</p>
      </c:if>

      <!-- FORM -->
      <form method="post" action="change-password">

        <div class="form-group">
          <label>Mật khẩu hiện tại</label>
          <input type="password" name="oldPassword" required>
        </div>

        <div class="form-group">
          <label>Mật khẩu mới</label>
          <input type="password" name="newPassword" required>
        </div>

        <div class="form-group">
          <label>Xác nhận mật khẩu mới</label>
          <input type="password" name="confirmPassword" required>
        </div>

        <button type="submit" class="btn-primary">
          Cập nhật mật khẩu
        </button>
      </form>

    </section>
  </div>
</main>

<jsp:include page="common/footer.jsp"/>

</body>
</html>
