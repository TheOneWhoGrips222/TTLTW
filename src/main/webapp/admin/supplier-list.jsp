<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Nhà cung cấp | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
</head>
<body>
<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"/>
    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left"><h2>Quản lý Nhà cung cấp</h2></div>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/suppliers?action=new" class="btn-primary">
                    <i class="fa-solid fa-plus"></i> Thêm nhà cung cấp
                </a>
            </div>
        </header>
        <div class="admin-content">

            <c:if test="${not empty param.message}">
                <div class="alert ${param.message == 'error' ? 'alert-danger' : 'alert-success'}">
                    <i class="fa-solid fa-${param.message == 'error' ? 'exclamation-circle' : 'check-circle'}"></i>
                    <c:choose>
                        <c:when test="${param.message == 'deleted'}">Đã xóa nhà cung cấp!</c:when>
                        <c:when test="${param.message == 'error'}">Đã có lỗi xảy ra!</c:when>
                        <c:otherwise>Lưu thành công!</c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <div class="admin-card">
                <h3>Danh sách nhà cung cấp <span style="font-size:.85rem;font-weight:400;color:#6b7280;">(${suppliers.size()} nhà cung cấp)</span></h3>
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th width="5%">ID</th>
                        <th width="22%">Công ty</th>
                        <th width="15%">Người liên hệ</th>
                        <th width="13%">SĐT</th>
                        <th width="20%">Email</th>
                        <th width="15%">Website</th>
                        <th width="10%" class="text-right">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="s" items="${suppliers}">
                        <tr>
                            <td>#${s.supplier_id}</td>
                            <td><strong>${s.company_name}</strong></td>
                            <td>${s.contact_name}</td>
                            <td>${s.phone}</td>
                            <td>${s.email}</td>
                            <td>
                                <c:if test="${not empty s.website}">
                                    <a href="${s.website}" target="_blank" style="color:#4f46e5;">
                                        <i class="fa-solid fa-arrow-up-right-from-square"></i> Link
                                    </a>
                                </c:if>
                            </td>
                            <td class="text-right">
                                <a href="${pageContext.request.contextPath}/admin/suppliers?action=edit&id=${s.supplier_id}" class="btn-action edit" title="Sửa">
                                    <i class="fa-solid fa-pen"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/suppliers?action=delete&id=${s.supplier_id}"
                                   class="btn-action delete" title="Xóa"
                                   onclick="return confirm('Xóa nhà cung cấp: ${s.company_name}?')">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty suppliers}">
                        <tr>
                            <td colspan="7" style="text-align:center;padding:40px;color:#9ca3af;">
                                Chưa có nhà cung cấp nào.
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
