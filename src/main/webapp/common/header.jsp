<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page isELIgnored="false" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header_search.css">
<style>
    .btn-admin-panel {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 5px 14px;
        background: #4f46e5;
        color: #fff !important;
        border-radius: 20px;
        font-size: 0.82rem;
        font-weight: 600;
        text-decoration: none !important;
        transition: background 0.15s;
    }
    .btn-admin-panel:hover { background: #4338ca; }

    #logoutOverlayMain {
        display: none;
        position: fixed;
        inset: 0;
        background: rgba(0,0,0,0.45);
        z-index: 99999;
        align-items: center;
        justify-content: center;
    }
    #logoutOverlayMain.show { display: flex; }
    #logoutBoxMain {
        background: #fff;
        border-radius: 14px;
        padding: 32px 36px;
        text-align: center;
        box-shadow: 0 8px 32px rgba(0,0,0,0.18);
        min-width: 260px;
    }
    #logoutBoxMain i { font-size: 2rem; color: #ef4444; margin-bottom: 10px; }
    #logoutBoxMain h3 { margin: 0 0 6px; font-size: 1.05rem; color: #1f2937; }
    #logoutBoxMain p  { font-size: 0.86rem; color: #6b7280; margin-bottom: 18px; }
    #logoutBoxMain .box-btns { display: flex; gap: 10px; justify-content: center; }
    #logoutBoxMain .box-btns button {
        padding: 8px 20px; border: none; border-radius: 8px;
        font-size: 0.9rem; cursor: pointer; font-weight: 600;
    }
    #logoutBoxMain .btn-cancel-m  { background: #f3f4f6; color: #374151; }
    #logoutBoxMain .btn-confirm-m { background: #ef4444; color: #fff; }
    #logoutBoxMain .countdown-m   { font-size: 0.8rem; color: #9ca3af; margin-top: 8px; display:none; }
</style>

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
                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-admin-panel">
                        <i class="fa-solid fa-gauge"></i> Trang Admin
                    </a>
                </c:if>
                <span class="user-info">
                    <i class="fa fa-user"></i> Xin chào, ${sessionScope.user.username}
                </span>
                <a href="#" onclick="showLogoutMain(); return false;">
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
                <li class="nav-item"><a href="${pageContext.request.contextPath}/list-voucher">Voucher</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/ecos-list">Hệ sinh thái</a></li>
            </ul>
        </div>
    </nav>
</header>

<%-- Hộp thoại xác nhận đăng xuất --%>
<div id="logoutOverlayMain">
    <div id="logoutBoxMain">
        <i class="fa-solid fa-right-from-bracket"></i>
        <h3>Xác nhận đăng xuất</h3>
        <p>Bạn sẽ được chuyển về trang chủ sau khi đăng xuất.</p>
        <div class="box-btns">
            <button class="btn-cancel-m" onclick="hideLogoutMain()">Hủy</button>
            <button class="btn-confirm-m" onclick="doLogoutMain()">Đăng xuất</button>
        </div>
        <p class="countdown-m" id="countdownMain"></p>
    </div>
</div>

<script>
    function showLogoutMain() {
        document.getElementById('logoutOverlayMain').classList.add('show');
    }
    function hideLogoutMain() {
        document.getElementById('logoutOverlayMain').classList.remove('show');
        clearInterval(window._logoutTimerMain);
        document.getElementById('countdownMain').style.display = 'none';
    }
    function doLogoutMain() {
        var countEl = document.getElementById('countdownMain');
        countEl.style.display = 'block';
        document.querySelector('.btn-confirm-m').disabled = true;
        document.querySelector('.btn-cancel-m').disabled  = true;
        var sec = 1;
        countEl.textContent = 'Đang đăng xuất... (' + sec + 's)';
        window._logoutTimerMain = setInterval(function() {
            sec--;
            if (sec <= 0) {
                clearInterval(window._logoutTimerMain);
                window.location.href = '${pageContext.request.contextPath}/logout';
            } else {
                countEl.textContent = 'Đang đăng xuất... (' + sec + 's)';
            }
        }, 1000);
    }
    document.getElementById('logoutOverlayMain').addEventListener('click', function(e) {
        if (e.target === this) hideLogoutMain();
    });

    let timeout = null;
    function handleSearch(keyword) {
        clearTimeout(timeout);
        const resultsBox = document.getElementById('search-results');
        if (!keyword || keyword.trim() === '') { resultsBox.style.display = 'none'; return; }
        timeout = setTimeout(() => {
            fetch('${pageContext.request.contextPath}/api/product-search?q=' + encodeURIComponent(keyword))
                .then(r => r.json())
                .then(data => {
                    if (data.length > 0) {
                        let html = '';
                        data.forEach(p => {
                            html += `<a href="${pageContext.request.contextPath}/product-detail?id=${p.product_id}" class="search-item">
                                        <div class="search-info"><h5>${p.product_name}</h5><span>${p.price_format}</span></div>
                                     </a>`;
                        });
                        resultsBox.innerHTML = html;
                    } else {
                        resultsBox.innerHTML = '<div style="padding:10px;text-align:center;">Không tìm thấy sản phẩm</div>';
                    }
                    resultsBox.style.display = 'block';
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
    document.addEventListener('click', function(e) {
        const searchBox  = document.querySelector('.header__search');
        const resultsBox = document.getElementById('search-results');
        if (searchBox && !searchBox.contains(e.target)) resultsBox.style.display = 'none';
    });
</script>
