<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Địa chỉ</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/address.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">
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
                <li class="active"><a href="addresses">Địa chỉ</a> </li>
                <li><a href="change-password">Đổi mật khẩu</a></li>
                <li><a href="orders">Đơn mua</a></li>
                <li><a href="user-voucher">Voucher</a></li>
            </ul>
        </aside>

        <section class="profile-content">
            <div class="address-header">
                <h2>Địa chỉ của tôi</h2>
                <button onclick="document.getElementById('addForm').style.display='block'">
                    + Thêm địa chỉ mới
                </button>
            </div>

            <c:forEach var="a" items="${addresses}">
                <div class="address-item">
                    <b>${a.receiver_name}</b> | ${a.phone}<br>
                        ${a.address_detail}, ${a.ward}, ${a.district}, ${a.province}

                    <c:if test="${a.is_default}">
                        <span class="badge">Mặc định</span>
                    </c:if>

                    <div class="actions">
                        <a href="set-default?id=${a.address_id}">Thiết lập mặc định</a>
                        <a href="delete-address?id=${a.address_id}">Xóa</a>
                    </div>
                </div>
            </c:forEach>
                <form id="addForm" method="post" style="display:none">
                    <input name="receiver_name" placeholder="Tên người nhận" required>
                    <br>
                    <input name="phone" placeholder="SĐT" type="tel"  required>
                    <br>
                    <select id="province" required>
                        <option value="">-- Chọn Tỉnh/Thành phố --</option>
                    </select>
                    <br>
                    <select id="district" required>
                        <option value="">-- Chọn Quận/Huyện --</option>
                    </select>
                    <br>
                    <select id="ward"  required>
                        <option value="">-- Chọn Phường/Xã --</option>
                    </select>
                    <br>
                    <input name="address_detail" placeholder="Địa chỉ chi tiết (Số nhà, tên đường...)" required>
                    <input type="hidden" id="province_name" name="province">
                    <input type="hidden" id="district_name" name="district">
                    <input type="hidden" id="ward_name" name="ward">

                    <div class="geolocation-wrapper">
                        <button type="button" id="getLocationBtn">
                            <i class="fa fa-map-marker-alt"></i> Sử dụng vị trí hiện tại
                        </button>
                            <span id="locationStatus" style="display: none; font-size: 12px; color: #666; margin-left: 10px;">Đang xác định vị trí...</span>
                    </div>

                <label><input type="checkbox" name="is_default"> Mặc định</label>
                <button type="submit">Thêm</button>
            </form>

        </section>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/address.js" defer></script>
</body>
</html>