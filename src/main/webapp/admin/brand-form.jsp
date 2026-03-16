<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${brand != null ? 'Cập nhật Thương hiệu' : 'Thêm Thương hiệu mới'}</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
    <link rel="stylesheet" href="../assets/css/indexfont.css" />

</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <div class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/admin/brands" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                </a>
                <h2 style="margin-left: 15px;">
                    ${brand != null ? 'Cập nhật Thương hiệu' : 'Thêm Thương hiệu mới'}
                </h2>
            </div>

            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/brands" class="btn-secondary">
                    Hủy bỏ
                </a>
                <button type="submit" form="brandForm" class="btn-primary">
                    <i class="fa-solid fa-save"></i> Lưu lại
                </button>
            </div>
        </header>

        <main class="admin-content">
            <form id="brandForm" action="${pageContext.request.contextPath}/admin/brands" method="post" class="admin-form-layout">

                <c:if test="${brand != null}">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="brand_id" value="${brand.brand_id}">
                </c:if>
                <c:if test="${brand == null}">
                    <input type="hidden" name="action" value="insert">
                </c:if>

                <div class="form-col-main">
                    <div class="admin-card">
                        <h3>Thông tin chung</h3>

                        <div class="form-group">
                            <label>Tên Thương hiệu <span style="color:var(--red)">*</span></label>
                            <input type="text" name="brand_name"
                                   class="form-control"
                                   value="${brand.brand_name}"
                                   placeholder="Ví dụ: Bosch, Teka, Panasonic..." required>
                        </div>

                        <div class="form-group">
                            <label>Logo Thương hiệu</label>

                            <input type="text" name="logo_url" id="logoInput"
                                   class="form-control"
                                   value="${brand.logo_url}"
                                   placeholder="Dán đường dẫn ảnh (URL) vào đây..."
                                   oninput="updatePreview(this.value)"
                                   style="margin-bottom: 15px;">

                            <div class="image-upload-area">
                                <div class="upload-placeholder">
                                    <i class="fa-solid fa-cloud-arrow-up"></i>
                                    <p>Kéo thả logo vào đây hoặc click để tải lên</p>
                                    <span style="font-size: 0.8rem; color: #94a3b8;">(Hỗ trợ PNG, JPG, SVG)</span>
                                </div>
                            </div>

                            <div class="image-preview-container" id="previewContainer" style="${empty brand.logo_url ? 'display:none;' : ''}">
                                <div class="preview-item" style="height: 100px; width: 150px; display: flex; align-items: center; justify-content: center; background: #fff;">
                                    <img src="${brand.logo_url}" id="imgPreview" alt="Preview" style="object-fit: contain;">
                                    <button type="button" class="btn-remove-img" onclick="removeImage()">
                                        <i class="fa-solid fa-times"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-col-sidebar">
                    <div class="admin-card">
                        <h3>Trạng thái</h3>

                        <div class="form-group">
                            <label>Hiển thị</label>
                            <div class="toggle-group">
                                <label class="switch">
                                    <input type="checkbox" checked>
                                    <span class="slider round"></span>
                                </label>
                                <span>Đang hoạt động</span>
                            </div>
                        </div>

                        <div class="divider"></div>
                        <p style="font-size: 0.85rem; color: var(--admin-text-light);">
                            Thương hiệu hoạt động sẽ hiển thị trong bộ lọc tìm kiếm sản phẩm.
                        </p>
                    </div>

                    <div class="admin-card">
                        <h3>Lưu ý về Logo</h3>
                        <p style="font-size: 0.9rem; color: var(--admin-text-light); line-height: 1.5;">
                            Logo thương hiệu nên dùng ảnh nền trong suốt (.png) để hiển thị đẹp trên mọi nền web. Tỉ lệ khuyến nghị 3:2 hoặc 16:9.
                        </p>
                    </div>
                </div>

            </form>
        </main>
    </div>
</div>

<script>
    // Script xử lý xem trước ảnh (giống trang Category)
    function updatePreview(url) {
        const container = document.getElementById('previewContainer');
        const img = document.getElementById('imgPreview');
        if (url.trim() !== "") {
            img.src = url;
            container.style.display = 'grid';
        } else {
            container.style.display = 'none';
        }
    }

    function removeImage() {
        document.getElementById('logoInput').value = '';
        document.getElementById('previewContainer').style.display = 'none';
    }
</script>

</body>
</html>