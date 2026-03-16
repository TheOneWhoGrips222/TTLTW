<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Danh mục | Admin</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">

</head>
<body>

<div class="admin-layout">

    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <h2>Quản lý Danh mục</h2>
            </div>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/categories?action=new" class="btn-primary">
                    <i class="fa-solid fa-plus"></i> Thêm danh mục
                </a>
            </div>
        </header>

        <div class="admin-content">

            <c:if test="${not empty param.message}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-check-circle"></i>
                        ${param.message == 'deleted' ? 'Đã xóa danh mục thành công!' : 'Đã lưu thông tin thành công!'}
                </div>
            </c:if>

            <div class="admin-filters">
                <input type="text" placeholder="Tìm kiếm danh mục..." style="max-width: 300px;">
                <button class="btn-filter"><i class="fa-solid fa-search"></i> Tìm</button>
            </div>

            <div class="admin-card">
                <h3>Danh sách danh mục hiện có</h3>

                <table class="admin-table">
                    <thead>
                    <tr>
                        <th width="10%">ID</th>
                        <th width="15%">Logo</th>
                        <th width="40%">Tên Danh Mục</th>
                        <th width="20%">Số lượng SP</th> <th width="15%" class="text-right">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="c" items="${categories}">
                        <tr>
                            <td>#${c.category_id}</td>
                            <td>
                                <img src="${not empty c.logo ? c.logo : 'https://placehold.co/60x60?text=No+Img'}"
                                     class="product-thumbnail"
                                     onerror="this.src='https://via.placeholder.com/60?text=Error'"
                                     alt="${c.category_name}">
                            </td>
                            <td>
                                <div style="font-weight: 600; font-size: 1rem;">${c.category_name}</div>
                            </td>
                            <td>
                                <span style="color: var(--admin-text-light); font-size: 0.9rem;">--</span>
                            </td>
                            <td class="text-right">
                                <a href="${pageContext.request.contextPath}/admin/categories?action=edit&id=${c.category_id}"
                                   class="btn-action edit" title="Chỉnh sửa">
                                    <i class="fa-solid fa-pen"></i>
                                </a>

                                <a href="${pageContext.request.contextPath}/admin/categories?action=delete&id=${c.category_id}"
                                   class="btn-action delete"
                                   title="Xóa"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục: ${c.category_name}?');">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
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