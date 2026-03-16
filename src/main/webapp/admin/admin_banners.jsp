<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Banner | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
    <style>
        /* CSS riêng cho ảnh banner trong bảng (vì banner thường hình chữ nhật dài) */
        .banner-thumbnail {
            width: 120px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #e2e8f0;
        }
    </style>
</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <h2>Quản lý Banner</h2>
            </div>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/banners?action=add" class="btn-primary">
                    <i class="fa-solid fa-plus"></i> Thêm Banner
                </a>
            </div>
        </header>

        <div class="admin-content">

            <c:if test="${param.message == 'inserted'}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-check-circle"></i> Thêm mới banner thành công!
                </div>
            </c:if>
            <c:if test="${param.message == 'updated'}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-check-circle"></i> Cập nhật banner thành công!
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger">
                    <i class="fa-solid fa-exclamation-circle"></i> Đã có lỗi xảy ra!
                </div>
            </c:if>

            <div class="admin-card">
                <h3>Danh sách Banner hiển thị</h3>

                <table class="admin-table">
                    <thead>
                    <tr>
                        <th width="5%">ID</th>
                        <th width="15%">Hình ảnh</th>
                        <th width="25%">Tiêu đề & Mô tả</th>
                        <th width="20%">Đường dẫn (Link)</th>
                        <th width="10%" class="text-center">Thứ tự</th>
                        <th width="10%">Trạng thái</th>
                        <th width="15%" class="text-right">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="b" items="${listBanners}">
                        <tr>
                            <td><strong>#${b.id}</strong></td>

                            <td>
                                <c:choose>
                                    <%-- Trường hợp 1: Không có ảnh --%>
                                    <c:when test="${empty b.image}">
                                        <div class="banner-thumbnail" style="background: #eee; display: flex; align-items: center; justify-content: center; color: #999;">No Image</div>
                                    </c:when>

                                    <%-- Trường hợp 2: Là Link Online (Bắt đầu bằng http) --%>
                                    <c:when test="${b.image.startsWith('http')}">
                                        <img src="${b.image}" alt="Banner" class="banner-thumbnail">
                                    </c:when>

                                    <%-- Trường hợp 3: Là Ảnh Upload (File nội bộ) --%>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/${b.image}" alt="Banner" class="banner-thumbnail">
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <div style="font-weight: 600; margin-bottom: 5px;">${b.title}</div>
                                <div style="font-size: 0.85rem; color: var(--admin-text-light);">
                                        ${b.description}
                                </div>
                            </td>

                            <td>
                                <a href="${b.link_url}" target="_blank" style="color: var(--blue); text-decoration: none; font-size: 0.9rem;">
                                        ${b.link_url} <i class="fa-solid fa-external-link-alt" style="font-size: 0.7rem;"></i>
                                </a>
                            </td>

                            <td class="text-center">
                                <span style="font-weight: bold;">${b.sort_order}</span>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${b.isActive == 1}">
                                        <span class="status status-published">Hiển thị</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status status-draft">Đang ẩn</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td class="text-right">
                                <a href="${pageContext.request.contextPath}/admin/banners?action=edit&id=${b.id}"
                                   class="btn-action edit" title="Sửa">
                                    <i class="fa-solid fa-pen"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/banners?action=delete&id=${b.id}"
                                   class="btn-action delete"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa banner này không?');"
                                   title="Xóa">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty listBanners}">
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 30px; color: var(--admin-text-light);">
                                Chưa có banner nào.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>
</body>
</html>