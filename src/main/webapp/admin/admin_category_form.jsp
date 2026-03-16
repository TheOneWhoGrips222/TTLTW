<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${category.category_id > 0 ? 'Cập nhật danh mục' : 'Thêm danh mục mới'} | Admin</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">

    <style>
        .image-preview-container img {
            max-width: 100%;
            height: auto;
            border-radius: 4px;
            display: block;
        }
    </style>
</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/admin/categories" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
            <div class="admin-profile">
                <h3>${category.category_id > 0 ? 'Cập nhật danh mục' : 'Tạo danh mục mới'}</h3>
            </div>
        </header>

        <div class="admin-content">

            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="padding: 15px; background: #fee2e2; color: #dc2626; border-radius: 6px; margin-bottom: 20px; border: 1px solid #fecaca;">
                    <i class="fa-solid fa-triangle-exclamation"></i> ${error}
                </div>
            </c:if>

            <form id="categoryForm" action="${pageContext.request.contextPath}/admin/categories" method="post" class="admin-form-layout">

                <input type="hidden" name="action" value="${category.category_id > 0 ? 'update' : 'insert'}">
                <c:if test="${category.category_id > 0}">
                    <input type="hidden" name="category_id" value="${category.category_id}">
                </c:if>

                <div class="col-main">
                    <div class="admin-card">
                        <h3>Thông tin chung</h3>

                        <div class="form-group">
                            <label>Tên danh mục <span style="color: red;">*</span></label>
                            <input type="text" name="category_name"
                                   class="form-control"
                                   value="${category.category_name}"
                                   placeholder="Ví dụ: Bếp từ, Máy hút mùi, Lò nướng..." required>
                        </div>

                        <div class="form-group">
                            <label>Mô tả (Tùy chọn)</label>
                            <textarea class="form-control" rows="5" placeholder="Nhập mô tả ngắn về danh mục này... (sẽ hiển thị ở SEO hoặc đầu trang danh mục)"></textarea>
                        </div>
                    </div>

                </div>

                <div class="col-sidebar">

                    <div class="admin-card">
                        <h3>Hành động</h3>
                        <button type="submit" id="btnSave" class="btn-primary" style="width: 100%; justify-content: center;">
                            <i class="fa-solid fa-floppy-disk"></i>
                            ${category.category_id > 0 ? 'Lưu thay đổi' : 'Tạo danh mục'}
                        </button>

                        <a href="${pageContext.request.contextPath}/admin/categories" class="btn-secondary" style="width: 100%; justify-content: center; margin-top: 10px; display: flex; align-items: center; gap: 8px; text-decoration: none; padding: 10px; border-radius: 6px; background: #f1f5f9; color: #475569;">
                            <i class="fa-solid fa-xmark"></i> Hủy bỏ
                        </a>
                    </div>

                    <div class="admin-card">
                        <h3>Logo / Icon</h3>

                        <div class="form-group">
                            <label>Đường dẫn ảnh (URL)</label>
                            <input type="text" name="logo" id="logoInput"
                                   class="form-control"
                                   value="${category.logo}"
                                   placeholder="https://example.com/image.png"
                                   onchange="previewImage()">
                        </div>

                        <div class="image-upload-area" style="margin-top: 10px;">
                            <div class="upload-placeholder" id="placeholder" style="${not empty category.logo ? 'display:none' : ''}">
                                <i class="fa-regular fa-image" style="font-size: 2rem; color: #cbd5e1;"></i>
                                <p style="font-size: 0.8rem; color: #64748b;">Nhập link phía trên để xem trước</p>
                            </div>

                            <div class="image-preview-container" id="previewContainer" style="${not empty category.logo ? '' : 'display:none'}">
                                <div class="preview-item" style="width: 100%; min-height: 150px; display: flex; align-items: center; justify-content: center; background: #f8fafc; border-radius: 6px;">
                                    <img src="${category.logo}" id="imgPreview" alt="Category Logo"
                                         onerror="this.src='https://via.placeholder.com/150?text=Lỗi+Ảnh'">
                                </div>
                                <div style="text-align: center; margin-top: 10px;">
                                    <button type="button" onclick="removeImage()" style="background: none; border: none; color: #ef4444; cursor: pointer; font-size: 0.9rem;">
                                        <i class="fa-solid fa-trash"></i> Xóa ảnh
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </form>
        </div>
    </main>
</div>

<script>
    // Hàm xử lý xem trước ảnh
    function previewImage() {
        const url = document.getElementById('logoInput').value.trim();
        const placeholder = document.getElementById('placeholder');
        const container = document.getElementById('previewContainer');
        const img = document.getElementById('imgPreview');

        if (url) {
            img.src = url;
            placeholder.style.display = 'none';
            container.style.display = 'block';
        } else {
            removeImage();
        }
    }

    // Hàm xóa ảnh
    function removeImage() {
        document.getElementById('logoInput').value = '';
        document.getElementById('placeholder').style.display = 'flex'; // Flex để căn giữa icon và text
        document.getElementById('previewContainer').style.display = 'none';
    }

    // Hiệu ứng loading khi bấm nút Lưu
    document.getElementById('categoryForm').addEventListener('submit', function() {
        var btn = document.getElementById('btnSave');
        setTimeout(function() {
            btn.disabled = true;
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang xử lý...';
        }, 10);
    });
</script>

</body>
</html>