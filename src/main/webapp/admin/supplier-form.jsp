<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>${supplier != null ? 'Cập nhật' : 'Thêm'} Nhà cung cấp | Admin</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
</head>
<body>
<div class="admin-layout">
  <jsp:include page="common/sidebar.jsp"/>
  <div class="admin-main">
    <header class="admin-header">
      <div class="header-left">
        <a href="${pageContext.request.contextPath}/admin/suppliers" class="btn-back">
          <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>
        <h2 style="margin-left:15px;">${supplier != null ? 'Cập nhật' : 'Thêm'} Nhà cung cấp</h2>
      </div>
      <div class="admin-header-actions">
        <a href="${pageContext.request.contextPath}/admin/suppliers" class="btn-secondary">Hủy</a>
        <button type="submit" form="supplierForm" class="btn-primary">
          <i class="fa-solid fa-save"></i> Lưu lại
        </button>
      </div>
    </header>

    <main class="admin-content">
      <form id="supplierForm"
            action="${pageContext.request.contextPath}/admin/suppliers"
            method="post" class="admin-form-layout">

        <c:choose>
          <c:when test="${supplier != null}">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="supplier_id" value="${supplier.supplier_id}">
          </c:when>
          <c:otherwise>
            <input type="hidden" name="action" value="insert">
          </c:otherwise>
        </c:choose>

        <div class="form-col-main">
          <div class="admin-card">
            <h3>Thông tin nhà cung cấp</h3>

            <div class="form-group">
              <label>Tên công ty <span style="color:red">*</span></label>
              <input type="text" name="company_name" class="form-control"
                     value="${supplier.company_name}" placeholder="VD: Công ty TNHH ABC" required>
            </div>

            <div class="form-group">
              <label>Người liên hệ</label>
              <input type="text" name="contact_name" class="form-control"
                     value="${supplier.contact_name}" placeholder="Họ và tên người liên hệ">
            </div>

            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px;">
              <div class="form-group">
                <label>Số điện thoại</label>
                <input type="text" name="phone" class="form-control"
                       value="${supplier.phone}" placeholder="0909 xxx xxx">
              </div>
              <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" class="form-control"
                       value="${supplier.email}" placeholder="contact@company.com">
              </div>
            </div>

            <div class="form-group">
              <label>Địa chỉ</label>
              <input type="text" name="address" class="form-control"
                     value="${supplier.address}" placeholder="Số nhà, đường, quận, tỉnh/thành phố">
            </div>

            <div class="form-group">
              <label>Website</label>
              <input type="text" name="website" class="form-control"
                     value="${supplier.website}" placeholder="https://company.com">
            </div>

            <div class="form-group">
              <label>Ghi chú</label>
              <textarea name="note" class="form-control" rows="3"
                        placeholder="Ghi chú thêm về nhà cung cấp...">${supplier.note}</textarea>
            </div>
          </div>
        </div>

        <div class="form-col-sidebar">
          <div class="admin-card">
            <h3>Hướng dẫn</h3>
            <p style="font-size:.88rem;color:var(--admin-text-light);line-height:1.7;">
              Sau khi thêm nhà cung cấp, bạn có thể liên kết sản phẩm với nhà cung cấp này
              trong trang <strong>thêm/sửa sản phẩm</strong>.
              <br><br>
              Thông tin nhà cung cấp sẽ được hiển thị trong trang chi tiết sản phẩm.
            </p>
          </div>
        </div>
      </form>
    </main>
  </div>
</div>
</body>
</html>
