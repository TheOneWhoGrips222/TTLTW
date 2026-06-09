<%--
  Created by IntelliJ IDEA.
  User: THANH TRUONG
  Date: 6/9/2026
  Time: 10:10 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Nhân viên | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
    <style>
        .role-badge{display:inline-block;padding:3px 10px;border-radius:12px;font-size:.78rem;font-weight:700}
        .role-OWNER,.role-ADMIN{background:#e0e7ff;color:#4f46e5}
        .role-WAREHOUSE{background:#cffafe;color:#0e7490}
        .role-SALES{background:#d1fae5;color:#065f46}
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"/>
    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left"><h2><i class="fa-solid fa-user-tie" style="color:#4f46e5;margin-right:8px;"></i>Quản lý Nhân viên</h2></div>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/staff?action=new" class="btn-primary">
                    <i class="fa-solid fa-plus"></i> Thêm nhân viên
                </a>
            </div>
        </header>
        <div class="admin-content">

            <c:if test="${not empty param.message}">
                <div class="alert ${param.message == 'error' ? 'alert-danger' : 'alert-success'}">
                    <i class="fa-solid fa-${param.message == 'error' ? 'exclamation-circle' : 'check-circle'}"></i>
                    <c:choose>
                        <c:when test="${param.message == 'deleted'}">Đã xóa nhân viên!</c:when>
                        <c:when test="${param.message == 'error'}">Đã có lỗi xảy ra!</c:when>
                        <c:otherwise>Lưu thành công!</c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <div class="admin-card">
                <h3>Danh sách nhân viên <span style="font-size:.85rem;font-weight:400;color:#6b7280;">(${staffList.size()} người)</span></h3>
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th width="5%">ID</th>
                        <th width="18%">Tên đăng nhập</th>
                        <th width="20%">Họ và tên</th>
                        <th width="20%">Email</th>
                        <th width="13%">SĐT</th>
                        <th width="13%">Vai trò</th>
                        <th width="11%" class="text-right">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="s" items="${staffList}">
                        <tr>
                            <td>#${s.user_id}</td>
                            <td><strong>${s.username}</strong></td>
                            <td>${s.full_name}</td>
                            <td>${s.email}</td>
                            <td>${s.phone}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${s.role == 'OWNER' or s.role == 'ADMIN'}">
                                        <span class="role-badge role-OWNER">Chủ cửa hàng</span>
                                    </c:when>
                                    <c:when test="${s.role == 'WAREHOUSE'}">
                                        <span class="role-badge role-WAREHOUSE">Nhân viên kho</span>
                                    </c:when>
                                    <c:when test="${s.role == 'SALES'}">
                                        <span class="role-badge role-SALES">Nhân viên bán hàng</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td class="text-right">
                                <a href="${pageContext.request.contextPath}/admin/staff?action=edit&id=${s.user_id}" class="btn-action edit" title="Sửa">
                                    <i class="fa-solid fa-pen"></i>
                                </a>
                                <c:if test="${s.role != 'OWNER' and s.role != 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/admin/staff?action=delete&id=${s.user_id}"
                                       class="btn-action delete" title="Xóa"
                                       onclick="return confirm('Xóa tài khoản: ${s.username}?')">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty staffList}">
                        <tr><td colspan="7" style="text-align:center;padding:40px;color:#9ca3af;">Chưa có nhân viên nào.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <div class="admin-card" style="margin-top:20px;">
                <h3><i class="fa-solid fa-circle-info" style="color:#3b82f6;margin-right:6px;"></i>Phân quyền</h3>
                <table class="admin-table">
                    <thead><tr><th>Vai trò</th><th>Dashboard/Doanh thu</th><th>Đơn hàng</th><th>Sản phẩm/Kho</th><th>Khách hàng</th><th>Nội dung</th><th>Nhân viên</th></tr></thead>
                    <tbody>
                    <tr><td><span class="role-badge role-OWNER">Chủ cửa hàng</span></td><td>✅</td><td>✅</td><td>✅</td><td>✅</td><td>✅</td><td>✅</td></tr>
                    <tr><td><span class="role-badge role-WAREHOUSE">Nhân viên kho</span></td><td>❌</td><td>❌</td><td>✅</td><td>❌</td><td>❌</td><td>❌</td></tr>
                    <tr><td><span class="role-badge role-SALES">Nhân viên bán hàng</span></td><td>❌</td><td>✅</td><td>❌</td><td>❌</td><td>❌</td><td>❌</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>
</body>
</html>
