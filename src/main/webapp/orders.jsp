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
                <li class="active"><a href="orders">Đơn mua</a></li>
            </ul>
        </aside>

        <section class="profile-content">

            <c:set var="currentStatus" value="${param.status}" />

            <div class="order-tabs">
                <a class="${empty currentStatus ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/orders">
                    Tất cả
                </a>

                <a class="${currentStatus eq 'CHO_XAC_NHAN' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/orders?status=CHO_XAC_NHAN">
                    Chờ xác nhận
                </a>

                <a class="${currentStatus eq 'VAN_CHUYEN' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/orders?status=VAN_CHUYEN">
                    Vận chuyển
                </a>

                <a class="${currentStatus eq 'CHO_GIAO_HANG' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/orders?status=CHO_GIAO_HANG">
                    Chờ giao hàng
                </a>

                <a class="${currentStatus eq 'HOAN_THANH' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/orders?status=HOAN_THANH">
                    Hoàn thành
                </a>

                <a class="${currentStatus eq 'DA_HUY' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/orders?status=DA_HUY">
                    Đã huỷ
                </a>
            </div>


            <c:if test="${empty orders}">
                <p style="text-align:center;margin-top:40px">Bạn chưa có đơn hàng nào.</p>
            </c:if>

            <c:forEach var="o" items="${orders}">
                <div class="order-card">


                    <div class="order-header">
                        <div>Mã đơn: #${o.order_id}</div>
                        <div class="order-status">${o.statusText}</div>
                    </div>


                    <c:forEach var="p" items="${orderProducts[o.order_id]}">
                        <div class="order-product">
                            <img src="${p.image}" alt="">
                            <div class="info">
                                <div class="name">${p.product_name}</div>
                                <div class="price">
                                        ${p.priceFormat}
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Footer -->
                    <div class="order-footer">
                        <div>
                            Phương thức: <b>${o.payment_method}</b>
                        </div>

                        <div class="total">
                            Thành tiền:
                            <span>${o.formattedTotal}</span>

                        </div>

                        <div class="actions">
                            <c:if test="${o.status eq 'CHO_THANH_TOAN'}">
                                <a href="payment?orderId=${o.order_id}" class="btn-primary">
                                    Thanh toán ngay
                                </a>

                                <form action="cancel-order" method="post" style="display:inline">
                                    <input type="hidden" name="order_id" value="${o.order_id}">
                                    <button class="btn-cancel">Huỷ đơn</button>
                                </form>
                            </c:if>



                            <c:if test="${o.status eq 'HOAN_THANH'}">
                                <button>Mua lại</button>
                                <button>Đánh giá</button>
                            </c:if>

                            <c:if test="${o.status eq 'CHO_XAC_NHAN'}">
                                <form action="${pageContext.request.contextPath}/cancel-order" method="post" style="display:inline">
                                    <input type="hidden" name="order_id" value="${o.order_id}">
                                    <button class="btn-cancel">Huỷ đơn</button>
                                </form>
                            </c:if>


                            <c:if test="${o.status eq 'DA_HUY'}">
                                <span class="cancel">Đã bị huỷ</span>
                            </c:if>

                        </div>
                    </div>

                </div>
            </c:forEach>

        </section>

    </div>
</main>

<jsp:include page="common/footer.jsp"/>

</body>
</html>
