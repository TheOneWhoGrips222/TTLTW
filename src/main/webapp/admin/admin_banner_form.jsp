<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="isEdit" value="${not empty banner}"/>
<c:set var="formTitle" value="${isEdit ? 'Cập nhật Banner' : 'Thêm Banner mới'}"/>
<c:set var="actionType" value="${isEdit ? 'update' : 'insert'}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${formTitle} | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/admin/banners" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
                <h2>${formTitle}</h2>
            </div>
        </header>

        <div class="admin-content">

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                        ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/banners" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="${actionType}">
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${banner.id}">
                    <input type="hidden" name="old_image" value="${banner.image}">
                </c:if>

                <div class="admin-form-layout">
                    <div class="form-col-main">
                        <div class="admin-card">
                            <h3>Thông tin chung</h3>

                            <div class="form-group">
                                <label>Tiêu đề Banner <span style="color: red">*</span></label>
                                <input type="text" name="title" class="form-control" required
                                       value="${isEdit ? banner.title : ''}" placeholder="Nhập tiêu đề banner...">
                            </div>

                            <div class="form-group">
                                <label>Mô tả ngắn</label>
                                <textarea name="description" class="form-control" rows="3"
                                          placeholder="Mô tả banner...">${isEdit ? banner.description : ''}</textarea>
                            </div>

                            <div class="form-group">
                                <label>Đường dẫn khi click (Link URL)</label>
                                <input type="text" name="link_url" class="form-control"
                                       value="${isEdit ? banner.link_url : '#'}" placeholder="https://...">
                            </div>

                            <div class="form-group">
                                <label>Hình ảnh Banner</label>

                                <div class="image-upload-area" onclick="document.getElementById('imgInput').click()" style="margin-bottom: 15px;">
                                    <div class="upload-placeholder">
                                        <i class="fa-solid fa-cloud-arrow-up"></i>
                                        <p>Nhấn để tải ảnh từ máy tính</p>
                                    </div>
                                    <input type="file" name="image_file" id="imgInput" style="display: none;" accept="image/*" onchange="previewFile(this)">
                                </div>

                                <div style="text-align: center; margin-bottom: 15px; color: #999; font-size: 0.9rem;">-- HOẶC --</div>

                                <div class="form-group">
                                    <label style="font-weight: normal; font-size: 0.9rem;">Dán đường dẫn ảnh (Link Online):</label>
                                    <input type="text" name="image_url" id="urlInput" class="form-control"
                                           placeholder="Ví dụ: https://img.com/banner.jpg" oninput="previewUrl(this)">
                                </div>

                                <div class="image-preview-container" id="previewContainer">
                                    <c:if test="${isEdit && not empty banner.image}">
                                        <div class="preview-item" style="height: 150px; width: 100%;">
                                            <c:choose>
                                                <c:when test="${banner.image.startsWith('http')}">
                                                    <img src="${banner.image}" alt="Preview" style="object-fit: contain;">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/${banner.image}" alt="Preview" style="object-fit: contain;">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-col-sidebar">
                        <div class="admin-card">
                            <h3>Cài đặt hiển thị</h3>

                            <div class="form-group">
                                <label>Thứ tự hiển thị (Sort Order)</label>
                                <input type="number" name="sort_order" class="form-control"
                                       value="${isEdit ? banner.sort_order : '0'}">
                                <small style="color: #64748b; font-size: 0.8rem;">Số nhỏ hiển thị trước</small>
                            </div>

                            <div class="form-group">
                                <label>Trạng thái</label>
                                <div class="toggle-group">
                                    <label class="switch">
                                        <input type="checkbox" name="is_active_check" id="activeSwitch"
                                        ${(isEdit && banner.isActive == 1) || !isEdit ? 'checked' : ''}
                                               onchange="updateActiveValue()">
                                        <span class="slider round"></span>
                                    </label>
                                    <span id="statusLabel">
                                        ${(isEdit && banner.isActive == 1) || !isEdit ? 'Đang hiển thị' : 'Đang ẩn'}
                                    </span>
                                </div>
                                <input type="hidden" name="is_active" id="isActiveInput"
                                       value="${(isEdit && banner.isActive == 1) || !isEdit ? '1' : '0'}">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-primary">
                        <i class="fa-solid fa-save"></i> Lưu Banner
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/banners" class="btn-secondary">
                        Hủy bỏ
                    </a>
                </div>

            </form>
        </div>
    </main>
</div>
<script>
    const container = document.getElementById('previewContainer');

    // 1. Xử lý khi chọn File
    function previewFile(input) {
        if (input.files && input.files[0]) {
            // Xóa nội dung ở ô URL để tránh nhầm lẫn
            document.getElementById('urlInput').value = '';

            const reader = new FileReader();
            reader.onload = function(e) {
                container.innerHTML = `
                    <div class="preview-item" style="height: 150px; width: 100%;">
                        <img src="${'${e.target.result}'}" style="object-fit: contain; border: 2px solid var(--blue);">
                    </div>`;
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    // 2. Xử lý khi nhập URL
    function previewUrl(input) {
        const url = input.value.trim();
        if (url.length > 5) { // Chỉ preview khi chuỗi đủ dài
            // Reset input file (nếu trình duyệt cho phép, hoặc chỉ cần logic backend ưu tiên file)
            // Ở đây ta chỉ hiển thị đè lên preview
            container.innerHTML = `
                <div class="preview-item" style="height: 150px; width: 100%;">
                    <img src="${'${url}'}" onerror="this.src='https://via.placeholder.com/150?text=Lỗi+Link'" style="object-fit: contain; border: 2px solid var(--green);">
                </div>`;
        }
    }
</script>
<script>
    // Preview ảnh ngay khi chọn
    function previewImage(input) {
        const container = document.getElementById('previewContainer');
        container.innerHTML = ''; // Xóa ảnh cũ

        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const div = document.createElement('div');
                div.className = 'preview-item';
                div.style.height = '120px'; // Banner preview nên to hơn chút
                div.innerHTML = '<img src="' + e.target.result + '" style="object-fit: cover;">';
                container.appendChild(div);
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Cập nhật text hiển thị và value hidden input khi bấm Toggle
    function updateActiveValue() {
        const checkbox = document.getElementById('activeSwitch');
        const hiddenInput = document.getElementById('isActiveInput');
        const label = document.getElementById('statusLabel');

        if (checkbox.checked) {
            hiddenInput.value = "1";
            label.innerText = "Đang hiển thị";
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