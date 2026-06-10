<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn mua</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/orders.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/payment.css">

</head>
<body>
<jsp:include page="common/header.jsp"/>
<div class="payment-result-container">

    <div class="payment-result-card">


        <c:choose>

            <c:when test="${order.payment_status == 'PAID'}">

                <div class="payment-result-icon success">
                    <i class="fa-solid fa-circle-check"></i>
                </div>

                <h1 class="payment-result-title">
                    Thanh toán thành công
                </h1>

                <p class="payment-result-message">
                    Đơn hàng #${order.order_id}
                    đã được thanh toán thành công.
                </p>

            </c:when>

            <c:otherwise>

                <div class="payment-result-icon fail">
                    <i class="fa-solid fa-circle-xmark"></i>
                </div>

                <h1 class="payment-result-title">
                    Thanh toán thất bại
                </h1>

                <p class="payment-result-message">
                    Giao dịch đã bị hủy hoặc không thể hoàn tất.
                </p>

            </c:otherwise>

        </c:choose>

        <a href="${pageContext.request.contextPath}/orders"
           class="payment-result-btn">
            Xem đơn hàng
        </a>

    </div>

</div>
<jsp:include page="common/footer.jsp"/>
</body>
</html>