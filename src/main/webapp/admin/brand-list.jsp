<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Thương hiệu | Admin</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">


</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <h2>Quản lý Thương hiệu</h2>
            </div>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/brands?action=new" class="btn-primary">
                    <i class="fa-solid fa-plus"></i> Thêm thương hiệu
                </a>
            </div>
        </header>

        <div class="admin-content">

            <c:if test="${not empty param.message}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-check-circle"></i>
                        ${param.message == 'deleted' ? 'Đã xóa thương hiệu thành công!' : 'Đã lưu thông tin thành công!'}
                </div>
            </c:if>

            <div class="admin-filters">
                <input type="text" placeholder="Tìm kiếm thương hiệu..." style="max-width: 300px;">
                <button class="btn-filter"><i class="fa-solid fa-search"></i> Tìm</button>
            </div>

            <div class="admin-card">
                <h3>Danh sách thương hiệu</h3>

                <table class="admin-table">
                    <thead>
                    <tr>
                        <th width="10%">ID</th>
                        <th width="15%">Logo</th>
                        <th width="40%">Tên Thương hiệu</th>
                        <th width="20%">Số lượng SP</th> <th width="15%" class="text-right">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="b" items="${brands}">
                        <tr>
                            <td>#${b.brand_id}</td>
                            <td>
                                <img src="${not empty b.logo_url ? b.logo_url : 'https://placehold.co/60x60?text=No+Logo'}"
                                     class="product-thumbnail brand-logo"
                                     onerror="this.src='https://via.placeholder.com/60?text=Err'"
                                     alt="${b.brand_name}">
                            </td>
                            <td>
                                <div style="font-weight: 600; font-size: 1rem;">${b.brand_name}</div>
                            </td>
                            <td>
                                <span style="color: var(--admin-text-light); font-size: 0.9rem;">--</span>
                            </td>
                            <td class="text-right">
                                <a href="${pageContext.request.contextPath}/admin/brands?action=edit&id=${b.brand_id}"
                                   class="btn-action edit" title="Sửa">
                                    <i class="fa-solid fa-pen"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/brands?action=delete&id=${b.brand_id}"
                                   class="btn-action delete"
                                   title="Xóa"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa thương hiệu: ${b.brand_name}?');">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty brands}">
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 40px; color: var(--admin-text-light);">
                                <i class="fa-solid fa-box-open" style="font-size: 2rem; margin-bottom: 10px; display: block;"></i>
                                Chưa có thương hiệu nào được tạo.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>

                <div class="admin-pagination">
                    <a href="#" class="page-link"><i class="fa-solid fa-chevron-left"></i></a>
                    <a href="#" class="page-link active">1</a>
                    <a href="#" class="page-link">2</a>
                    <a href="#" class="page-link"><i class="fa-solid fa-chevron-right"></i></a>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>