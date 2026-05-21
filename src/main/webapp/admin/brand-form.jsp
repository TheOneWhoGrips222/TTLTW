<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${brand != null ? 'Cập nhật Thương hiệu' : 'Thêm Thương hiệu mới'}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
    <link rel="stylesheet" href="../assets/css/indexfont.css"/>
    <style>
        .logo-tab-btns { display:flex; gap:8px; margin-bottom:12px; }
        .logo-tab-btn {
            padding:7px 18px; border:1px solid #d1d5db; border-radius:8px;
            background:#fff; cursor:pointer; font-size:0.875rem; color:#374151;
            transition:background .15s,color .15s;
        }
        .logo-tab-btn.active { background:#4f46e5; color:#fff; border-color:#4f46e5; font-weight:600; }
        .logo-panel { display:none; }
        .logo-panel.active { display:block; }
        .url-error { font-size:0.82rem; color:#ef4444; margin-top:5px; display:none; }
        .logo-preview-wrap {
            margin-top:14px; display:none; align-items:center; justify-content:center;
            border:1px dashed #d1d5db; border-radius:10px;
            background:#f8fafc; padding:16px; position:relative; min-height:80px;
        }
        .logo-preview-wrap img { max-height:120px; max-width:260px; object-fit:contain; }
        .logo-preview-wrap .btn-remove-img {
            position:absolute; top:6px; right:6px; background:#ef4444; color:#fff;
            border:none; border-radius:50%; width:24px; height:24px; cursor:pointer;
            font-size:13px; display:flex; align-items:center; justify-content:center;
        }
        .file-drop-zone {
            border:2px dashed #c7d2fe; border-radius:10px; background:#f5f3ff;
            padding:28px 20px; text-align:center; cursor:pointer; transition:border-color .15s;
        }
        .file-drop-zone:hover { border-color:#4f46e5; }
        .file-drop-zone i { font-size:2rem; color:#6366f1; margin-bottom:8px; }
        .file-drop-zone p { margin:4px 0; color:#4b5563; font-size:0.9rem; }
        .file-drop-zone span { font-size:0.78rem; color:#9ca3af; }
        .file-info { margin-top:8px; font-size:0.82rem; color:#6b7280; display:none; }
    </style>
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
                <h2 style="margin-left:15px;">
                    ${brand != null ? 'Cập nhật Thương hiệu' : 'Thêm Thương hiệu mới'}
                </h2>
            </div>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/brands" class="btn-secondary">Hủy bỏ</a>
                <button type="submit" form="brandForm" class="btn-primary">
                    <i class="fa-solid fa-save"></i> Lưu lại
                </button>
            </div>
        </header>

        <main class="admin-content">
            <form id="brandForm"
                  action="${pageContext.request.contextPath}/admin/brands"
                  method="post"
                  enctype="multipart/form-data"
                  class="admin-form-layout"
                  onsubmit="return validateForm()">

                <c:if test="${brand != null}">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="brand_id" value="${brand.brand_id}">
                    <input type="hidden" name="existing_logo" value="${brand.logo_url}">
                </c:if>
                <c:if test="${brand == null}">
                    <input type="hidden" name="action" value="insert">
                </c:if>

                <div class="form-col-main">
                    <div class="admin-card">
                        <h3>Thông tin chung</h3>

                        <div class="form-group">
                            <label>Tên Thương hiệu <span style="color:red">*</span></label>
                            <input type="text" name="brand_name" class="form-control"
                                   value="${brand.brand_name}"
                                   placeholder="Ví dụ: Bosch, Teka, Panasonic..." required>
                        </div>

                        <div class="form-group">
                            <label>Logo Thương hiệu</label>

                            <div class="logo-tab-btns">
                                <button type="button" class="logo-tab-btn active" id="btn-tab-url"
                                        onclick="switchTab('url', this)">
                                    <i class="fa-solid fa-link"></i> Nhập URL
                                </button>
                                <button type="button" class="logo-tab-btn" id="btn-tab-file"
                                        onclick="switchTab('file', this)">
                                    <i class="fa-solid fa-upload"></i> Tải từ máy tính
                                </button>
                            </div>

                            <div id="panel-url" class="logo-panel active">
                                <input type="text" name="logo_url" id="logoUrlInput"
                                       class="form-control"
                                       value="${brand.logo_url.startsWith('http') ? brand.logo_url : ''}"
                                       placeholder="https://example.com/logo.png"
                                       oninput="handleUrlInput(this.value)">
                                <div class="url-error" id="urlError"></div>
                            </div>

                            <div id="panel-file" class="logo-panel">
                                <div class="file-drop-zone"
                                     onclick="document.getElementById('logoFileInput').click()"
                                     ondragover="event.preventDefault()"
                                     ondrop="handleDrop(event)">
                                    <i class="fa-solid fa-cloud-arrow-up"></i>
                                    <p>Kéo thả ảnh vào đây hoặc <strong>click để chọn file</strong></p>
                                    <span>Hỗ trợ JPG, PNG, SVG — tối đa 2MB</span>
                                </div>
                                <input type="file" name="logo_file" id="logoFileInput"
                                       style="display:none" accept=".jpg,.jpeg,.png,.svg"
                                       onchange="handleFileSelect(this)">
                                <div class="file-info" id="fileInfo"></div>
                            </div>

                            <div class="logo-preview-wrap" id="previewWrap">
                                <img id="logoPreview" src="" alt="Preview logo">
                                <button type="button" class="btn-remove-img" onclick="clearPreview()" title="Xóa ảnh">
                                    <i class="fa-solid fa-times"></i>
                                </button>
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
                        <p style="font-size:0.85rem;color:var(--admin-text-light);">
                            Thương hiệu hoạt động sẽ hiển thị trong bộ lọc tìm kiếm sản phẩm.
                        </p>
                    </div>
                    <div class="admin-card">
                        <h3>Lưu ý về Logo</h3>
                        <p style="font-size:0.9rem;color:var(--admin-text-light);line-height:1.6;">
                            Nên dùng ảnh nền trong suốt (.png / .svg) để hiển thị đẹp.
                            Tỉ lệ khuyến nghị 3:2 hoặc 16:9, tối đa <strong>2MB</strong>.
                        </p>
                    </div>
                </div>
            </form>
        </main>
    </div>
</div>

<script>
    var CTX = '${pageContext.request.contextPath}';
    var currentTab = 'url';

    (function init() {
        var logo    = '${brand.logo_url}';
        if (!logo || logo.trim() === '') return;
        if (logo.startsWith('http://') || logo.startsWith('https://')) {
            showPreview(logo.trim());
        } else {
            showPreview(CTX + '/' + logo.trim());
        }
    })();

    function switchTab(tab, btn) {
        currentTab = tab;
        document.querySelectorAll('.logo-tab-btn').forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');
        document.querySelectorAll('.logo-panel').forEach(function(p) { p.classList.remove('active'); });
        document.getElementById('panel-' + tab).classList.add('active');
        if (tab === 'url') {
            document.getElementById('logoFileInput').value = '';
            document.getElementById('fileInfo').style.display = 'none';
        } else {
            document.getElementById('logoUrlInput').value = '';
            document.getElementById('urlError').style.display = 'none';
        }
        clearPreview();
    }

    function handleUrlInput(val) {
        var errEl = document.getElementById('urlError');
        if (!val || val.trim() === '') { errEl.style.display = 'none'; clearPreview(); return; }
        if (val.startsWith('http://') || val.startsWith('https://')) {
            errEl.style.display = 'none';
            var img = new Image();
            img.onload  = function() { showPreview(val); };
            img.onerror = function() {
                errEl.textContent = '⚠ Không tải được ảnh từ URL này. Vui lòng kiểm tra lại.';
                errEl.style.display = 'block';
                clearPreview();
            };
            img.src = val;
        } else {
            errEl.textContent = '⚠ URL không hợp lệ. Phải bắt đầu bằng http:// hoặc https://';
            errEl.style.display = 'block';
            clearPreview();
        }
    }

    function handleFileSelect(input) {
        var file = input.files[0];
        if (!file) return;
        var allowed = ['image/jpeg', 'image/png', 'image/svg+xml'];
        if (!allowed.includes(file.type)) { alert('Chỉ chấp nhận JPG, PNG hoặc SVG.'); input.value = ''; return; }
        if (file.size > 2 * 1024 * 1024) { alert('File vượt quá 2MB.'); input.value = ''; return; }
        document.getElementById('fileInfo').textContent = '📎 ' + file.name + ' (' + (file.size/1024).toFixed(1) + ' KB)';
        document.getElementById('fileInfo').style.display = 'block';
        var reader = new FileReader();
        reader.onload = function(e) { showPreview(e.target.result); };
        reader.readAsDataURL(file);
    }

    function handleDrop(event) {
        event.preventDefault();
        var file = event.dataTransfer.files[0];
        if (!file) return;
        var input = document.getElementById('logoFileInput');
        var dt = new DataTransfer();
        dt.items.add(file);
        input.files = dt.files;
        handleFileSelect(input);
    }

    function showPreview(src) {
        document.getElementById('logoPreview').src = src;
        document.getElementById('previewWrap').style.display = 'flex';
    }

    function clearPreview() {
        document.getElementById('previewWrap').style.display = 'none';
        document.getElementById('logoPreview').src = '';
    }

    function validateForm() {
        if (currentTab === 'url') {
            var url = document.getElementById('logoUrlInput').value.trim();
            if (url !== '' && !url.startsWith('http://') && !url.startsWith('https://')) {
                document.getElementById('urlError').textContent = '⚠ URL không hợp lệ.';
                document.getElementById('urlError').style.display = 'block';
                document.getElementById('logoUrlInput').focus();
                return false;
            }
        }
        return true;
    }
</script>
</body>
</html>
