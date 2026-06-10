<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${oldVoucher.id > 0 ? 'Cập nhật voucher' : 'Thêm voucher mới'} | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/admin/admin-voucher" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
                <h2>${oldVoucher.id > 0 ? 'Cập nhật voucher' : 'Thêm voucher mới'}</h2>
            </div>
        </header>

        <div class="admin-content">
            <c:if test="${not empty errorMessage}">
                <div style="color: red; margin-bottom: 10px;">${errorMessage}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/add-voucher" method="post">

                <c:if test="${oldVoucher.id > 0}">
                    <input type="hidden" name="id" value="${oldVoucher.id}">
                </c:if>

                <div class="admin-form-layout">
                    <div class="form-col-main">
                        <div class="admin-card">
                            <h3>Thông tin Voucher</h3>

                            <div class="form-group">
                                <label>Tiêu đề voucher</label>
                                <input type="text" name="title" class="form-control" required
                                       value="${oldVoucher.title}" placeholder="Nhập tiêu đề...">
                            </div>

                            <div class="form-grid-mini" style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                                <div class="form-group">
                                    <label>Mã voucher (Viết hoa)</label>
                                    <input type="text" name="code" class="form-control" required
                                           value="${oldVoucher.code}" placeholder="Ví dụ: VOUCHER10K" style="text-transform: uppercase;">
                                </div>
                                <div class="form-group">
                                    <label>Danh mục áp dụng</label>
                                    <select name="category_id" class="form-control" required style="padding: 8px; border-radius: 4px; border: 1px solid #ccc; width: 100%;">
                                        <option value="0" ${oldVoucher.category_id == 0 ? 'selected' : ''}>0 - Tất cả sản phẩm</option>
                                        <c:forEach var="c" items="${categories}">
                                            <option value="${c.category_id}"
                                                ${c.category_id == oldVoucher.category_id ? 'selected' : ''}>
                                                    ${c.category_id} - ${c.category_name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Mô tả / Điều kiện áp dụng</label>
                                <textarea name="description" class="form-control" rows="4"
                                          placeholder="Tóm tắt...">${oldVoucher.description}</textarea>
                            </div>
                        </div>
                    </div>

                    <div class="form-col-sidebar">
                        <div class="admin-card">
                            <h3>Giá trị & Điều kiện</h3>

                            <div class="form-group">
                                <label>Loại ưu đãi</label>
                                <select name="discountType" class="form-control" required style="padding: 8px; border-radius: 4px; border: 1px solid #ccc; width: 100%;">
                                    <option value="cash" ${oldVoucher.discountType == 'cash' ? 'selected' : ''}>Giảm cố định (đ)</option>
                                    <option value="percent" ${oldVoucher.discountType == 'percent' ? 'selected' : ''}>Phần trăm (%)</option>
                                    <option value="freeship" ${oldVoucher.discountType == 'freeship' ? 'selected' : ''}>Free Ship</option>
                                    <option value="ship" ${oldVoucher.discountType == 'ship' ? 'selected' : ''}>Giảm phí Ship</option>
                                </select>
                            </div>

                            <div class="form-grid-mini" style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                                <div class="form-group">
                                    <label>Giá trị giảm</label>
                                    <fmt:formatNumber var="plainDiscountValue" value="${oldVoucher.discountValue}" pattern="#"/>
                                    <input type="number" name="discountValue" class="form-control" required min="1"
                                           value="${oldVoucher.id > 0 ? plainDiscountValue : ''}" placeholder="Số giảm">
                                </div>
                                <div class="form-group">
                                    <label>Đơn tối thiểu</label>
                                    <fmt:formatNumber var="plainMinOrderValue" value="${oldVoucher.minOrderValue}" pattern="#"/>
                                    <input type="number" name="minOrderValue" class="form-control" required min="0"
                                           value="${oldVoucher.id > 0 ? plainMinOrderValue : '0'}" placeholder="Tối thiểu">
                                </div>
                            </div>
                        </div>

                        <div class="admin-card">
                            <h3>Cài đặt</h3>
                            <div class="form-group">
                                <label>Số lượng</label>
                                <input type="number" name="quantity" class="form-control" required min="1"
                                       value="${oldVoucher.id > 0 ? oldVoucher.quantity : ''}" placeholder="Số lượng">
                            </div>

                            <div class="form-group">
                                <label>Ngày hết hạn</label>
                                <input type="date" name="endDate" class="form-control" required
                                       value="${oldVoucher.id > 0 && oldVoucher.endDate != null ? oldVoucher.endDate.toLocalDate() : ''}">
                            </div>

                            <div class="form-group">
                                <label>Trạng thái</label>
                                <div class="toggle-group">
                                    <label class="switch">
                                        <input type="checkbox" id="activeSwitch"
                                        ${oldVoucher.id == 0 || oldVoucher.status == 1 ? 'checked' : ''} onchange="updateActiveValue()">
                                        <span class="slider round"></span>
                                    </label>
                                    <span id="statusLabel">
                                        ${oldVoucher.id == 0 || oldVoucher.status == 1 ? 'Đang kích hoạt' : 'Đang ẩn'}
                                    </span>
                                </div>
                                <input type="hidden" name="status" id="isActiveInput" value="${oldVoucher.id == 0 ? '1' : oldVoucher.status}">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-primary">
                        <i class="fa-solid fa-save"></i>
                        ${oldVoucher.id > 0 ? 'Lưu voucher' : 'Đăng voucher'}
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/admin-voucher" class="btn-secondary">Hủy bỏ</a>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    function updateActiveValue() {
        const checkbox = document.getElementById('activeSwitch');
        const hiddenInput = document.getElementById('isActiveInput');
        const label = document.getElementById('statusLabel');
        if (checkbox.checked) {
            hiddenInput.value = "1";
            label.innerText = "Đang kích hoạt";
            label.style.color = "var(--green)";
        } else {
            hiddenInput.value = "0";
            label.innerText = "Đang ẩn";
            label.style.color = "var(--admin-text-light)";
        }
    }
</script>
</body>
</html>