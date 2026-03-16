<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Người dùng | Admin</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">

    <style>
        /* CSS riêng cho User List để hiển thị đẹp hơn */
        .user-info { display: flex; align-items: center; gap: 10px; }
        .user-avatar {
            width: 40px; height: 40px; border-radius: 50%; background: #e2e8f0;
            display: flex; align-items: center; justify-content: center;
            color: #64748b; font-weight: bold; font-size: 1.2rem;
        }

        /* Badge cho vai trò */
        .role-badge {
            display: inline-block; padding: 4px 10px; border-radius: 20px;
            font-size: 0.8rem; font-weight: 600;
        }
        .role-admin { background-color: #fee2e2; color: #dc2626; border: 1px solid #fecaca; }
        .role-user { background-color: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .role-staff { background-color: #dbeafe; color: #1e40af; border: 1px solid #bfdbfe; }
    </style>
</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <h2>Quản lý Người dùng</h2>
            </div>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/users?action=new" class="btn-primary">
                    <i class="fa-solid fa-user-plus"></i> Thêm người dùng
                </a>
            </div>
        </header>

        <div class="admin-content">

            <c:if test="${not empty param.message}">
                <div class="alert alert-success" style="padding:15px; background:#dcfce7; color:#16a34a; margin-bottom:20px; border-radius:8px;">
                    <i class="fa-solid fa-check-circle"></i>
                        ${param.message == 'deleted' ? 'Đã xóa người dùng thành công!' : 'Lưu thông tin thành công!'}
                </div>
            </c:if>

            <div class="admin-filters">
                <div style="display: flex; gap: 10px; flex: 1;">
                    <input type="text" placeholder="Tìm theo tên, email hoặc SĐT..." style="max-width: 300px;">
                    <select style="width: 150px; padding: 0 10px; border: 1px solid #ddd; border-radius: 6px;">
                        <option value="">Tất cả vai trò</option>
                        <option value="ADMIN">Quản trị viên</option>
                        <option value="USER">Khách hàng</option>
                    </select>
                    <button class="btn-filter"><i class="fa-solid fa-search"></i> Tìm</button>
                </div>
            </div>

            <div class="admin-card">
                <h3>Danh sách tài khoản (${users.size()})</h3>

                <table class="admin-table">
                    <thead>
                    <tr>
                        <th width="5%">ID</th>
                        <th width="30%">Thông tin cá nhân</th>
                        <th width="25%">Liên hệ</th>
                        <th width="15%">Vai trò</th>
                        <th width="15%">Ngày tạo</th>
                        <th width="10%" class="text-right">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td>#${u.user_id}</td>
                            <td>
                                <div class="user-info">
                                    <div class="user-avatar">
                                        <i class="fa-solid fa-user"></i>
                                    </div>
                                    <div>
                                        <div style="font-weight: 600;">${u.full_name}</div>
                                        <div style="font-size: 0.85rem; color: #64748b;">@${u.username}</div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div><i class="fa-regular fa-envelope" style="width: 15px;"></i> ${u.email}</div>
                                <div style="margin-top: 3px; color: #64748b;">
                                    <i class="fa-solid fa-phone" style="width: 15px;"></i> ${u.phone}
                                </div>
                            </td>
                            <td>
                                <span class="role-badge ${u.role == 'ADMIN' ? 'role-admin' : 'role-user'}">
                                        ${u.role == 'ADMIN' ? 'Quản trị viên' : 'Khách hàng'}
                                </span>
                            </td>
                            <td style="color: #64748b; font-size: 0.9rem;">
                                    ${u.create_at}
                            </td>
                            <td class="text-right">
                                <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${u.user_id}"
                                   class="btn-action edit" title="Sửa">
                                    <i class="fa-solid fa-pen"></i>
                                </a>
                                <c:if test="${u.role != 'ADMIN'}"> <a href="${pageContext.request.contextPath}/admin/users?action=delete&id=${u.user_id}"
                                                                      class="btn-action delete"
                                                                      title="Xóa"
                                                                      onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng: ${u.username}?');">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>
</body>
</html>