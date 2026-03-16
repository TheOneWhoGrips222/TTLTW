<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.product_id > 0 ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm mới'} | Admin</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">

    <style>
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 4px; font-weight: 500;}
        .alert-success { color: #155724; background-color: #d4edda; border: 1px solid #c3e6cb; }
        .alert-danger { color: #721c24; background-color: #f8d7da; border: 1px solid #f5c6cb; }

        /* Ẩn input file mặc định nếu muốn dùng URL ảnh */
        .image-preview-container { border: 1px solid #ddd; margin-top: 10px; border-radius: 5px; overflow: hidden;}
        /* --- Khung ảnh đại diện chính --- */
        .image-upload-area {
            width: 100%;
            margin-top: 10px;
        }

        #previewContainer {
            width: 100%;
            height: 250px; /* Cố định chiều cao ảnh chính */
            border: 2px dashed #ddd;
            border-radius: 8px;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        #imgPreview {
            width: 100%;
            height: 100%;
            /* 'contain' giúp thấy toàn bộ ảnh, 'cover' giúp ảnh lấp đầy khung */
            object-fit: contain;
            background-color: #fff;
        }

        /* --- Thư viện ảnh phụ (Gallery) --- */
        .existing-images {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 15px;
            padding: 10px;
            background: #fdfdfd;
            border: 1px solid #eee;
            border-radius: 5px;
        }

        .image-item {
            position: relative;
            width: 85px;  /* Cố định chiều rộng thumbnail */
            height: 85px; /* Cố định chiều cao thumbnail */
            border: 1px solid #ddd;
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            background: #fff;
        }

        .image-item img {
            width: 100%;
            height: 100%;
            object-fit: cover; /* Ảnh phụ thường dùng cover để đều và đẹp */
            border-radius: 5px;
        }

        /* Nút xóa ảnh phụ */
        .btn-delete-img {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #ff4757;
            color: white;
            border: none;
            border-radius: 50%;
            width: 22px;
            height: 22px;
            font-size: 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            z-index: 10;
        }

        .btn-delete-img:hover {
            background: #ff6b81;
            transform: scale(1.1);
        }
    </style>
</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">

        <header class="admin-header">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/admin/products" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
            <div class="admin-profile">
                <h3 style="margin: 0;">${product.product_id > 0 ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm mới'}</h3>
            </div>
        </header>

        <div class="admin-content">

            <c:if test="${not empty sessionScope.msg}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-check-circle"></i> ${sessionScope.msg}
                    <% session.removeAttribute("msg"); %>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fa-solid fa-triangle-exclamation"></i> ${error}
                </div>
            </c:if>

            <form id="productForm" action="${pageContext.request.contextPath}/admin/product-save" method="post" class="admin-form-layout">

                <input type="hidden" name="product_id" value="${product.product_id}">

                <div class="col-main">
                    <div class="admin-card">
                        <h3>Thông tin chung</h3>

                        <div class="form-group">
                            <label>Tên sản phẩm (*)</label>
                            <input type="text" class="form-control" name="product_name"
                                   value="${product.product_name}" required placeholder="Nhập tên sản phẩm...">
                        </div>

                        <div class="form-group">
                            <label>Mô tả chi tiết</label>
                            <textarea class="form-control" name="description" rows="6" placeholder="Mô tả sản phẩm...">${product.description}</textarea>
                        </div>
                    </div>

                    <div class="admin-card">
                        <h3>Dữ liệu giá & Kho</h3>
                        <div class="admin-grid" style="grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>Giá bán (VNĐ) (*)</label>
                                <input type="number" class="form-control" name="price"
                                       value="${product.price > 0 ? String.format('%.0f', product.price) : ''}"
                                       required min="0" placeholder="0">
                            </div>

                            <div class="form-group">
                                <label>Số lượng tồn kho</label>
                                <input type="number" class="form-control" name="stock_quantity"
                                       value="${product.stock_quantity > 0 ? product.stock_quantity : ''}"
                                       min="0" placeholder="0">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sidebar">
                    <div class="admin-card">
                        <h3>Hành động</h3>
                        <div style="display: flex; flex-direction: column; gap: 10px;">
                            <button type="submit" id="btnSave" class="btn-primary" style="justify-content: center; width: 100%;">
                                <i class="fa-solid fa-save"></i>
                                ${product.product_id > 0 ? 'Cập nhật thay đổi' : 'Lưu sản phẩm'}
                            </button>
                        </div>
                    </div>

                    <div class="admin-card">
                        <h3>Phân loại</h3>

                        <div class="form-group">
                            <label>Danh mục (*)</label>
                            <select name="category_id" class="form-control" required>
                                <option value="">-- Chọn danh mục --</option>
                                <c:forEach items="${listCategories}" var="c">
                                    <option value="${c.category_id}" ${product.category_id == c.category_id ? 'selected' : ''}>
                                            ${c.category_name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Thương hiệu (*)</label>
                            <select name="brand_id" class="form-control" required>
                                <option value="">-- Chọn thương hiệu --</option>
                                <c:forEach items="${listBrands}" var="b">
                                    <option value="${b.brand_id}" ${product.brand_id == b.brand_id ? 'selected' : ''}>
                                            ${b.brand_name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <form id="productForm" action="${pageContext.request.contextPath}/admin/product-save"
                          method="post" enctype="multipart/form-data" class="admin-form-layout">

                        <div class="col-sidebar">
                            <div class="admin-card">
                                <h3>Ảnh đại diện (Chính)</h3>
                                <div class="form-group">
                                    <label>Cách 1: Upload từ máy</label>
                                    <input type="file" name="imageFile" class="form-control" accept="image/*" onchange="previewMainFile(this)">
                                </div>
                                <div class="form-group">
                                    <label>Cách 2: Hoặc nhập Link URL</label>
                                    <input type="text" class="form-control" name="image" id="imgInput"
                                           value="${product.image}" onchange="previewImage()" placeholder="https://example.com/image.jpg">
                                </div>

                                <div class="image-upload-area">
                                    <div id="previewContainer" style="${not empty product.image ? '' : 'display:none'}">
                                        <img src="${product.image}" id="imgPreview">
                                    </div>
                                </div>
                            </div>

                            <div class="admin-card">
                                <h3>Thư viện ảnh (Product Images)</h3>

                                <div class="existing-images" style="display: flex; flex-wrap: wrap; gap: 5px; margin-bottom: 10px;">
                                    <c:forEach items="${extraImages}" var="img">
                                    </c:forEach>
                                    <div class="existing-images">
                                        <c:forEach items="${extraImages}" var="img">
                                            <div class="image-item" id="img-container-${img.image_id}">
                                                <img src="${img.image_url.startsWith('http') ? img.image_url : pageContext.request.contextPath.concat('/').concat(img.image_url)}">
                                                <button type="button" class="btn-delete-img" onclick="deleteExtraImage(${img.image_id})">
                                                    <i class="fa-solid fa-xmark"></i>
                                                </button>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Upload nhiều ảnh (Giữ Ctrl để chọn)</label>
                                    <input type="file" name="extraImageFiles" class="form-control" multiple accept="image/*">
                                </div>

                                <div class="form-group">
                                    <label>Hoặc thêm Link ảnh thủ công</label>
                                    <div id="urlContainer">
                                    </div>
                                    <button type="button" onclick="addUrlInput()" class="btn-secondary" style="margin-top: 5px; font-size: 0.8rem;">
                                        <i class="fa-solid fa-plus"></i> Thêm ô nhập Link
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    function deleteExtraImage(imageId) {
        if (confirm('Bạn có chắc chắn muốn xóa ảnh này?')) {
            // Sử dụng Fetch API để gửi yêu cầu xóa tới Servlet
            const params = new URLSearchParams();
            params.append('image_id', imageId);

            fetch('${pageContext.request.contextPath}/admin/delete-product-image', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params
            })
                .then(response => response.text())
                .then(result => {
                    if (result === 'success') {
                        // Xóa phần tử trên giao diện mà không cần load lại trang
                        const element = document.getElementById('img-container-' + imageId);
                        if (element) {
                            element.style.opacity = '0';
                            setTimeout(() => element.remove(), 300);
                        }
                    } else {
                        alert('Có lỗi xảy ra khi xóa ảnh.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Không thể kết nối đến máy chủ.');
                });
        }
    }
    function previewMainFile(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('imgPreview').src = e.target.result;
                document.getElementById('previewContainer').style.display = 'block';
                document.getElementById('placeholder').style.display = 'none';
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Script thêm ô nhập URL cho ảnh phụ
    function addUrlInput() {
        var container = document.getElementById("urlContainer");
        var div = document.createElement("div");
        div.style.marginBottom = "5px";
        div.style.display = "flex";
        div.style.gap = "5px";
        div.innerHTML = `
            <input type="text" name="extraImageUrls" class="form-control" placeholder="Link ảnh phụ..." style="font-size: 0.9rem;">
            <button type="button" onclick="this.parentElement.remove()" style="background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; cursor: pointer;">X</button>
        `;
        container.appendChild(div);
    }
    // Hàm xem trước ảnh
    function previewImage() {
        const url = document.getElementById('imgInput').value.trim();
        const placeholder = document.getElementById('placeholder');
        const container = document.getElementById('previewContainer');
        const img = document.getElementById('imgPreview');

        if(url) {
            img.src = url;
            placeholder.style.display = 'none';
            container.style.display = 'block';
        } else {
            placeholder.style.display = 'flex'; // hoặc block tùy css của bạn
            container.style.display = 'none';
        }
    }

    // Chặn submit nhiều lần (Loading)
    document.getElementById('productForm').addEventListener('submit', function() {
        var btn = document.getElementById('btnSave');
        setTimeout(function() {
            btn.disabled = true;
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang xử lý...';
        }, 10);
    });
</script>

</body>
</html>