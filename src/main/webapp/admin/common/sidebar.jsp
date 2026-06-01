<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
<style>
    .sidebar-footer {
        display: flex;
        flex-direction: column;
        gap: 6px;
        padding: 12px 16px;
    }
    .sidebar-footer a {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 14px;
        border-radius: 8px;
        font-size: 0.9rem;
        text-decoration: none;
        transition: background 0.15s;
    }
    .sidebar-footer .btn-home {
        background: rgba(255,255,255,0.1);
        color: var(--admin-white, #fff);
    }
    .sidebar-footer .btn-home:hover {
        background: rgba(255,255,255,0.2);
    }
    .sidebar-footer .btn-logout {
        background: rgba(239,68,68,0.15);
        color: #fca5a5;
    }
    .sidebar-footer .btn-logout:hover {
        background: rgba(239,68,68,0.3);
        color: #fff;
    }
    #logoutOverlay {
        display: none;
        position: fixed;
        inset: 0;
        background: rgba(0,0,0,0.45);
        z-index: 9999;
        align-items: center;
        justify-content: center;
    }
    #logoutOverlay.show { display: flex; }
    #logoutBox {
        background: #fff;
        border-radius: 14px;
        padding: 32px 36px;
        text-align: center;
        box-shadow: 0 8px 32px rgba(0,0,0,0.18);
        min-width: 260px;
    }
    #logoutBox i { font-size: 2.2rem; color: #ef4444; margin-bottom: 12px; }
    #logoutBox h3 { margin: 0 0 6px; font-size: 1.1rem; color: #1f2937; }
    #logoutBox p  { font-size: 0.88rem; color: #6b7280; margin-bottom: 20px; }
    #logoutBox .box-btns { display: flex; gap: 10px; justify-content: center; }
    #logoutBox .box-btns button {
        padding: 9px 22px; border: none; border-radius: 8px;
        font-size: 0.9rem; cursor: pointer; font-weight: 600;
    }
    #logoutBox .box-btns .btn-cancel  { background: #f3f4f6; color: #374151; }
    #logoutBox .box-btns .btn-confirm { background: #ef4444; color: #fff; }
    #logoutBox .countdown { font-size: 0.82rem; color: #9ca3af; margin-top: 10px; }
</style>

<nav class="admin-sidebar">
    <div class="sidebar-header">
        <h3>Admin Panel</h3>
    </div>
    <ul class="sidebar-menu">
        <li>
            <a href="<%=request.getContextPath()%>/admin/dashboard">
                <i class="fa-solid fa-chart-line"></i>
                <span>Tổng quan</span>
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/admin/order">
                <i class="fa-solid fa-file-invoice-dollar"></i>
                <span>Quản lý Đơn hàng</span>
            </a>
        </li>
        <li class="menu-item-has-children">
            <a href="#" class="sidebar-link">
                <i class="fa-solid fa-box-archive"></i>
                <span>Quản lý Sản phẩm</span>
                <i class="fa-solid fa-chevron-down toggle-icon"></i>
            </a>
            <ul class="submenu">
                <li><a href="<%=request.getContextPath()%>/admin/products" class="active-sub">Tất cả sản phẩm</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/product-save"><i class="fa-solid fa-plus"></i> Thêm sản phẩm mới</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/categories" class="active-sub">Danh mục</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/brands" class="active-sub">Thương hiệu</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/ecosystems" class="active-sub">Hệ sinh thái</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/combo-list" class="active-sub">Combo/giải pháp</a></li>
            </ul>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/admin/users">
                <i class="fa-solid fa-users"></i>
                <span>Quản lý Khách hàng</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/restock">
                <i class="fa-solid fa-boxes-stacked"></i>
                <span>Đề xuất nhập hàng</span>
            </a>
        </li>
        <li><a href="<%=request.getContextPath()%>/admin/suppliers">Nhà cung cấp</a></li>
        <li class="menu-item-has-children">
            <a href="#" class="sidebar-link">
                <i class="fa-solid fa-file-pen"></i>
                <span>Quản lý Nội dung</span>
                <i class="fa-solid fa-chevron-down toggle-icon"></i>
            </a>
            <ul class="submenu">
                <li><a href="<%=request.getContextPath()%>/admin/banners" class="active-sub"><i class="fa-solid fa-images"></i> Quản lý Banner</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/content" class="active-sub"><i class="fa-solid fa-newspaper"></i> Danh sách Bài viết</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/add-article" class="active-sub"><i class="fa-solid fa-plus"></i> Viết bài mới</a></li>
            </ul>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/admin-voucher">
                <i class="fa-solid fa-ticket"></i>Quản lý Voucher
            </a>
        </li>
        <li>
            <a href="#">
                <i class="fa-solid fa-gear"></i>
                <span>Cài đặt</span>
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <a href="<%=request.getContextPath()%>/Home" class="btn-home">
            <i class="fa-solid fa-house"></i>
            <span>Trang chủ</span>
        </a>
        <a href="#" class="btn-logout" onclick="showLogoutDialog(); return false;">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span>Đăng xuất</span>
        </a>
    </div>
</nav>

<div id="logoutOverlay">
    <div id="logoutBox">
        <i class="fa-solid fa-right-from-bracket"></i>
        <h3>Xác nhận đăng xuất</h3>
        <p>Bạn sẽ được chuyển về trang chủ sau khi đăng xuất.</p>
        <div class="box-btns">
            <button class="btn-cancel" onclick="hideLogoutDialog()">Hủy</button>
            <button class="btn-confirm" onclick="doLogout()">Đăng xuất</button>
        </div>
        <p class="countdown" id="logoutCountdown" style="display:none;"></p>
    </div>
</div>

<script>
    function showLogoutDialog() {
        document.getElementById('logoutOverlay').classList.add('show');
    }
    function hideLogoutDialog() {
        document.getElementById('logoutOverlay').classList.remove('show');
        clearInterval(window._logoutTimer);
        document.getElementById('logoutCountdown').style.display = 'none';
    }
    function doLogout() {
        var countEl = document.getElementById('logoutCountdown');
        countEl.style.display = 'block';
        var sec = 1;
        countEl.textContent = 'Đang đăng xuất... (' + sec + 's)';
        document.querySelector('.btn-confirm').disabled = true;
        document.querySelector('.btn-cancel').disabled  = true;
        window._logoutTimer = setInterval(function() {
            sec--;
            if (sec <= 0) {
                clearInterval(window._logoutTimer);
                window.location.href = '<%=request.getContextPath()%>/logout';
            } else {
                countEl.textContent = 'Đang đăng xuất... (' + sec + 's)';
            }
        }, 1000);
    }

    document.getElementById('logoutOverlay').addEventListener('click', function(e) {
        if (e.target === this) hideLogoutDialog();
    });

    document.addEventListener("DOMContentLoaded", function () {
        var dropdowns = document.querySelectorAll(".menu-item-has-children > .sidebar-link");
        dropdowns.forEach(function (link) {
            link.addEventListener("click", function (e) {
                e.preventDefault();
                this.parentElement.classList.toggle("open");
            });
        });
        var currentUrl = window.location.href;
        document.querySelectorAll(".submenu a").forEach(function(link) {
            if (currentUrl.includes(link.getAttribute("href"))) {
                link.closest(".menu-item-has-children").classList.add("open");
                link.style.color = "var(--admin-white)";
                link.style.fontWeight = "bold";
            }
        });
    });
</script>
