<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${empty ecosystem ? 'Thêm mới' : 'Cập nhật'} Hệ Sinh Thái | Admin</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">

    <style>
        /* CSS riêng cho thanh tìm kiếm gợi ý */
        .search-container { position: relative; width: 100%; }
        .search-input { width: 100%; padding: 10px 15px; border: 1px solid #ddd; border-radius: 6px; outline: none; transition: 0.3s; }
        .search-input:focus { border-color: var(--primary-color); box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1); }

        .suggestions {
            position: absolute; top: 100%; left: 0; right: 0;
            background: white; border: 1px solid #eee; border-radius: 6px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            z-index: 1000; display: none; max-height: 250px; overflow-y: auto;
            margin-top: 5px;
        }
        .suggestion-item { padding: 10px 15px; cursor: pointer; border-bottom: 1px solid #f1f5f9; display: flex; align-items: center; gap: 10px;}
        .suggestion-item:last-child { border-bottom: none; }
        .suggestion-item:hover { background-color: #f8fafc; color: var(--primary-color); }
        .suggestion-item img { width: 30px; height: 30px; object-fit: contain; border-radius: 4px; border: 1px solid #ddd;}

        .product-badge { display: inline-block; padding: 2px 8px; background: #e0f2fe; color: #0284c7; border-radius: 12px; font-size: 0.75rem; font-weight: 600; margin-left: auto;}
    </style>
</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/admin/ecosystems" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
            </div>
            <div class="admin-profile">
                <h3>${empty ecosystem ? 'Tạo Hệ Sinh Thái Mới' : 'Cập nhật Hệ Sinh Thái'}</h3>
            </div>
        </header>

        <div class="admin-content">
            <c:if test="${not empty param.message}">
                <div class="alert alert-success" style="padding: 15px; background: #dcfce7; color: #166534; border-radius: 6px; margin-bottom: 20px;">
                    <i class="fa-solid fa-check"></i> ${param.message == 'saved' ? 'Lưu thành công!' : 'Thao tác thành công!'}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/ecosystems" method="post" class="admin-form-layout">
                <input type="hidden" name="action" value="${empty ecosystem ? 'insert' : 'update'}">
                <c:if test="${not empty ecosystem}">
                    <input type="hidden" name="id" value="${ecosystem.id}">
                </c:if>

                <div class="col-main">
                    <div class="admin-card">
                        <h3>Thông tin chung</h3>
                        <div class="form-group">
                            <label>Tên Hệ Sinh Thái (*)</label>
                            <input type="text" name="name" class="form-control" value="${ecosystem.name}" required placeholder="Ví dụ: Hệ sinh thái Bosch, Bếp thông minh...">
                        </div>

                    </div>

                    <c:if test="${not empty ecosystem}">
                        <div class="admin-card" style="margin-top: 20px;">
                            <h3 style="display: flex; justify-content: space-between; align-items: center;">
                                Sản phẩm thuộc hệ này
                                <span style="font-size: 0.9rem; color: #666; font-weight: normal;">${products.size()} sản phẩm</span>
                            </h3>

                            <div style="background: #f8fafc; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px dashed #cbd5e1;">
                                <label style="font-weight: 600; margin-bottom: 8px; display: block;">Thêm sản phẩm vào hệ:</label>
                                <div style="display: flex; gap: 10px;">
                                    <div class="search-container">
                                        <input type="text" id="productSearch" class="search-input" placeholder="Gõ tên sản phẩm để tìm kiếm..." autocomplete="off">
                                        <div id="suggestions" class="suggestions"></div>
                                    </div>
                                    <button type="button" id="btnAddProduct" class="btn-primary" disabled onclick="submitAddProduct()">
                                        <i class="fa-solid fa-plus"></i> Thêm
                                    </button>
                                </div>
                            </div>

                            <table class="admin-table">
                                <thead>
                                <tr>
                                    <th width="10%">ID</th>
                                    <th width="15%">Ảnh</th>
                                    <th>Tên sản phẩm</th>
                                    <th width="15%" class="text-right">Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="p" items="${products}">
                                    <tr>
                                        <td>#${p.product_id}</td>
                                        <td>
                                            <img src="${p.image}" class="product-thumbnail"
                                                 onerror="this.src='https://via.placeholder.com/50'" style="width: 50px; height: 50px;">
                                        </td>
                                        <td style="font-weight: 500;">${p.product_name}</td>
                                        <td class="text-right">
                                            <a href="${pageContext.request.contextPath}/admin/ecosystems?action=remove_product&id=${ecosystem.id}&pid=${p.product_id}"
                                               class="btn-action delete"
                                               onclick="return confirm('Bạn muốn gỡ sản phẩm này khỏi hệ sinh thái?');"
                                               title="Gỡ khỏi hệ">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty products}">
                                    <tr><td colspan="4" class="text-center" style="color: #999;">Chưa có sản phẩm nào trong hệ sinh thái này.</td></tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>

                <div class="col-sidebar">
                    <div class="admin-card">
                        <h3>Hành động</h3>
                        <button type="submit" class="btn-primary" style="width: 100%; justify-content: center;">
                            <i class="fa-solid fa-floppy-disk"></i>
                            ${empty ecosystem ? 'Tạo mới' : 'Lưu thay đổi'}
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/ecosystems" class="btn-secondary" style="width: 100%; justify-content: center; margin-top: 10px; display: flex; align-items: center; gap: 8px; text-decoration: none; padding: 10px; border-radius: 6px; background: #f1f5f9; color: #475569;">
                            <i class="fa-solid fa-xmark"></i> Hủy bỏ
                        </a>
                    </div>

                    <div class="admin-card">
                        <h3>Ảnh đại diện</h3>
                        <div class="form-group">
                            <label>Link ảnh (URL)</label>
                            <input type="text" name="image" id="imgInput" class="form-control"
                                   value="${ecosystem.image}" placeholder="https://..." onchange="previewImage()">
                        </div>
                        <div class="image-preview-container" style="margin-top: 10px; border: 1px dashed #ccc; border-radius: 6px; padding: 10px; text-align: center;">
                            <img id="imgPreview" src="${not empty ecosystem.image ? ecosystem.image : ''}"
                                 style="max-width: 100%; max-height: 200px; display: ${not empty ecosystem.image ? 'block' : 'none'}; margin: 0 auto; object-fit: contain;"
                                 onerror="this.style.display='none'">
                            <span id="imgPlaceholder" style="color: #999; font-size: 0.9rem; display: ${not empty ecosystem.image ? 'none' : 'block'};">
                                <i class="fa-regular fa-image" style="font-size: 2rem; display: block; margin-bottom: 5px;"></i>
                                Nhập link để xem trước
                            </span>
                        </div>
                    </div>
                </div>
            </form>

            <form id="addProductForm" action="${pageContext.request.contextPath}/admin/ecosystems" method="post" style="display: none;">
                <input type="hidden" name="action" value="add_product">
                <input type="hidden" name="ecosystem_id" value="${ecosystem.id}">
                <input type="hidden" id="selectedProductId" name="product_id_to_add">
            </form>

        </div>
    </main>
</div>

<script>
    // 1. Preview Ảnh
    function previewImage() {
        const url = document.getElementById('imgInput').value;
        const img = document.getElementById('imgPreview');
        const placeholder = document.getElementById('imgPlaceholder');

        if (url) {
            img.src = url;
            img.style.display = 'block';
            placeholder.style.display = 'none';
        } else {
            img.style.display = 'none';
            placeholder.style.display = 'block';
        }
    }

    // 2. Xử lý Search Gợi ý
    const searchInput = document.getElementById('productSearch');
    const suggestionsBox = document.getElementById('suggestions');
    const hiddenInput = document.getElementById('selectedProductId');
    const btnAdd = document.getElementById('btnAddProduct');
    const addForm = document.getElementById('addProductForm');

    function submitAddProduct() {
        if (hiddenInput.value) {
            addForm.submit();
        }
    }

    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const query = this.value;
            if (query.length < 2) {
                suggestionsBox.style.display = 'none';
                return;
            }

            // Gọi API Search (Đảm bảo bạn có Servlet API trả về JSON)
            fetch('${pageContext.request.contextPath}/api/product-search?q=' + encodeURIComponent(query))
                .then(response => response.json())
                .then(data => {
                    suggestionsBox.innerHTML = '';
                    if (data.length > 0) {
                        data.forEach(prod => {
                            const div = document.createElement('div');
                            div.className = 'suggestion-item';
                            // Template hiển thị: Ảnh nhỏ + Tên
                            div.innerHTML = `
                                <img src="\${prod.image}" onerror="this.src='https://placehold.co/30'">
                                <div>
                                    <div style="font-weight:500">\${prod.product_name}</div>
                                    <small style="color:#666">ID: \${prod.product_id}</small>
                                </div>
                                <span class="product-badge"><i class="fa-solid fa-plus"></i> Chọn</span>
                            `;

                            div.onclick = function() {
                                searchInput.value = prod.product_name;
                                hiddenInput.value = prod.product_id;
                                suggestionsBox.style.display = 'none';
                                btnAdd.disabled = false;
                                btnAdd.innerHTML = '<i class="fa-solid fa-check"></i> Thêm ngay';
                            };
                            suggestionsBox.appendChild(div);
                        });
                        suggestionsBox.style.display = 'block';
                    } else {
                        suggestionsBox.style.display = 'none';
                    }
                })
                .catch(err => console.error('Lỗi tìm kiếm:', err));
        });

        // Ẩn khi click ra ngoài
        document.addEventListener('click', function(e) {
            if (e.target !== searchInput && e.target !== suggestionsBox) {
                suggestionsBox.style.display = 'none';
            }
        });
    }
</script>

</body>
</html>