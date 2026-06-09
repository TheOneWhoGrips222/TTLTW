<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>${staff != null ? 'Cập nhật' : 'Thêm'} Nhân viên | Admin</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
</head>
<body>
<div class="admin-layout">
  <jsp:include page="common/sidebar.jsp"/>
  <div class="admin-main">
    <header class="admin-header">
      <div class="header-left">
        <a href="${pageContext.request.contextPath}/admin/staff" class="btn-back">
          <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>
        <h2 style="margin-left:15px;">${staff != null ? 'Cập nhật' : 'Thêm'} Nhân viên</h2>
      </div>
      <div class="admin-header-actions">
        <a href="${pageContext.request.contextPath}/admin/staff" class="btn-secondary">Hủy</a>
        <button type="submit" form="staffForm" class="btn-primary">
          <i class="fa-solid fa-save"></i> Lưu lại
        </button>
      </div>
    </header>

    <main class="admin-content">
      <form id="staffForm"
            action="${pageContext.request.contextPath}/admin/staff"
            method="post" class="admin-form-layout">

        <c:choose>
          <c:when test="${staff != null}">
            <input type="hidden" name="action"   value="update">
            <input type="hidden" name="staff_id" value="${staff.user_id}">
          </c:when>
          <c:otherwise>
            <input type="hidden" name="action" value="insert">
          </c:otherwise>
        </c:choose>

        <div class="form-col-main">
          <div class="admin-card">
            <h3>Thông tin tài khoản</h3>

            <div class="form-group">
              <label>Tên đăng nhập <span style="color:red">*</span></label>
              <input type="text" name="username" class="form-control"
                     value="${staff.username}"
                     placeholder="Tên đăng nhập..."
              ${staff != null ? 'readonly style="background:#f3f4f6;"' : 'required'}>
              <c:if test="${staff != null}">
                <small style="color:#9ca3af;">Tên đăng nhập không thể thay đổi sau khi tạo.</small>
              </c:if>
            </div>

            <div class="form-group">
              <label>Họ và tên <span style="color:red">*</span></label>
              <input type="text" name="full_name" class="form-control"
                     value="${staff.full_name}"
                     placeholder="Họ và tên đầy đủ..." required>
            </div>

            <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
              <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" class="form-control"
                       value="${staff.email}" placeholder="email@company.com">
              </div>
              <div class="form-group">
                <label>Số điện thoại</label>
                <input type="text" name="phone" class="form-control"
                       value="${staff.phone}" placeholder="0909 xxx xxx">
              </div>
            </div>

            <div class="form-group">
              <label>${staff != null ? 'Mật khẩu mới (để trống nếu không đổi)' : 'Mật khẩu'} <c:if test="${staff == null}"><span style="color:red">*</span></c:if></label>
              <input type="password" name="password" class="form-control"
                     placeholder="${staff != null ? 'Nhập mật khẩu mới...' : 'Nhập mật khẩu...'}"
              ${staff == null ? 'required' : ''} minlength="6">
              <small style="color:#9ca3af;">Tối thiểu 6 ký tự.</small>
            </div>
          </div>
        </div>

        <div class="form-col-sidebar">
          <div class="admin-card">
            <h3>Vai trò <span style="color:red">*</span></h3>

            <div class="form-group">
              <label style="display:flex;align-items:flex-start;gap:10px;cursor:pointer;padding:12px;border:1px solid #e5e7eb;border-radius:10px;margin-bottom:8px;
                                   ${staff.role == 'WAREHOUSE' ? 'border-color:#0891b2;background:#f0fdff;' : ''}">
                <input type="radio" name="role" value="WAREHOUSE"
                ${staff.role == 'WAREHOUSE' ? 'checked' : ''}
                ${staff == null ? '' : ''} style="margin-top:3px;">
                <div>
                  <div style="font-weight:600;color:#0e7490;">🏭 Nhân viên kho</div>
                  <div style="font-size:.82rem;color:#6b7280;margin-top:3px;">Xem và sửa sản phẩm, xem đề xuất nhập hàng. Không xem doanh thu hay đơn hàng.</div>
                </div>
              </label>

              <label style="display:flex;align-items:flex-start;gap:10px;cursor:pointer;padding:12px;border:1px solid #e5e7eb;border-radius:10px;margin-bottom:8px;
                                   ${staff.role == 'SALES' ? 'border-color:#059669;background:#f0fdf4;' : ''}">
                <input type="radio" name="role" value="SALES"
                ${staff.role == 'SALES' ? 'checked' : ''}
                       style="margin-top:3px;">
                <div>
                  <div style="font-weight:600;color:#065f46;">🛒 Nhân viên bán hàng</div>
                  <div style="font-size:.82rem;color:#6b7280;margin-top:3px;">Chỉ xem và xử lý đơn hàng. Không chỉnh sửa sản phẩm hay xem tài khoản khách.</div>
                </div>
              </label>

              <label style="display:flex;align-items:flex-start;gap:10px;cursor:pointer;padding:12px;border:1px solid #e5e7eb;border-radius:10px;
                                   ${staff.role == 'OWNER' or staff.role == 'ADMIN' ? 'border-color:#4f46e5;background:#f5f3ff;' : ''}">
                <input type="radio" name="role" value="OWNER"
                ${staff.role == 'OWNER' or staff.role == 'ADMIN' ? 'checked' : ''}
                       style="margin-top:3px;">
                <div>
                  <div style="font-weight:600;color:#4338ca;">👑 Chủ cửa hàng</div>
                  <div style="font-size:.82rem;color:#6b7280;margin-top:3px;">Toàn quyền: dashboard, sản phẩm, đơn hàng, khách hàng, nội dung và nhân viên.</div>
                </div>
              </label>
            </div>
          </div>

          <div class="admin-card">
            <h3>Lưu ý</h3>
            <p style="font-size:.88rem;color:var(--admin-text-light);line-height:1.7;">
              Tài khoản nhân viên sẽ được kích hoạt ngay sau khi tạo.
              Nhân viên dùng trang <strong>đăng nhập</strong> thông thường và sẽ được chuyển thẳng vào trang admin phù hợp với quyền của mình.
            </p>
          </div>
        </div>
      </form>
    </main>
  </div>
</div>
</body>
</html>
