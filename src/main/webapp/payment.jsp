<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả thanh toán</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/payment.css">
</head>
<body>

<div class="payment-container">

    <div class="payment-card">

        <c:choose>

            <c:when test="${order.payment_status eq 'PAID'}">
                <div class="icon success">
                    ✓
                </div>
                <h1>Thanh toán thành công</h1>
                <p>
                    Đơn hàng #${order.order_id}
                    đã được thanh toán thành công.
                </p>

            </c:when>

            <c:when test="${order.payment_status eq 'FAILED'}">
                <div class="icon fail">
                    ✕
                </div>
                <h1>Thanh toán thất bại</h1>
                <p>
                    Giao dịch đã bị hủy hoặc không thể hoàn tất.
                </p>

            </c:when>


        </c:choose>

        <a href="${pageContext.request.contextPath}/orders"
           class="btn">
            Xem đơn hàng
        </a>

    </div>

</div>

</body>
</html>