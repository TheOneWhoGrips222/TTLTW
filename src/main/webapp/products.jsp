<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <title>Tất cả sản phẩm - Bếp Thông Minh TTB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/products.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>

<body>
<jsp:include page="common/header.jsp"></jsp:include>

<main class="main-content">
    <div class="breadcrumb section-padding" style="padding-bottom: 0;">
        <div class="container">
            <p> <span style="color: var(--text-secondary);">Tất cả sản phẩm</span></p>
        </div>
    </div>

    <section class="shop-section section-padding">
        <div class="container">
            <div class="shop-layout">

                <!-- SIDEBAR: BỘ LỌC -->
                <aside class="shop-sidebar">
                    <form method="get" action="${pageContext.request.contextPath}/products">
                    <div class="filter-group">
                        <h3>Thương hiệu</h3>
                        <input type="hidden" name="categoryId" value="${categoryId}" />
                        <c:forEach var="b" items="${brandList}">
                            <label>
                                <input type="radio"
                                       name="brand"
                                       value="${b.brand_id}"
                                <c:if test="${brands != null && brands[0] == b.brand_id}">
                                       checked
                                </c:if>
                                >
                                    ${b.brand_name}

                            </label>
                        </c:forEach>
                        </div>
                        <input type="hidden" name="sort" value="${sort}" />
                        <div class="filter-group">
                            <h3>Khoảng giá</h3>
                            <input type="hidden" name="categoryId" value="${categoryId}" />
                            <label><input type="radio" name="priceRange" value="1" ${priceRange=='1'?'checked':''}> Dưới 5 triệu</label>
                            <label><input type="radio" name="priceRange" value="2" ${priceRange=='2'?'checked':''}> 5 - 10 triệu</label>
                            <label><input type="radio" name="priceRange" value="3" ${priceRange=='3'?'checked':''}> 10 - 20 triệu</label>
                            <label><input type="radio" name="priceRange" value="4" ${priceRange=='4'?'checked':''}> Trên 20 triệu</label>
                        </div>

                        <button type="submit" class="btn btn-primary">Lọc sản phẩm</button>
                    </form>
                </aside>

                <div class="shop-main">
                    <div class="shop-header">
                        <c:if test="${not empty searchKeyword}">
                            <div class="search-result-alert" style="margin-bottom: 20px;">
                                <h3>Kết quả tìm kiếm cho: "<span>${searchKeyword}</span>"</h3>
                                <p>Tìm thấy ${totalProducts} sản phẩm.</p>
                            </div>
                        </c:if>

                        <c:if test="${empty products}">
                            <div class="no-products">
                                <p>Không tìm thấy sản phẩm nào phù hợp.</p>
                                <a href="products" class="btn btn-primary">Xem tất cả sản phẩm</a>
                            </div>
                        </c:if>
                        <h1>Tất cả sản phẩm</h1>
                        <form method="get" action="${pageContext.request.contextPath}/products">
                            <input type="hidden" name="priceRange" value="${priceRange}" />
                        <div class="sort-box">
                            <label>Sắp xếp:</label>
                            <input type="hidden" name="categoryId" value="${categoryId}" />
                            <select name="sort" onchange="this.form.submit()">
                                <option value="newest" ${sort=='newest' || sort==null?'selected':''}>Mới nhất</option>
                                <option value="price_asc" ${sort=='price_asc'?'selected':''}>Giá tăng dần</option>
                                <option value="price_desc" ${sort=='price_desc'?'selected':''}>Giá giảm dần</option>
                            </select>
                        </div>
                        </form>
                    </div>

                    <div class="shop-product-grid">
                        <c:forEach var="p" items="${products}">
                            <div class="product-card">
                                <img src="${p.image}">
                                <h3>${p.product_name}</h3>
                                <h3>${p.description}</h3>
                                <div class="price">${p.priceFormat}</div>
                                <a href="${pageContext.request.contextPath}/product-detail?id=${p.product_id}" class="btn btn-secondary">
                                    Xem chi tiết
                                </a>
                            </div>
                        </c:forEach>
                    </div>

                    <c:set var="startPage" value="${currentPage - 2}" />
                    <c:set var="endPage" value="${currentPage + 2}" />

                    <c:if test="${startPage < 1}">
                        <c:set var="startPage" value="1" />
                    </c:if>

                    <c:if test="${endPage > totalPages}">
                        <c:set var="endPage" value="${totalPages}" />
                    </c:if>


                    <div class="pagination">

                        <!-- VỀ TRANG ĐẦU -->
                        <c:if test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/products?page=1
                                <c:if test='${categoryId != null}'>&categoryId=${categoryId}</c:if>
                                <c:if test='${priceRange != null}'>&priceRange=${priceRange}</c:if>
                                <c:if test='${sort != null}'>&sort=${sort}</c:if>
                                <c:if test='${brands != null}'>&brand=${brands[0]}</c:if>">
                                                                &laquo;
                            </a>

                            <a href="${pageContext.request.contextPath}/products?page=${currentPage - 1}
                                <c:if test='${categoryId != null}'>&categoryId=${categoryId}</c:if>
                                <c:if test='${priceRange != null}'>&priceRange=${priceRange}</c:if>
                                <c:if test='${sort != null}'>&sort=${sort}</c:if>
                                <c:if test='${brands != null}'>&brand=${brands[0]}</c:if>">
                                                                &lsaquo;
                            </a>
                        </c:if>

                        <!-- CÁC TRANG GIỮA -->
                        <c:forEach begin="${startPage}" end="${endPage}" var="i">
                            <a class="${i == currentPage ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/products?page=${i}
                                <c:if test='${categoryId != null}'>&categoryId=${categoryId}</c:if>
                                <c:if test='${priceRange != null}'>&priceRange=${priceRange}</c:if>
                                <c:if test='${sort != null}'>&sort=${sort}</c:if>
                                <c:if test='${brands != null}'>&brand=${brands[0]}</c:if>">
                                                                    ${i}
                            </a>
                        </c:forEach>

                        <!-- VỀ TRANG CUỐI -->
                        <c:if test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/products?page=${currentPage + 1}
                                <c:if test='${categoryId != null}'>&categoryId=${categoryId}</c:if>
                                <c:if test='${priceRange != null}'>&priceRange=${priceRange}</c:if>
                                <c:if test='${sort != null}'>&sort=${sort}</c:if>
                                <c:if test='${brands != null}'>&brand=${brands[0]}</c:if>">
                                                                &rsaquo;
                            </a>

                            <a href="${pageContext.request.contextPath}/products?page=${totalPages}
                                <c:if test='${categoryId != null}'>&categoryId=${categoryId}</c:if>
                                <c:if test='${priceRange != null}'>&priceRange=${priceRange}</c:if>
                                <c:if test='${sort != null}'>&sort=${sort}</c:if>
                                <c:if test='${brands != null}'>&brand=${brands[0]}</c:if>">
                                &raquo;
                            </a>
                        </c:if>

                    </div>

                </div>
            </div>
        </div>
    </section>
</main>
<jsp:include page="common/footer.jsp"></jsp:include>

</body>
</html>