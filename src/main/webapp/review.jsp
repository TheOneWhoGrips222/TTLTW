<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đánh giá sản phẩm</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/review.css">

</head>

<body>

<jsp:include page="common/header.jsp"/>

<div class="review-container">

    <div class="review-title">
        Đánh giá sản phẩm
    </div>

    <c:if test="${not empty error}">
        <div class="error">
                ${error}
        </div>
    </c:if>

    <div class="product-box">

        <img src="${product.image}" alt="">

        <div>
            <div class="product-name">
                ${product.product_name}
            </div>

            <div>
                Đơn hàng #${order.order_id}
            </div>
        </div>

    </div>

    <form action="${pageContext.request.contextPath}/review"
          method="post">

        <input type="hidden"
               name="productId"
               value="${product.product_id}">

        <input type="hidden"
               name="orderId"
               value="${order.order_id}">

        <div class="rating-group">

            <h3>Chọn số sao</h3>

            <div class="star-wrapper">

                <label>
                    <input type="radio" name="rating" value="1" required>
                    <span>★</span>
                </label>

                <label>
                    <input type="radio" name="rating" value="2">
                    <span>★</span>
                </label>

                <label>
                    <input type="radio" name="rating" value="3">
                    <span>★</span>
                </label>

                <label>
                    <input type="radio" name="rating" value="4">
                    <span>★</span>
                </label>

                <label>
                    <input type="radio" name="rating" value="5">
                    <span>★</span>
                </label>

            </div>

        </div>

        <div>

            <h3>Nhận xét của bạn</h3>

            <textarea
                    name="comment"
                    maxlength="1000"
                    placeholder="Hãy chia sẻ trải nghiệm của bạn về sản phẩm này..."
                    required></textarea>

        </div>

        <button type="submit" class="btn-submit">
            Gửi đánh giá
        </button>

    </form>

</div>

<jsp:include page="common/footer.jsp"/>

</body>
</html>