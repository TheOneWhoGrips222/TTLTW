<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm voucher mới | Admin</title>
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
                <h2>Thêm voucher mới</h2>
            </div>
        </header>

        <div class="admin-content">
            <form action="${pageContext.request.contextPath}/admin/add-voucher" method="post">

                <div class="admin-form-layout">
                    <div class="form-col-main">
                        <div class="admin-card">
                            <h3>Thông tin Voucher</h3>

                            <div class="form-group">
                                <label>Tiêu đề voucher</label>
                                <input type="text" name="title" class="form-control" required
                                       value="" placeholder="Nhập tiêu đề...">
                            </div>

                            <div class="form-grid-mini" style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                                <div class="form-group">
                                    <label>Mã voucher (Viết hoa)</label>
                                    <input type="text" name="code" class="form-control" required
                                           value="" placeholder="Ví dụ: VOUCHER10K" style="text-transform: uppercase;">
                                </div>
                                <div class="form-group">
                                    <label>Danh mục áp dụng</label>
                                    <select name="category_id" class="form-control" required style="padding: 8px; border-radius: 4px; border: 1px solid #ccc; width: 100%;">
                                        <option value="0" selected>0 - Tất cả sản phẩm</option>
                                        <option value="1">1 - Thiết bị nhà bếp</option>
                                        <option value="2">2 - Đồ dùng phòng ăn</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Mô tả / Điều kiện áp dụng</label>
                                <textarea name="description" class="form-control" rows="4"
                                          placeholder="Tóm tắt..."></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="form-col-sidebar">
                        <div class="admin-card">
                            <h3>Giá trị & Điều kiện</h3>

                            <div class="form-group">
                                <label>Loại ưu đãi</label>
                                <select name="discountType" class="form-control" required style="padding: 8px; border-radius: 4px; border: 1px solid #ccc; width: 100%;">
                                    <option value="cố định" selected>Giảm thẳng (đ)</option>
                                    <option value="phần trăm">Phần trăm (%)</option>
                                </select>
                            </div>

                            <div class="form-grid-mini" style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                                <div class="form-group">
                                    <label>Giá trị giảm</label>
                                    <input type="number" name="discountValue" class="form-control" required min="1"
                                           value="" placeholder="Số giảm">
                                </div>
                                <div class="form-group">
                                    <label>Đơn tối thiểu</label>
                                    <input type="number" name="minOrderValue" class="form-control" required min="0"
                                           value="0" placeholder="Tối thiểu">
                                </div>
                            </div>
                        </div>

                        <div class="admin-card">
                            <h3>Cài đặt</h3>
                            <div class="form-group">
                                <label>Số lượng</label>
                                <input type="number" name="quantity" class="form-control" required min="1"
                                       value="" placeholder="Số lượng">
                            </div>

                            <div class="form-group">
                                <label>Ngày hết hạn</label>
                                <input type="date" name="endDate" class="form-control" required value="">
                            </div>

                            <div class="form-group">
                                <label>Trạng thái</label>
                                <div class="toggle-group">
                                    <label class="switch">
                                        <input type="checkbox" id="activeSwitch" checked onchange="updateActiveValue()">
                                        <span class="slider round"></span>
                                    </label>
                                    <span id="statusLabel" style="color: var(--green);">Đang kích hoạt</span>
                                </div>
                                <input type="hidden" name="status" id="isActiveInput" value="1">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-primary">
                        <i class="fa-solid fa-save"></i> Đăng voucher
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