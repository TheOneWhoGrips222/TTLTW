<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Voucher</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/userVoucher.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/khuyenmai.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>

<body>

<jsp:include page="common/header.jsp"/>

<main class="profile-page">
    <div class="container profile-layout">

        <aside class="profile-sidebar">
            <h3>${sessionScope.user.username}</h3>
            <ul>
                <li><a href="profile">Hồ sơ</a></li>
                <li><a href="addresses">Địa chỉ</a></li>
                <li><a href="change-password">Đổi mật khẩu</a></li>
                <li><a href="orders">Đơn mua</a></li>
                <li><a href="user-voucher">Voucher</a></li>
            </ul>
        </aside>

        <section class="profile-content">
            <h2>Voucher</h2>
            <p>Quản lý các mã giảm giá cá nhân</p>
            <div class="voucher-filter-bar">
                <form action="${pageContext.request.contextPath}/user-voucher" method="get" class="voucher-filter-bar">
                    <select name="statusFilter" class="voucher-select">
                        <option value="all" ${param.statusFilter == 'all' ? 'selected' : ''}>Tất cả voucher</option>
                        <option value="unused" ${param.statusFilter == 'unused' ? 'selected' : ''}>Chưa sử dụng</option>
                        <option value="used" ${param.statusFilter == 'used' ? 'selected' : ''}>Đã sử dụng</option>
                        <option value="expired" ${param.statusFilter == 'expired' ? 'selected' : ''}>Đã hết hạn</option>
                    </select>
                    <button type="submit" class="btn-filter-submit">Lọc</button>
                </form>
            </div>
            <div class="voucher-grid">
                <c:if test="${empty listU}">
                    <div style="text-align: center; color: #888; padding: 40px 0; width: 100%;">
                        <i class="fa-solid fa-ticket-simple" style="font-size: 48px; margin-bottom: 10px; color: #ccc;"></i>
                        <p>Không tìm thấy voucher nào phù hợp.</p>
                    </div>
                </c:if>

                <c:if test="${not empty listU}">
                    <c:forEach var="listU" items="${listU}">
                        <article class="voucher-card">
                            <div class="voucher-left" style="${listU.status == 1 ? 'background: linear-gradient(135deg, #757f9a, #d7dde8);' : (listU.expired ? 'background: #ccc;' : '')}">
                                <div class="voucher-value">${listU.discountFormat}</div>
                                <div class="voucher-type">${listU.discountType}</div>
                            </div>
                            <div class="voucher-border-line"></div>
                            <div class="voucher-right">
                                <div class="voucher-info">
                                    <span class="voucher-code-tag">Mã: ${listU.code}</span>
                                    <h3 class="voucher-title">${listU.title}</h3>
                                    <p class="voucher-desc">${listU.description}</p>
                                    <p class="voucher-condition">
                                        <c:if test="${listU.minOrderValue > 0}">
                                        <i class="fa-solid fa-circle-info"></i> Đơn tối thiểu: ${listU.minvalueFormat}
                                        </c:if>
                                        <c:if test="${listU.maxValueDiscount > 0}">
                                            <br><i class="fa-solid fa-circle-info"></i> Giảm tối đa: ${listU.maxValueFormat}
                                        </c:if>
                                    </p>
                                </div>
                                <div class="voucher-action">
                                    <c:if test="${listU.status == 1}">
                                        <button class="btn-get-voucher success" disabled>
                                            Đã dùng
                                        </button>
                                    </c:if>
                                    <c:if test="${listU.status == 0 && listU.expired}">
                                        <button class="btn-get-voucher" style="background-color: #999;" disabled>
                                            Hết hạn
                                        </button>
                                    </c:if>
                                    <c:if test="${listU.status == 0 && !listU.expired}">
                                        <a href="products">
                                            <button class="btn-get-voucher" style="background-color: #1677ff;" onclick="location.href='index'">
                                                Dùng ngay
                                            </button>
                                        </a>
                                    </c:if>
                                    <div class="voucher-expiry">Hạn dùng: ${listU.dateFormat}</div>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </c:if>
            </div>
        </section>

    </div>
</main>

<jsp:include page="common/footer.jsp"/>

</body>
</html>