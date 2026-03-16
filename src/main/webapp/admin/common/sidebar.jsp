<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">

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
                <li>
                    <a href="<%=request.getContextPath()%>/admin/products" class="active-sub">Tất cả sản phẩm</a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/admin/product-save">
                        <i class="fa-solid fa-plus"></i> Thêm sản phẩm mới
                    </a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/admin/categories" class="active-sub">Danh mục</a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/admin/brands" class="active-sub">Thương hiệu</a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/admin/ecosystems" class="active-sub">Hệ sinh thái</a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/admin/combo-list" class="active-sub">Combo/giải pháp</a>
                </li>
            </ul>
        </li>

        <li>
            <a href="<%=request.getContextPath()%>/admin/users">
                <i class="fa-solid fa-users"></i>
                <span>Quản lý Khách hàng</span>
            </a>
        </li>

        <li class="menu-item-has-children">
            <a href="#" class="sidebar-link">
                <i class="fa-solid fa-file-pen"></i>
                <span>Quản lý Nội dung</span>
                <i class="fa-solid fa-chevron-down toggle-icon"></i>
            </a>
            <ul class="submenu">
                <li>
                    <a href="<%=request.getContextPath()%>/admin/banners" class="active-sub">
                        <i class="fa-solid fa-images"></i> Quản lý Banner
                    </a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/admin/content" class="active-sub">
                        <i class="fa-solid fa-newspaper"></i> Danh sách Bài viết
                    </a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/admin/add-article" class="active-sub">
                        <i class="fa-solid fa-plus"></i> Viết bài mới
                    </a>
                </li>
            </ul>
        </li>

        <li>
            <a href="#">
                <i class="fa-solid fa-gear"></i>
                <span>Cài đặt</span>
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <a href="#">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span>Đăng xuất</span>
        </a>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {

            var dropdowns = document.querySelectorAll(".menu-item-has-children > .sidebar-link");

            dropdowns.forEach(function (link) {
                link.addEventListener("click", function (e) {
                    e.preventDefault();
                    var parent = this.parentElement;


                    parent.classList.toggle("open");
                });
            });


            var currentUrl = window.location.href;
            var subLinks = document.querySelectorAll(".submenu a");

            subLinks.forEach(function(link) {
                if(currentUrl.includes(link.getAttribute("href"))) {

                    link.closest(".menu-item-has-children").classList.add("open");
                    link.style.color = "var(--admin-white)"; // Highlight link con
                    link.style.fontWeight = "bold";
                }
            });
        });
    </script>
</nav>