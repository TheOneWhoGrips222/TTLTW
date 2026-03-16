<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${oldArticle.id > 0 ? 'Cập nhật bài viết' : 'Thêm bài viết mới'} | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
    <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/admin/content" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
                <h2>${oldArticle.id > 0 ? 'Cập nhật bài viết' : 'Thêm bài viết mới'}</h2>
            </div>
        </header>

        <div class="admin-content">
            <c:if test="${not empty errorMessage}">
                <div style="color: red; margin-bottom: 10px;">${errorMessage}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/admin/add-article" method="post">

                <c:if test="${oldArticle.id > 0}">
                    <input type="hidden" name="id" value="${oldArticle.id}">
                </c:if>

                <div class="admin-form-layout">

                    <div class="form-col-main">
                        <div class="admin-card">
                            <h3>Nội dung bài viết</h3>

                            <div class="form-group">
                                <label>Tiêu đề bài viết </label>
                                <input type="text" name="title" class="form-control" required
                                       value="${oldArticle.title}" placeholder="Nhập tiêu đề...">
                            </div>

                            <div class="form-grid-mini" style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                                <div class="form-group">
                                    <label>Thể loại</label>
                                    <input type="text" name="tip" class="form-control" required
                                           value="${oldArticle.tip}" placeholder="Nhập thể loại...">
                                </div>
                                <div class="form-group">
                                    <label>ID danh mục </label>
                                    <input type="text" name="cate" class="form-control" required
                                           value="${oldArticle.category_id}" placeholder="Nhập ID danh mục...">
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Mô tả ngắn</label>
                                <textarea name="summary" class="form-control" rows="3"
                                          placeholder="Tóm tắt bài viết...">${oldArticle.content}</textarea>
                            </div>

                            <div class="form-group">
                                <label>Nội dung chi tiết</label>
                                <textarea name="body" id="content-editor">${oldArticle.body}</textarea>
                            </div>
                        </div>
                    </div>

                    <div class="form-col-sidebar">
                        <div class="admin-card">
                            <h3>Hình ảnh đại diện</h3>
                            <div class="form-group">
                                <label>Đường dẫn ảnh (Link online)</label>
                                <input type="text" name="image" id="urlInput" class="form-control"
                                       value="${oldArticle.image}"
                                       placeholder="Dán link ảnh tại đây..." oninput="previewUrl(this)">

                            </div>

                            <div class="image-preview-container" id="previewContainer" style="margin-top: 15px;">
                                <c:if test="${not empty oldArticle.image}">
                                    <div class="preview-item" style="height: 150px; width: 100%;">
                                        <img src="${oldArticle.image}" id="imgPreview" alt="Preview" style="object-fit: contain; border: 2px solid var(--green);">
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="admin-card">
                            <h3>Cài đặt</h3>
                            <div class="form-group">
                                <label>Tác giả</label>
                                <input type="text" name="author" class="form-control" value="${oldArticle.author}" placeholder="Tên tác giả">
                            </div>

                            <div class="form-group">
                                <label>Trạng thái</label>
                                <div class="toggle-group">
                                    <label class="switch">
                                        <input type="checkbox" id="activeSwitch"
                                        ${oldArticle.is_active == 1 ? 'checked' : ''} onchange="updateActiveValue()">
                                        <span class="slider round"></span>
                                    </label>
                                    <span id="statusLabel">
                                        ${oldArticle.is_active == 1 ? 'Đang hiển thị' : 'Đang ẩn'}
                                    </span>
                                </div>
                                <input type="hidden" name="is_active" id="isActiveInput" value="${oldArticle.is_active > 0 ? oldArticle.is_active : '0'}">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-primary">
                        <i class="fa-solid fa-save"></i>
                        ${oldArticle.id > 0 ? 'Lưu bài viết' : 'Đăng bài viết'}
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/content" class="btn-secondary">Hủy bỏ</a>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    CKEDITOR.replace('content-editor', { height: 350, language: 'vi', versionCheck: false });

    function previewUrl(input) {
        const url = input.value.trim();
        const container = document.getElementById('previewContainer');
        if (url.length > 5) {
            container.innerHTML = `
                <div class="preview-item" style="height: 150px; width: 100%;">
                    <img src="${'${url}'}" onerror="this.src='https://via.placeholder.com/150?text=Lỗi+Link'"
                         style="object-fit: contain; border: 2px solid var(--green);">
                </div>`;
        } else {
            container.innerHTML = '';
        }
    }

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