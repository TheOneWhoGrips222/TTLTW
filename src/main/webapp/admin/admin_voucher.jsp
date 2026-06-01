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


    <jsp:include page="common/sidebar.jsp"></jsp:include>


    <div class="admin-main">


        <header class="admin-header">
            <h2>Quản lý Voucher</h2>
            <div class="admin-header-actions">
                <a href="#" class="btn-primary">
                    <i class="fa-solid fa-plus"></i> Thêm Voucher
                </a>

            </div>
        </header>


        <main class="admin-content">
            <div class="admin-content">
                <c:if test="${not empty param.message}">
                <div class="alert alert-success" style="padding: 15px; background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 4px; margin-bottom: 20px;">
                    <i class="fa-solid fa-check-circle"></i>
                        ${param.message == 'deleted' ? 'Đã xóa voucher thành công!' : 'Đã lưu thông tin voucher thành công!'}
                </div>
                </c:if>

                <div class=" admin-filters">
                    <form action="${pageContext.request.contextPath}/admin/admin-voucher" method="get" >
                        <input  name="search" type="text" placeholder="Tìm theo mã voucher..." value="${param.search}">

                        <select  name ="filter">
                            <option value="all" ${param.filter == 'all' ? 'selected' : ''}>Tất cả voucher</option>
                            <option value="act" ${param.filter == 'act' ? 'selected' : ''}>Đang hoạt động</option>
                            <option value="stop" ${param.filter == 'stop'? 'selected' : ''}>Đang tạm dừng</option>
                            <option value="exprire" ${param.filter == 'exprire' ? 'selected' : ''}>Đã hết hạn</option>


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
                            <th width="3%">#ID</th>
                            <th width="12%">Mã voucher</th>
                            <th width="30%">Nội dung</th>
                            <th width="12%">Loại ưu đãi</th>
                            <th width="6%">Số lượng</th>
                            <th width="10%">Ngày hết hạn</th>
                            <th width="14%">Trạng thái</th>
                            <th width="13%">Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var = "v" items="${listV}">
                            <tr>
                                <td>#${v.id}</td>
                                <td>${v.code}</td>
                                <td>${v.title}</td>
                                <td>${v.discountType}</td>
                                <td>${v.quantity}</td>
                                <td>${v.endDate}</td>
                                <td ><span class="status ${v.status == 1 ? 'status-published' : 'status-draft'}">${v.status == 1? "Hoạt động" : "Tạm dừng"}</span></td>
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