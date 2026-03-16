<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Quản lý Nội dung</title>



    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&family=Manrope:wght@600;700;800&display=swap" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
</head>
<body>

<div class="admin-layout">

    <!-- SIDEBAR (MENU BÊN TRÁI) - ĐÃ CẬP NHẬT -->
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <!-- NỘI DUNG CHÍNH (BÊN PHẢI) -->
    <div class="admin-main">

        <!-- HEADER CỦA NỘI DUNG CHÍNH -->
        <header class="admin-header">
            <h2>Quản lý nội dung (Góc tư vấn/Bài viết)</h2>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/add-article" class="btn-primary">
                    <i class="fa-solid fa-plus"></i> Thêm Bài viết
                </a>

            </div>
        </header>

        <!-- VÙNG NỘI DUNG CHÍNH -->
        <main class="admin-content">
            <div class="admin-content">
                <c:if test="${not empty param.message}">
                <div class="alert alert-success" style="padding: 15px; background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 4px; margin-bottom: 20px;">
                    <i class="fa-solid fa-check-circle"></i>
                        ${param.message == 'deleted' ? 'Đã xóa bài viết thành công!' : 'Đã lưu thông tin bài viết thành công!'}
                </div>
                </c:if>
            <!-- KHUNG BỘ LỌC -->
            <div class=" admin-filters">
                <form action="${pageContext.request.contextPath}/admin/content" method="get" >
                <input  name="search" type="text" placeholder="Tìm theo Tên bài viết..." value="${param.search}">

                <select  name ="filter">
                    <option value="new" ${param.filter == 'new' ? 'selected' : ''}>Lọc theo ngày mới nhất</option>
                    <option value="old" ${param.filter == 'old' ? 'selected' : ''}>Lọc theo ngày cũ nhất</option>
                    <option value="AZ" ${param.filter == 'AZ' ? 'selected' : ''}>Lọc từ A-Z</option>
                    <option value ="type" ${param.filter == 'type' ? 'selected' : ''}>Lọc theo thể loại</option>
                    <option value="published" ${param.filter == 'published' ? 'selected' : ''}>Lọc đã xuất bản</option>
                    <option value="raw" ${param.filter == 'raw' ? 'selected' : ''}>Lọc bản nháp</option>

                </select>

                <button type="submit" class="btn-filter">Lọc</button>
                </form>
            </div>

            <!-- KHUNG DANH SÁCH BÀI VIẾT -->
            <div class="admin-card">
                <h3>Danh sách Bài viết / Nội dung</h3>
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th width="40%">Tiêu đề</th>
                        <th width="10%">Tác giả</th>
                        <th width="15%">Thể loại</th>
                        <th width="12%">Trạng thái</th>
                        <th width="12%">Ngày đăng</th>
                        <th width="11%" >Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var = "a" items="${filterA}">
                    <tr>
                        <td>${a.title}</td>
                        <td>${a.author}</td>
                        <td>${a.tip}</td>
                        <td><span class="status ${a.is_active != 0 ? 'status-published' : 'status-draft'}">${a.is_active != 0 ? 'Đã xuất bản' : 'Bản nháp'}</span></td>
                        <td>${a.create_date}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/action-article?action=edit&id=${a.id}" class="btn-action edit"  ><i class="fa-solid fa-pencil"></i></a>
                            <a href="${pageContext.request.contextPath}/admin/action-article?action=delete&id=${a.id}"
                               class="btn-action delete"
                               onclick="return confirm('Chắc chắn muốn xóa ?')">
                                <i class="fa-solid fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                    </c:forEach>

                    </tbody>
                </table>
                <div class="admin-pagination">
                    <%-- Nút trang trước --%>
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}&filter=${param.filter}&search=${param.search}" class="page-link">
                            <i class="fa-solid fa-chevron-left"></i>
                        </a>
                    </c:if>

                    <%-- Vòng lặp hiển thị số trang --%>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="?page=${i}&filter=${param.filter}&search=${param.search}"
                           class="page-link ${i == currentPage ? 'active' : ''}">
                                ${i}
                        </a>
                    </c:forEach>

                    <%-- Nút trang sau --%>
                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}&filter=${param.filter}&search=${param.search}" class="page-link">
                            <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </c:if>
                </div>
            </div>

        </main>
    </div>
</div>

<script src="admin_script.js"></script>
</body>
</html>