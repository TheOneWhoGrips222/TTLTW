<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Hệ Sinh Thái | Admin</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">

</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <h2>Quản lý Hệ Sinh Thái</h2>
            </div>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/ecosystems?action=new" class="btn-primary">
                    <i class="fa-solid fa-plus"></i> Thêm hệ sinh thái
                </a>
            </div>
        </header>

        <div class="admin-content">

            <c:if test="${not empty param.message}">
                <div class="alert ${param.message == 'deleted' || param.message == 'error' || param.message == 'notfound' ? 'alert-danger' : 'alert-success'}">
                    <c:choose>
                        <c:when test="${param.message == 'deleted' || param.message == 'error'}">
                            <i class="fa-solid fa-circle-exclamation"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="fa-solid fa-check-circle"></i>
                        </c:otherwise>
                    </c:choose>

                    <span>
                        <c:choose>
                            <c:when test="${param.message == 'saved'}">Thêm mới hệ sinh thái thành công!</c:when>
                            <c:when test="${param.message == 'updated'}">Cập nhật thông tin thành công!</c:when>
                            <c:when test="${param.message == 'deleted'}">Đã xóa dữ liệu thành công!</c:when>
                            <c:when test="${param.message == 'notfound'}">Không tìm thấy dữ liệu yêu cầu!</c:when>
                            <c:otherwise>Thao tác thành công!</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </c:if>

            <div class="admin-filters">
                <input type="text" placeholder="Tìm kiếm hệ sinh thái..." style="max-width: 300px;">
                <button class="btn-filter"><i class="fa-solid fa-search"></i> Tìm</button>
            </div>

            <div class="admin-card">
                <h3>Danh sách bộ sưu tập</h3>

                <table class="admin-table">
                    <thead>
                    <tr>
                        <th width="10%">ID</th>
                        <th width="15%">Hình ảnh</th>
                        <th width="45%">Tên Hệ Sinh Thái</th>
                        <th width="15%" class="text-right">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="e" items="${ecosystems}">
                        <tr>
                            <td>#${e.id}</td>
                            <td>
                                <img src="${not empty e.image ? e.image : 'https://placehold.co/80x50?text=No+Img'}"
                                     class="product-thumbnail ecosystem-img"
                                     onerror="this.src='https://via.placeholder.com/80x50?text=Error'"
                                     alt="${e.name}">
                            </td>
                            <td>
                                <div style="font-weight: 600; font-size: 1rem;">${e.name}</div>
                            </td>
                            <td class="text-right">
                                <a href="${pageContext.request.contextPath}/admin/ecosystems?action=edit&id=${e.id}"
                                   class="btn-action edit" title="Chỉnh sửa">
                                    <i class="fa-solid fa-pen"></i>
                                </a>

                                <a href="${pageContext.request.contextPath}/admin/ecosystems?action=delete&id=${e.id}"
                                   class="btn-action delete" title="Xóa"
                                   onclick="return confirm('CẢNH BÁO: Bạn có chắc chắn muốn xóa hệ sinh thái này? Hành động này không thể hoàn tác.');">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty ecosystems}">
                        <tr>
                            <td colspan="4" style="text-align: center; padding: 40px; color: var(--admin-text-light);">
                                <i class="fa-solid fa-layer-group" style="font-size: 2.5rem; margin-bottom: 15px; display: block; opacity: 0.5;"></i>
                                <p>Chưa có hệ sinh thái nào được tạo.</p>
                                <a href="${pageContext.request.contextPath}/admin/ecosystems?action=new"
                                   style="color: var(--primary-color); font-weight: 600; text-decoration: none;">
                                    + Tạo mới ngay
                                </a>
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