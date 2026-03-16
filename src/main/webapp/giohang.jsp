
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - Thế Giới Bếp Thông Minh</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&family=Manrope:wght@600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/index.css">
    <link rel="stylesheet" href="assets/css/Header.css">
    <script src="assets/js/giohang.js"></script>
    <link rel="stylesheet" href="assets/css/main.css">
    <link rel="stylesheet" href="assets/css/giohang.css">
</head>
<body>

<jsp:include page="common/header.jsp"></jsp:include>

<main class="main-content">
    <section class="cart-section section-padding">
        <div class="container">
            <c:if test="${not empty sessionScope.message}">
                <div class="cart-alert-error">
                    <i class="fa fa-exclamation-triangle"></i> ${sessionScope.message}
                    <c:remove var="message" scope="session" />
                </div>
            </c:if>
            <h1 class="section-title">Giỏ hàng của bạn</h1>

            <div class="cart-container">

                <div class="cart-items-list">
                    <table class="cart-table">
                        <thead>
                        <tr>

                            <th>Sản phẩm</th>
                            <th>Giá</th>
                            <th>Số lượng</th>
                            <th>Tạm tính</th>
                            <th>Xóa</th>
                        </tr>
                        </thead>
                        <tbody>

                        <c:forEach items="${sessionScope.cart.items }" var = "ci">
                            <tr class="cart-item-row" data-price="15000000">

                                <td class="cart-item-info">
                                    <a href="#" class="cart-item-name">${ci.product.product_name}</a>
                                    <div class="cart-item-details">
                                        <img src="${ci.product.image}" alt="Sản phẩm">
                                        <small>Thương hiệu: ${data[ci.product.product_id]}</small>
                                    </div>
                                </td>
                                <td class="cart-item-price" data-label="Giá">${ci.product.priceFormat}</td>
                                <td class="cart-item-quantity" data-label="Số lượng">
                                    <form action="update-cart" method="post">
                                        <input type="hidden" name="id" value="${ci.product.product_id}">
                                    <div class="quantity-control">
                                        <button type="submit" name="action" value="down" class="btn-qty">-</button>
                                        <input type="number" class="quantity-input" value="${ci.quantity}" min="1">
                                        <button type="submit" name="action" value="up" class="btn-qty">+</button>
                                    </div>
                                    </form>
                                </td>
                                <td class="cart-item-subtotal" data-label="Tạm tính">${ci.formattedTotal}</td>
                                <td class="cart-item-remove" data-label="Xóa">
                                    <form action="del-item" method="post">
                                        <input type = "hidden" name = "id" value ="${ci.product.product_id}">

                                        <button type = "submit" class="cart-remove-btn"><i class="fa fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>

                        </tbody>
                    </table>
                    <div class="cart-actions-footer">
                        <form action="delete-all" method="post" onsubmit="return confirm('Chắc chắn muốn xóa toàn bộ giỏ hàng?');">
                            <button type="submit" class="btn-clear-all">
                                <i class="fa fa-trash"></i> Xóa tất cả
                            </button>
                        </form>
                    </div>
                </div>

                <div class="cart-summary">
                    <h3>Tổng quan Đơn hàng</h3>
                    <div class="summary-row">
                        <span>Tạm tính</span>
                        <span id="cart-subtotal">${sessionScope.cart.formatTotal}</span>
                    </div>
                    <div class="summary-row">
                        <span>Phí vận chuyển</span>
                        <span>Miễn phí</span>
                    </div>
                    <div class="summary-row total-row">
                        <span>Tổng cộng</span>
                        <span id="cart-total">${sessionScope.cart.formatTotal}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/checkout?mode=cart" class="btn btn-primary checkout-btn">Tiến hành Thanh toán</a>
                    <a href="../../index.html" class="continue-shopping-link">
                        <i class="fa fa-arrow-left"></i> Tiếp tục mua sắm
                    </a>
                </div>

            </div>
        </div>
    </section>
</main>
<jsp:include page="common/footer.jsp"></jsp:include>
</body>
</html>