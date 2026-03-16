<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

  <!DOCTYPE html>
  <html lang="vi">
  <head>
    <meta charset="UTF-8">
    <title>Hồ sơ của tôi</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
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
        <h3>${user.username}</h3>
        <ul>
          <li class="active"><a href="profile">Hồ sơ</a></li>
          <li><a href="addresses">Địa chỉ</a></li>
          <li><a href="change-password">Đổi mật khẩu</a></li>
          <li><a href="orders">Đơn mua</a></li>
        </ul>
      </aside>

      <!-- CONTENT -->
      <section class="profile-content">
        <h2>Hồ Sơ Của Tôi</h2>
        <p>Quản lý thông tin hồ sơ để bảo mật tài khoản</p>

        <form action="${pageContext.request.contextPath}/profile" method="post">

          <div class="form-group">
            <label>Tên đăng nhập</label>
            <input type="text" value="${user.username}" disabled>
          </div>

          <div class="form-group">
            <label>Họ và tên</label>
            <input type="text" name="full_name" value="${user.full_name}">
          </div>

          <div class="form-group">
            <label>Email</label>
            <input type="email" value="${user.email}" disabled>
          </div>

          <div class="form-group">
            <label>Số điện thoại</label>
            <input type="text" name="phone" value="${user.phone}">
          </div>
          <button type="submit" class="btn-primary">Lưu</button>
        </form>

      </section>

    </div>
  </main>
  <jsp:include page="common/footer.jsp"></jsp:include>

  </body>
  </html>
