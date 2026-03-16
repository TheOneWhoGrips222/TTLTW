<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${user.user_id > 0 ? 'Cập nhật User' : 'Thêm User mới'} | Admin</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
            </div>
            <div class="admin-profile">
                <h3>${user.user_id > 0 ? 'Cập nhật tài khoản' : 'Tạo tài khoản mới'}</h3>
            </div>
        </header>

        <div class="admin-content">

            <form action="${pageContext.request.contextPath}/admin/users" method="post" class="admin-form-layout">
                <input type="hidden" name="action" value="${user.user_id > 0 ? 'update' : 'insert'}">
                <c:if test="${user.user_id > 0}">
                    <input type="hidden" name="id" value="${user.user_id}">
                </c:if>

                <div class="col-main">
                    <div class="admin-card">
                        <h3><i class="fa-regular fa-address-card"></i> Thông tin cá nhân</h3>

                        <div class="form-group">
                            <label>Họ và tên <span style="color:red">*</span></label>
                            <input type="text" name="full_name" class="form-control"
                                   value="${user.full_name}" required placeholder="Ví dụ: Nguyễn Văn A">
                        </div>

                        <div class="form-group">
                            <label>Email <span style="color:red">*</span></label>
                            <input type="email" name="email" class="form-control"
                                   value="${user.email}" required placeholder="email@example.com">
                        </div>

                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <input type="text" name="phone" class="form-control"
                                   value="${user.phone}" placeholder="09xxxxxxx">
                        </div>
                    </div>
                </div>

                <div class="col-sidebar">

                    <div class="admin-card">
                        <h3>Hành động</h3>
                        <button type="submit" class="btn-primary" style="width: 100%; justify-content: center;">
                            <i class="fa-solid fa-floppy-disk"></i> Lưu người dùng
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn-secondary"
                           style="width: 100%; justify-content: center; margin-top: 10px; display: block; text-align: center; text-decoration: none;">
                            Hủy bỏ
                        </a>
                    </div>

                    <div class="admin-card">
                        <h3><i class="fa-solid fa-shield-halved"></i> Đăng nhập & Vai trò</h3>

                        <div class="form-group">
                            <label>Tên đăng nhập (Username) <span style="color:red">*</span></label>
                            <input type="text" name="username" class="form-control"
                                   value="${user.username}"
                            ${user.user_id > 0 ? 'readonly style="background:#f1f5f9; cursor:not-allowed;"' : 'required'}
                                   placeholder="Viết liền không dấu">
                            <c:if test="${user.user_id > 0}">
                                <small style="color: #64748b;">Không thể thay đổi username.</small>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label>Mật khẩu ${user.user_id > 0 ? '(Bỏ trống nếu không đổi)' : '<span style="color:red">*</span>'}</label>
                            <input type="password" name="password" class="form-control"
                                   placeholder="${user.user_id > 0 ? 'Nhập mật khẩu mới...' : 'Nhập mật khẩu...'}"
                            ${user.user_id > 0 ? '' : 'required'}>
                        </div>

                        <div class="divider"></div>

                        <div class="form-group">
                            <label>Vai trò hệ thống</label>
                            <select name="role" class="form-control">
                                <option value="USER" ${user.role == 'USER' ? 'selected' : ''}>Khách hàng (User)</option>
                                <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Quản trị viên (Admin)</option>
                                <option value="STAFF" ${user.role == 'STAFF' ? 'selected' : ''}>Nhân viên (Staff)</option>
                            </select>
                        </div>
                    </div>

                </div>
            </form>
        </div>
    </main>
</div>

</body>
</html>