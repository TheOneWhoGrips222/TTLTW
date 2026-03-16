<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sản phẩm yêu thích</title>
    <link rel="stylesheet" href="assets/css/yeuthich.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&family=Manrope:wght@600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/index.css">
    <link rel="stylesheet" href="assets/css/Header.css">
    <link rel="stylesheet" href="assets/css/main.css">

    <script src="assets/js/giohang.js"></script>


</head>
<body>

<jsp:include page="/common/header.jsp" />

<main class="main-content">
    <section class="wishlist-section section-padding">
        <div class="container">
            <h1 class="section-title">Sản phẩm Yêu thích</h1>

            <div class="wishlist-grid">


                <c:if test="${empty wishlist}">
                    <div style="text-align: center; width: 100%; padding: 50px;">
                        <i class="fa-regular fa-heart" style="font-size: 50px; color: #ccc; margin-bottom: 20px;"></i>
                        <p>Bạn chưa có sản phẩm yêu thích nào.</p>
                        <a href="products" class="btn btn-primary" style="margin-top: 10px;">Tiếp tục mua sắm</a>
                    </div>
                </c:if>


                <c:forEach var="p" items="${wishlist}">
                    <div class="product-card wishlist-item">


                        <form action="wishlist" method="post" style="position: absolute; right: 10px; top: 10px; z-index: 10;">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="product_id" value="${p.product_id}">
                            <button type="submit" class="wishlist-remove-btn" title="Xóa khỏi yêu thích"
                                    style="border:none; background:white; cursor:pointer; width: 30px; height: 30px; border-radius: 50%; box-shadow: 0 2px 5px rgba(0,0,0,0.2);">
                                <i class="fa fa-times" style="color: #ff4d4f;"></i>
                            </button>
                        </form>

                        <div class="product-img-thumb" style="margin-bottom: 15px;">
                            <img src="${p.image}" alt="${p.product_name}" style="width: 100%; height: auto; object-fit: cover;">
                        </div>

                        <h3 style="font-size: 16px; margin-bottom: 5px;">${p.product_name}</h3>

                        <div class="price">
                                ${p.priceFormat}
                        </div>
                                <a href="add-cart?id=${p.product_id}&q=1" class="btn btn-primary">Thêm vào giỏ hàng</a>

                    </div>
                </c:forEach>

            </div>
        </div>
    </section>
</main>

<jsp:include page="/common/footer.jsp" />

</body>
</html>