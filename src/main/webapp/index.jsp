<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Cửa hàng bếp</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">
</head>

<body>

<jsp:include page="common/header.jsp"></jsp:include>


<main class="main-content">
    <section class="hero-banner swiper" id="hero-slider">
        <div class="swiper-wrapper">
            <c:forEach var ="b" items="${listBN}">
            <div class="swiper-slide hero-slide" style="
              background-image: url('${b.image}');
            ">
                <div class="hero-content">
                    <h1>${b.title}</h1>
                    <p>
                       ${b.description}
                    </p>
                    <a href="#" class="btn btn-primary">Khám Phá Ngay</a>
                </div>
            </div>
            </c:forEach>
        </div>
        <div class="swiper-pagination"></div>
    </section>

    <section class="trust-badges section-padding">
        <div class="container">
            <div class="trust-badge">
                <i class="fa fa-shield-halved"></i>
                <h3>Cam kết 100% Chính Hãng</h3>
            </div>
            <div class="trust-badge">
                <i class="fa fa-tools"></i>
                <h3>Miễn phí Lắp Đặt & Cài Đặt</h3>
            </div>
            <div class="trust-badge">
                <i class="fa fa-headset"></i>
                <h3>Hỗ trợ Kỹ thuật 24/7</h3>
            </div>
            <div class="trust-badge">
                <i class="fa fa-truck-fast"></i>
                <h3>Bảo hành Tận nhà</h3>
            </div>
        </div>
    </section>

    <section class="featured-categories section-padding">
        <div class="container">
            <h2 class="section-title">Danh mục Nổi bật</h2>
            <div class="category-grid">
                <c:forEach var="c" items="${topCategories}">
                    <a href="${pageContext.request.contextPath}/products?categoryId=${c.category_id}" class="category-item">
                        <img src="${c.logo}" alt="${c.category_name}" />
                        <span>${c.category_name}</span>
                    </a>
                </c:forEach>
            </div>
        </div>
    </section>

    <section class="best-sellers section-padding bg-light">
        <div class="container">
            <h2 class="section-title">Sản phẩm Bán chạy nhất</h2>
            <div class="swiper" id="bestseller-slider">
                <div class="swiper-wrapper">
                    <c:forEach var = "pbs" items="${listP}">
                    <div class="swiper-slide product-card">
                        <img src="${pbs.image}" alt="Sản phẩm" />
                        <h3>${pbs.product_name}</h3>
                        <div class="price">${pbs.priceFormat}</div>
                        <a href="${pageContext.request.contextPath}/product-detail?id=${pbs.product_id}" class="btn btn-secondary">
                            Xem chi tiết
                        </a>
                    </div>
                    </c:forEach>

                </div>
                <div class="swiper-button-next"></div>
                <div class="swiper-button-prev"></div>
            </div>
        </div>
    </section>

    <section class="shop-by-ecosystem section-padding">
        <div class="container">
            <h2 class="section-title">Mua theo Hệ sinh thái</h2>
            <div class="ecosystem-grid">
                <c:forEach var = "e" items="${listE}">
                <a href="detail-ecosystem?id=${e.id}" class="ecosystem-item" style="background-color: #e5e5e5">
                    <img src="${e.image}" alt="" />
                    <span>${e.name}</span>
                </a>
                </c:forEach>
            </div>
        </div>
    </section>

    <section class="solutions-combo section-padding bg-light">
        <div class="container">
            <h2 class="section-title">Gợi ý Giải pháp</h2>
            <div class="solutions-grid">
                <c:forEach var ="c" items="${listC}">
                <a href="combo?id=${c.id}" class="solution-item" style="
                    background-image: url('${c.image}');
                ">
                    <div class="solution-content">
                        <h3>${c.name}</h3>
                        <p>${c.content}</p>
                    </div>
                </a>
                </c:forEach>
            </div>
        </div>
    </section>

    <section class="content-hub section-padding">
        <div class="container">
            <h2 class="section-title">Góc Tư vấn & Đánh giá</h2>
            <div class="hub-grid">
                <div class="hub-video">
                    <iframe width="560" height="315"
                            src="https://www.youtube.com/embed/watch?v=6JdW3GRxF3w&list=RD6JdW3GRxF3w&start_radio=1"
                            title="YouTube video player" frameborder="0"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowfullscreen></iframe>
                </div>
                <div class="hub-articles">
                    <c:forEach var = "a" items="${listA}">
                    <a href="detail-article?id=${a.id}" class="article-item">
                        <h4>${a.title}</h4>
                        <p>${a.content}</p>
                    </a>
                    </c:forEach>
                </div>
            </div>
        </div>
    </section>

    <section class="testimonials section-padding bg-light">
        <div class="container">
            <h2 class="section-title">Khách hàng Nói về Chúng tôi</h2>
            <div class="swiper" id="testimonial-slider">
                <div class="swiper-wrapper">
                    <c:forEach var ="t" items="${homeComments}">
                    <div class="swiper-slide testimonial-item">
                        <p>
                            "${t.content}"
                        </p>
                        <h4>- ${t.username}</h4>
                    </div>
                    </c:forEach>

                </div>
                <div class="swiper-pagination"></div>
            </div>
        </div>
    </section>

    <section class="brands section-padding">
        <div class="container">
            <h2 class="section-title">Các Thương hiệu Hàng đầu</h2>
            <div class="swiper" id="brand-slider">
                <div class="swiper-wrapper">
                    <c:forEach var ="b" items="${topBrands}">
                    <div class="swiper-slide brand-item">
                        <a href="brand?id=${b.brand_id}">
                            <img src="${b.logo_url}" alt="${b.brand_name}" />
                        </a>
                    </div>

                    </c:forEach>


                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp"></jsp:include>


<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script src="assets/js/Main.js"></script>
</body>
</html>