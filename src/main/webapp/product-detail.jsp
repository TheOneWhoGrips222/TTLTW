<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>


<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>${product.product_name}</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product-detail.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

</head>

<body>
<jsp:include page="common/header.jsp"/>

<main class="product-detail">
  <div class="container">

    <!-- THÔNG TIN CHÍNH -->
    <div class="product-main">

      <div class="product-gallery">
        <div class="product-image">
          <img id="mainImage"
               src="${images[0].image_url}"
               alt="${product.product_name}">
        </div>

        <div class="product-thumbnails">
          <c:forEach var="img" items="${images}" varStatus="status">
            <img src="${img.image_url}"
                 class="${status.index == 0 ? 'active' : ''}"
                 onclick="changeImage(this)">
          </c:forEach>
        </div>
      </div>

      <div class="product-info">
          <c:if test="${not empty sessionScope.message}">
              <div class="${sessionScope.messageType == 'success' ? 'cart-alert-success' : 'cart-alert-error'}">
                  <i class="fa ${sessionScope.messageType == 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
                      ${sessionScope.message}
                  <c:remove var="message" scope="session" />
                  <c:remove var="messageType" scope="session" />
              </div>
          </c:if>
        <h1>${product.product_name}</h1>

        <p class="price">${product.priceFormat}</p>

        <p class="description">
          ${product.description}
        </p>

        <div class="actions">
          <a href="add-cart?id=${product.product_id}&q=1" class="btn btn-primary">
            <i class="fa fa-cart-plus"></i> Thêm vào giỏ
          </a>

          <a href="${pageContext.request.contextPath}/buy-now?id=${product.product_id}"
             class="btn btn-danger">
            <i class="fa fa-bolt"></i> Mua ngay
          </a>



            <a href="${pageContext.request.contextPath}/wishlist?action=add&product_id=${product.product_id}"
               title="Thêm vào yêu thích"
               style="
     display: inline-flex;
     align-items: center;
     gap: 6px;
     padding: 8px 14px;
     border: 1px solid #e74c3c;
     border-radius: 20px;
     color: #e74c3c;
     background-color: transparent;
     font-size: 14px;
     font-weight: 500;
     text-decoration: none;
     transition: all 0.3s ease;
   "
               onmouseover="this.style.backgroundColor='#e74c3c'; this.style.color='#fff';"
               onmouseout="this.style.backgroundColor='transparent'; this.style.color='#e74c3c';"
            >
              <i class="fa fa-heart"></i> Yêu thích
            </a>

          </a>
        </div>
      </div>
    </div>

    <!-- TÍNH NĂNG -->
    <div class="product-features">
      <h2>Tính năng nổi bật</h2>
      <ul>
        <c:forEach var="f" items="${features}">
          <li>${f.featureText}</li>
        </c:forEach>
      </ul>
    </div>

    <!-- SẢN PHẨM TƯƠNG TỰ -->
    <div class="related-products">
      <h2>Sản phẩm tương tự</h2>

      <div class="related-grid">
        <c:forEach var="p" items="${relatedProducts}">
          <div class="related-card">
            <img src="${p.image}">
            <h4>${p.product_name}</h4>
            <p>${p.priceFormat}</p>
            <a href="${pageContext.request.contextPath}/product-detail?id=${p.product_id}" class="btn btn-secondary">
              Xem chi tiết
            </a>
          </div>
        </c:forEach>
      </div>
    </div>

  </div>
</main>

<div class="product-comments">
  <h2>Bình luận sản phẩm</h2>

  <c:if test="${not empty sessionScope.user}">
    <form action="${pageContext.request.contextPath}/product-comment" method="post">
      <input type="hidden" name="product_id" value="${product.product_id}">
      <textarea name="content" required
                placeholder="Nhập bình luận của bạn..."></textarea>
      <button type="submit" class="btn btn-primary">
        Gửi bình luận
      </button>
    </form>
  </c:if>

  <c:if test="${empty sessionScope.user}">
    <p>
      <a href="${pageContext.request.contextPath}/login">
        Đăng nhập
      </a> để bình luận.
    </p>
  </c:if>

  <div class="comment-list">
    <c:forEach var="c" items="${comments}">
      <div class="comment-item">
        <strong>${c.username}</strong>
        <span class="time">${c.createdAtFormat}</span>
        <p>${c.content}</p>
      </div>
    </c:forEach>
  </div>
</div>

<jsp:include page="common/footer.jsp"></jsp:include>
<script src="assets/js/product-detail.js"></script>
</body>
</html>
