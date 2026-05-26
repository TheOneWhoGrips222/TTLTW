<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

</head>
<body>

<jsp:include page="common/header.jsp"/>

<main class="checkout-container" style="width: 1200px; max-width: 100%; margin: 0 auto;">
    <h1 class="checkout-title">Thanh toán</h1>

    <form action="checkout" method="post" class="checkout-content" style="width: 1200px; max-width: 100%; margin: 0 auto;">
        <input type="hidden" name="mode" value="${mode}">
        <div class="checkout-left">

            <h2>Thông tin giao hàng</h2>

            <c:forEach items="${addresses}" var="a">
                <label class="address-box"
                       data-district-id="${a.district_id}"
                       data-ward-code="${a.ward_code}">
                    <input type="radio" name="addressId"
                           value="${a.address_id}"
                        ${a.is_default ? "checked" : ""}>
                    <b>${a.receiver_name}</b> - ${a.phone}<br>
                        ${a.address_detail}, ${a.ward}, ${a.district}, ${a.province}
                </label>
            </c:forEach>

            <a href="${pageContext.request.contextPath}/addresses" class="add-address">
                + Thêm địa chỉ mới
            </a>

            <h2>Phương thức thanh toán</h2>

            <label class="payment-method">
                <input type="radio" name="paymentMethod" value="COD" checked>
                Thanh toán khi nhận hàng (COD)
            </label>

            <label class="payment-method">
                <input type="radio" name="paymentMethod" value="BANK">
                Chuyển khoản ngân hàng
            </label>

        </div>

        <div class="checkout-right">

            <h2>Đơn hàng của bạn</h2>

            <c:choose>
                <c:when test="${mode == 'buynow'}">
                    <div class="order-item">
                        <img src="${buyNowProduct.image}">
                        <div>
                            <p>${buyNowProduct.product_name}</p>
                            <small>Số lượng: ${buyNowQuantity}</small><br>
                            <strong>${buyNowTotalFormatted}</strong>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${cart.items}" var="ci">
                        <div class="order-item">
                            <img src="${ci.product.image}">
                            <div>
                                <p>${ci.product.product_name}</p>
                                <small>Số lượng: ${ci.quantity}</small><br>
                                <strong>${ci.formattedTotal}</strong>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

            <div class="order-summary">
                <div>
                    <span>Tạm tính</span>
                    <c:choose>
                        <c:when test="${mode == 'buynow'}">
                            <%-- Thêm data-value="${buyNowTotal}" --%>
                            <span id="temp-total" data-value="${buyNowTotal}">${buyNowTotalFormatted}</span>
                        </c:when>
                        <c:otherwise>
                            <%-- Thêm data-value="${cart.total}" --%>
                            <span id="temp-total" data-value="${cart.total}">${cart.formatTotal}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <span>Phí vận chuyển</span>
                    <span id="shipping-fee">Chọn địa chỉ để tính phí</span>
                </div>
                <div class="total">
                    <span>Tổng cộng</span>
                    <span id="total-amount">
            <%-- Hiển thị tổng ban đầu --%>
            <c:choose>
                <c:when test="${mode == 'buynow'}">
                    ${buyNowTotalFormatted}
                </c:when>
                <c:otherwise>
                    ${cart.formatTotal}
                </c:otherwise>
            </c:choose>
        </span>
                </div>

                <%-- ... phần còn lại --%>
            </div>
        </div>
    </form>
</main>

<jsp:include page="common/footer.jsp"/>

<script src="${pageContext.request.contextPath}/assets/js/checkout.js" defer></script>

</body>
</html>