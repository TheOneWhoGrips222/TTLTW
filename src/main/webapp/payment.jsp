<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán đơn hàng - #${order.order_id}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/payment.css">

    <style>
        /* Đảm bảo container này luôn tuân thủ 1200px */
        .fix-width-1200 {
            max-width: 1200px !important;
            width: 100% !important;
            margin-left: auto !important;
            margin-right: auto !important;
            padding-left: 15px;
            padding-right: 15px;
            box-sizing: border-box;
        }
    </style>
</head>

<body>

<jsp:include page="common/header.jsp"/>

<main class="profile-page">
    <div class="container profile-layout fix-width-1200">

        <section class="profile-content">

            <h2 class="payment-title">Thanh toán đơn hàng</h2>

            <div class="payment-card">
                <div class="payment-header">
                    <div>
                        <i class="fa-solid fa-receipt"></i> Mã đơn: <b>#${order.order_id}</b>
                    </div>
                    <div class="status waiting">
                        <i class="fa-regular fa-clock"></i> Chờ thanh toán
                    </div>
                </div>

                <c:forEach items="${orderItems}" var="i">
                    <div class="payment-product">
                        <img src="${i.productImage}" alt="${i.productName}" onerror="this.src='https://via.placeholder.com/80'">
                        <div class="info">
                            <div class="name">${i.productName}</div>
                            <div class="qty">Số lượng: x${i.quantity}</div>
                        </div>
                        <div class="price">
                                ${i.price_at_purchase} đ
                        </div>
                    </div>
                </c:forEach>

                <div class="payment-summary">
                    <div>
                        <span>Phương thức thanh toán</span>
                        <span style="font-weight: 500;">
                             <c:choose>
                                 <c:when test="${order.payment_method eq 'BANK'}">Chuyển khoản ngân hàng</c:when>
                                 <c:when test="${order.payment_method eq 'VNPAY'}">Ví VNPAY / QR Code</c:when>
                                 <c:otherwise>${order.payment_method}</c:otherwise>
                             </c:choose>
                        </span>
                    </div>
                    <div>
                        <span>Tổng thanh toán</span>
                        <span class="total">${order.formattedTotal}</span>
                    </div>
                </div>
            </div>

            <div class="payment-card">
                <h3><i class="fa-regular fa-credit-card"></i> Thông tin thanh toán</h3>

                <c:if test="${order.payment_method eq 'BANK'}">
                    <div style="padding-bottom: 10px;">
                        <p><b>Ngân hàng:</b> Vietcombank</p>
                        <p><b>Số tài khoản:</b> <span style="font-family: monospace; font-size: 16px;">0123456789</span></p>
                        <p><b>Chủ tài khoản:</b> WEB THIẾT BỊ BẾP</p>
                        <p class="note">
                            <i class="fa-solid fa-circle-info"></i> Nội dung chuyển khoản:
                            <b style="color: #c62828;">TT DON #${order.order_id}</b>
                        </p>
                    </div>
                </c:if>

                <c:if test="${order.payment_method eq 'VNPAY'}">
                    <div style="text-align: center; padding: 30px;">
                        <p>Vui lòng nhấn nút <b>"Thanh toán ngay"</b> bên dưới để chuyển sang cổng thanh toán VNPAY.</p>
                        <i class="fa-solid fa-shield-halved" style="font-size: 40px; color: #005b9f; margin-top: 10px;"></i>
                    </div>
                </c:if>
            </div>

            <div class="payment-actions">
                <a href="orders" class="btn-secondary">
                    <i class="fa-solid fa-arrow-left"></i> Xem đơn hàng
                </a>

                <form action="confirm-payment" method="post" style="margin: 0;">
                    <input type="hidden" name="orderId" value="${order.order_id}">
                    <button class="btn-primary" type="submit">
                        <c:if test="${order.payment_method eq 'VNPAY'}">Thanh toán ngay</c:if>
                        <c:if test="${order.payment_method ne 'VNPAY'}">Tôi đã thanh toán</c:if>
                    </button>
                </form>
            </div>

        </section>

    </div>
</main>

<jsp:include page="common/footer.jsp"/>

</body>
</html>