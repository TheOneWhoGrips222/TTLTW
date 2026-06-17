<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
        <input type="hidden"
               name="shippingFee"
               id="shippingFeeInput"
               value="0">
        <input type="hidden" name="mode" value="${mode}">
        <input type="hidden" id="fs-type" value="${sessionScope.chosseFS != null ? sessionScope.chosseFS.discountType : ''}">
        <input type="hidden" id="fs-value" value="${sessionScope.chosseFS != null ? sessionScope.chosseFS.discountValue : 0}">
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
                Thanh toán online (VNPAY)
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
            <c:forEach items = "${cart.itemsCombo}" var ="combo">
            <div class="order-item">
                <img src="${combo.combo.image}">
                <div>
                    <p>${combo.combo.name}</p>
                    <small>Số lượng: ${combo.quantity}</small><br>
                    <strong>${combo.Format(combo.price * combo.quantity)}</strong>
                </div>
            </div>
            </c:forEach>
            </c:otherwise>
            </c:choose>


            <div class="voucher-section" style="margin-top: 20px; padding-bottom: 15px; border-bottom: 1px solid #ddd;">
                <h3 style="font-size: 1.1rem; margin-bottom: 10px; color: black; font-family: 'Manrope', sans-serif;">Mã giảm giá</h3>

                <div style="display: flex; flex-direction: column; gap: 10px; padding: 12px 15px; border: 1px solid #ddd; border-radius: 6px; background-color: #fcfcfc;">
                    <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
                        <div style="display: flex; flex-direction: column; gap: 8px; flex: 1;">


                            <c:if test="${empty sessionScope.chosseFS && empty sessionScope.chosseD}">
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <i class="fa-solid fa-ticket" style="color: var(--primary-color); font-size: 1.2rem;"></i>
                                    <span style="font-family: 'Inter', sans-serif; color: #555; font-size: 0.95rem;">Chưa chọn mã giảm giá nào</span>
                                </div>
                            </c:if>


                            <c:if test="${not empty sessionScope.chosseFS}">
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <span style="background-color: #0088ff; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; font-family: 'Inter', sans-serif; white-space: nowrap; display: inline-block;">Freeship</span>
                                    <span style="font-family: 'Inter', sans-serif; color: #333; font-size: 0.95rem; font-weight: 500;">${sessionScope.chosseFS.title}</span>
                                </div>
                            </c:if>


                            <c:if test="${not empty sessionScope.chosseD}">
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <span style="background-color: #22c55e; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; font-family: 'Inter', sans-serif; white-space: nowrap; display: inline-block;">Giảm giá</span>
                                    <span style="font-family: 'Inter', sans-serif; color: #333; font-size: 0.95rem; font-weight: 500;">${sessionScope.chosseD.title}</span>
                                </div>
                            </c:if>

                        </div>

                        <button type="button" onclick="window.location.href='select-voucher?mode=${not empty param.mode ? param.mode : 'cart'}'" style="padding: 8px 15px; border-radius: 6px; border: 1px solid var(--primary-color); cursor: pointer; color: var(--primary-color); background-color: white; font-weight: 600; font-family: 'Inter', sans-serif; transition: all 0.3s; white-space: nowrap; margin-left: 15px;">
                            Thay đổi
                        </button>
                    </div>
                </div>
            </div>


            <div class="order-summary">
                <div>
                    <span>Tạm tính</span>
                    <c:set var="gocTotal" value="${mode == 'buynow' ? buyNowTotal : cart.total}" />
                    <c:choose>
                        <c:when test="${discount > 0}">
                            <span>
                                <span style="color: #a8a8a8; text-decoration: line-through; margin-right: 8px;">
                                    <fmt:formatNumber value="${gocTotal}" type="number"/> đ
                                </span>
                                <span id="temp-total" data-value="${gocTotal - discount}" style="color: #ff424e; font-weight: bold;">
                                    <fmt:formatNumber value="${gocTotal - discount}" type="number"/> đ
                                </span>
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span id="temp-total" data-value="${gocTotal}" style="color: #ff424e; font-weight: bold;">
                                <c:choose>
                                    <c:when test="${mode == 'buynow'}">
                                        ${buyNowTotalFormatted}
                                    </c:when>
                                    <c:otherwise>
                                        ${cart.formatTotal}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <span>Phí vận chuyển</span>
                    <span id="shipping-fee">Chọn địa chỉ để tính phí</span>
                </div>
                <div class="total">
                    <span>Tổng cộng</span>
                    <span id="total-amount" style="color: #ff424e; font-weight: bold;">
                     <c:choose>
                         <c:when test="${discount > 0}">
                             <fmt:formatNumber value="${gocTotal - discount}" type="number"/> đ
                         </c:when>
                         <c:otherwise>
                             <c:choose>
                                 <c:when test="${mode == 'buynow'}">
                                     ${buyNowTotalFormatted}
                                 </c:when>
                                 <c:otherwise>
                                     ${cart.formatTotal}
                                 </c:otherwise>
                             </c:choose>
                         </c:otherwise>
                     </c:choose>
                </span>
                </div>
                <button type="submit" class="btn-order">
                    Đặt hàng
                </button>
            </div>
    </form>
</main>

<jsp:include page="common/footer.jsp"/>

<script src="${pageContext.request.contextPath}/assets/js/checkout.js" defer></script>

</body>
</html>
