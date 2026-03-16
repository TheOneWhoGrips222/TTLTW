<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page isELIgnored="false" %>


<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header_search.css">
<header class="header">
    <div class="header__top-bar">
        <div class="container">
            <span><i class="fa fa-phone"></i> Hỗ trợ Kỹ thuật: 1900.1234</span>
            <span><i class="fa fa-phone"></i> Kinh doanh: 1900.5678</span>
            <span class="spacer"></span>
            <a href="${pageContext.request.contextPath}/showroom">Hệ thống Showroom</a>
            <c:if test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/login">
                    <i class="fa fa-user"></i> Đăng nhập
                </a>
            </c:if>

            <c:if test="${not empty sessionScope.user}">
                <span class="user-info">
                    <i class="fa fa-user"></i>
                     Xin chào, ${sessionScope.user.username}
                </span>
                <a href="${pageContext.request.contextPath}/logout"
                   onclick="return confirmLogout();">
                    <i class="fa fa-sign-out-alt"></i> Đăng xuất
                </a>
            </c:if>
        </div>
    </div>

    <div class="header__main">
        <div class="container">
            <a href="Home" class="header__logo">
                <img src="assets/images/banners/logo.png" alt="TTB" />
            </a>

            <div class="header__search">
                <input type="text"
                       id="search-input"
                       placeholder="Tìm kiếm bếp từ, robot hút bụi..."
                       autocomplete="off"
                       onkeyup="handleSearch(this.value)"
                       onkeydown="if(event.key === 'Enter') performFullSearch()"
                />
                <button type="button" onclick="performFullSearch()">
                    <i class="fa fa-search"></i>
                </button>

                <div id="search-results" class="search-suggestions"></div>
            </div>
            <div class="header__actions">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/login">
                            <i class="fa fa-user"></i> Tài khoản
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/profile">
                            <i class="fa fa-user"></i> Tài khoản
                        </a>
                    </c:otherwise>
                </c:choose>
                <a href="wishlist"><i class="fa fa-heart"></i> Yêu thích</a>
                <a href="cart"><i class="fa fa-shopping-cart"></i> Giỏ hàng (${sessionScope.cart != null ? sessionScope.cart.totalQuantity : 0})</a>
            </div>
        </div>
    </div>

    <nav class="header__nav">
        <div class="container">
            <ul>
                <li class="nav-item has-megamenu">
                    <a href="${pageContext.request.contextPath}/products">Sản phẩm <i class="fa fa-chevron-down"></i></a>
                    <div class="mega-menu">
                        <c:forEach var="c" items="${applicationScope.categories}">
                            <a href="${pageContext.request.contextPath}/products?categoryId=${c.category_id}">
                                    ${c.category_name}
                            </a>
                        </c:forEach>
                    </div>

                </li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/listcombo">Giải pháp & Combo</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/arcticle">Góc Tư vấn</a></li>
                <li class="nav-item"><a href="DichVuLapDat.jsp">Dịch vụ Lắp đặt</a></li>
                <li class="nav-item"><a href="vechungtoi.jsp">Về chúng tôi</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/Promotion">Khuyến mãi</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ecos-list">Hệ sinh thái</a></li>
            </ul>
        </div>
    </nav>
</header>
<script src="${pageContext.request.contextPath}/assets/js/Logout.js"></script>

<script>
    let timeout = null;

    function handleSearch(keyword) {
        clearTimeout(timeout);
        const resultsBox = document.getElementById('search-results');

        if (!keyword || keyword.trim() === '') {
            resultsBox.style.display = 'none';
            return;
        }

        // Debounce 300ms
        timeout = setTimeout(() => {
            fetch('${pageContext.request.contextPath}/api/product-search?q=' + encodeURIComponent(keyword))
                .then(response => response.json())
                .then(data => {
                    if (data.length > 0) {
                        let html = '';
                        data.forEach(p => {
                            html += `
                                <a href="${pageContext.request.contextPath}/product-detail?id=${'${p.product_id}'}" class="search-item">
                                    <div class="search-info">
                                        <h5>${'${p.product_name}'}</h5>
                                        <span>${'${p.price_format}'}</span>
                                    </div>
                                </a>
                            `;
                        });
                        resultsBox.innerHTML = html;
                        resultsBox.style.display = 'block';
                    } else {
                        resultsBox.innerHTML = '<div style="padding:10px; text-align:center;">Không tìm thấy sản phẩm</div>';
                        resultsBox.style.display = 'block';
                    }
                })
                .catch(err => console.error(err));
        }, 300);
    }

    function performFullSearch() {
        const keyword = document.getElementById('search-input').value;
        if (keyword.trim()) {
            window.location.href = '${pageContext.request.contextPath}/products?search=' + encodeURIComponent(keyword.trim());
        }
    }

    // Click ra ngoài thì đóng gợi ý
    document.addEventListener('click', function(e) {
        const searchBox = document.querySelector('.header__search');
        const resultsBox = document.getElementById('search-results');
        if (searchBox && !searchBox.contains(e.target)) {
            resultsBox.style.display = 'none';
        }
    });
</script>