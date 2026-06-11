<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
<style>
    .sidebar-footer{display:flex;flex-direction:column;gap:6px;padding:12px 16px}
    .sidebar-footer a{display:flex;align-items:center;gap:10px;padding:10px 14px;border-radius:8px;font-size:.9rem;text-decoration:none;transition:background .15s}
    .sidebar-footer .btn-home{background:rgba(255,255,255,.1);color:var(--admin-white,#fff)}
    .sidebar-footer .btn-home:hover{background:rgba(255,255,255,.2)}
    .sidebar-footer .btn-logout{background:rgba(239,68,68,.15);color:#fca5a5}
    .sidebar-footer .btn-logout:hover{background:rgba(239,68,68,.3);color:#fff}
    .role-badge{display:inline-block;padding:2px 8px;border-radius:10px;font-size:.7rem;font-weight:700;margin-left:6px;vertical-align:middle}
    .role-OWNER{background:#4f46e5;color:#fff}.role-WAREHOUSE{background:#0891b2;color:#fff}.role-SALES{background:#059669;color:#fff}.role-ADMIN{background:#4f46e5;color:#fff}
    #logoutOverlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.45);z-index:9999;align-items:center;justify-content:center}
    #logoutOverlay.show{display:flex}
    #logoutBox{background:#fff;border-radius:14px;padding:32px 36px;text-align:center;box-shadow:0 8px 32px rgba(0,0,0,.18);min-width:260px}
    #logoutBox i{font-size:2.2rem;color:#ef4444;margin-bottom:12px}
    #logoutBox h3{margin:0 0 6px;font-size:1.1rem;color:#1f2937}
    #logoutBox p{font-size:.88rem;color:#6b7280;margin-bottom:20px}
    .box-btns{display:flex;gap:10px;justify-content:center}
    .box-btns button{padding:9px 22px;border:none;border-radius:8px;font-size:.9rem;cursor:pointer;font-weight:600}
    .btn-cancel-l{background:#f3f4f6;color:#374151}.btn-confirm-l{background:#ef4444;color:#fff}
    .countdown-l{font-size:.82rem;color:#9ca3af;margin-top:10px;display:none}
</style>

<%
    com.webthietbibep.model.User currentUser =
            (com.webthietbibep.model.User) session.getAttribute("user");
    String userRole = (currentUser != null) ? currentUser.getRole() : "";
    boolean isOwner     = "OWNER".equals(userRole) || "ADMIN".equals(userRole);
    boolean isWarehouse = "WAREHOUSE".equals(userRole);
    boolean isSales     = "SALES".equals(userRole);
%>

<nav class="admin-sidebar">
    <div class="sidebar-header">
        <h3>Admin Panel
            <% if ("WAREHOUSE".equals(userRole)) { %>
            <span class="role-badge role-WAREHOUSE">Kho</span>
            <% } else if ("SALES".equals(userRole)) { %>
            <span class="role-badge role-SALES">Bán hàng</span>
            <% } else { %>
            <span class="role-badge role-OWNER">Chủ</span>
            <% } %>
        </h3>
        <div style="display:flex;justify-content:flex-end;margin-top:4px;">
            <%@ include file="/admin/common/notification_bell.jsp" %>
        </div>
    </div>
    <ul class="sidebar-menu">

        <% if (isOwner) { %>
        <li>
            <a href="<%=request.getContextPath()%>/admin/dashboard">
                <i class="fa-solid fa-chart-line"></i><span>Tổng quan</span>
            </a>
        </li>
        <% } %>

        <% if (isOwner || isSales) { %>
        <li>
            <a href="<%=request.getContextPath()%>/admin/order">
                <i class="fa-solid fa-file-invoice-dollar"></i><span>Quản lý Đơn hàng</span>
            </a>
        </li>
        <% } %>

        <% if (isOwner || isWarehouse) { %>
        <li class="menu-item-has-children">
            <a href="#" class="sidebar-link">
                <i class="fa-solid fa-box-archive"></i><span>Quản lý Sản phẩm</span>
                <i class="fa-solid fa-chevron-down toggle-icon"></i>
            </a>
            <ul class="submenu">
                <li><a href="<%=request.getContextPath()%>/admin/products">Tất cả sản phẩm</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/product-save"><i class="fa-solid fa-plus"></i> Thêm sản phẩm</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/categories">Danh mục</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/brands">Thương hiệu</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/ecosystems">Hệ sinh thái</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/combo-list">Combo/Giải pháp</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/suppliers">Nhà cung cấp</a></li>
            </ul>
        </li>
        <% } %>

        <% if (isOwner || isWarehouse) { %>
        <li>
            <a href="<%=request.getContextPath()%>/admin/restock">
                <i class="fa-solid fa-boxes-stacked"></i><span>Đề xuất nhập hàng</span>
            </a>
        </li>
        <% } %>

        <% if (isOwner) { %>
        <li>
            <a href="<%=request.getContextPath()%>/admin/users">
                <i class="fa-solid fa-users"></i><span>Quản lý Khách hàng</span>
            </a>
        </li>
        <% } %>
        <li>
            <a href="${pageContext.request.contextPath}/admin/admin-voucher">
                <i class="fa-solid fa-ticket"></i>Quản lý Voucher
            </a>
        </li>
        <% if (isOwner) { %>
        <li class="menu-item-has-children">
            <a href="#" class="sidebar-link">
                <i class="fa-solid fa-file-pen"></i><span>Quản lý Nội dung</span>
                <i class="fa-solid fa-chevron-down toggle-icon"></i>
            </a>
            <ul class="submenu">
                <li><a href="<%=request.getContextPath()%>/admin/banners"><i class="fa-solid fa-images"></i> Quản lý Banner</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/content"><i class="fa-solid fa-newspaper"></i> Bài viết</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/add-article"><i class="fa-solid fa-plus"></i> Viết bài mới</a></li>
            </ul>
        </li>
        <% } %>

        <% if (isOwner) { %>
        <li>
            <a href="<%=request.getContextPath()%>/admin/staff">
                <i class="fa-solid fa-user-tie"></i><span>Quản lý Nhân viên</span>
            </a>
        </li>
        <% } %>

    </ul>

    <div class="sidebar-footer">
        <a href="<%=request.getContextPath()%>/Home" class="btn-home">
            <i class="fa-solid fa-house"></i><span>Trang chủ</span>
        </a>
        <a href="#" class="btn-logout" onclick="showLogoutSidebar();return false;">
            <i class="fa-solid fa-right-from-bracket"></i><span>Đăng xuất</span>
        </a>
    </div>
</nav>

<div id="logoutOverlay">
    <div id="logoutBox">
        <i class="fa-solid fa-right-from-bracket"></i>
        <h3>Xác nhận đăng xuất</h3>
        <p>Bạn sẽ được chuyển về trang chủ sau khi đăng xuất.</p>
        <div class="box-btns">
            <button class="btn-cancel-l" onclick="hideLogoutSidebar()">Hủy</button>
            <button class="btn-confirm-l" onclick="doLogoutSidebar()">Đăng xuất</button>
        </div>
        <p class="countdown-l" id="sidebarCountdown"></p>
    </div>
</div>

<script>
    function showLogoutSidebar() { document.getElementById('logoutOverlay').classList.add('show'); }
    function hideLogoutSidebar() {
        document.getElementById('logoutOverlay').classList.remove('show');
        clearInterval(window._slt);
        document.getElementById('sidebarCountdown').style.display = 'none';
    }
    function doLogoutSidebar() {
        var c = document.getElementById('sidebarCountdown');
        c.style.display = 'block';
        document.querySelector('.btn-confirm-l').disabled = true;
        document.querySelector('.btn-cancel-l').disabled  = true;
        var s = 1;
        c.textContent = 'Đang đăng xuất... (' + s + 's)';
        window._slt = setInterval(function() {
            s--;
            if (s <= 0) { clearInterval(window._slt); window.location.href = '<%=request.getContextPath()%>/logout'; }
            else c.textContent = 'Đang đăng xuất... (' + s + 's)';
        }, 1000);
    }
    document.getElementById('logoutOverlay').addEventListener('click', function(e) {
        if (e.target === this) hideLogoutSidebar();
    });
    document.addEventListener("DOMContentLoaded", function() {
        document.querySelectorAll(".menu-item-has-children > .sidebar-link").forEach(function(link) {
            link.addEventListener("click", function(e) {
                e.preventDefault();
                this.parentElement.classList.toggle("open");
            });
        });
        var cur = window.location.href;
        document.querySelectorAll(".submenu a").forEach(function(a) {
            if (cur.includes(a.getAttribute("href"))) {
                a.closest(".menu-item-has-children").classList.add("open");
                a.style.fontWeight = "bold";
            }
        });
    });
</script>
