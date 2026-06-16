<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Nhập hàng | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
    <style>
        .import-layout {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 24px;
            align-items: start;
        }
        .form-card {
            background: #fff;
            border-radius: 14px;
            padding: 28px 32px;
            box-shadow: 0 1px 4px rgba(0,0,0,.07);
            border: 1px solid #f0f0f0;
        }
        .form-card h3 {
            margin: 0 0 24px;
            font-size: 1.05rem;
            font-weight: 700;
            color: #111827;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .form-group { margin-bottom: 18px; }
        .form-group label {
            display: block;
            font-size: .83rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 6px;
        }
        .form-group label span.req { color: #ef4444; }
        .form-control {
            width: 100%;
            padding: 9px 13px;
            border: 1px solid #d1d5db;
            border-radius: 9px;
            font-size: .9rem;
            color: #111827;
            background: #fff;
            box-sizing: border-box;
            transition: border-color .15s, box-shadow .15s;
            outline: none;
        }
        .form-control:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79,70,229,.1);
        }
        select.form-control { cursor: pointer; }
        textarea.form-control { resize: vertical; min-height: 80px; }
        .search-container { position: relative; width: 100%; }
        .suggestions {
            position: absolute; top: 100%; left: 0; right: 0;
            background: #fff; border: 1px solid #eee; border-radius: 9px;
            box-shadow: 0 4px 12px rgba(0,0,0,.08);
            z-index: 50; display: none; max-height: 280px; overflow-y: auto;
            margin-top: 6px;
        }
        .suggestion-item {
            padding: 9px 13px; cursor: pointer; display: flex; align-items: center; gap: 10px;
            border-bottom: 1px solid #f3f4f6; font-size: .87rem;
        }
        .suggestion-item:last-child { border-bottom: none; }
        .suggestion-item:hover { background: #f8fafc; }
        .suggestion-item img { width: 32px; height: 32px; object-fit: contain; border-radius: 6px; border: 1px solid #eee; background:#f9fafb; flex-shrink:0; }
        .suggestion-item .s-name { font-weight: 600; color: #111827; }
        .suggestion-item .s-meta { font-size: .76rem; color: #9ca3af; }
        .suggestion-empty { padding: 14px; text-align: center; color: #9ca3af; font-size: .85rem; }
        .selected-pill {
            display: none; align-items: center; gap: 8px; margin-top: 8px;
            background: #eef2ff; color: #4338ca; border-radius: 8px; padding: 7px 11px; font-size: .83rem; font-weight: 600;
        }
        .selected-pill i.fa-circle-check { color: #4f46e5; }
        .selected-pill .clear-sel { margin-left: auto; cursor: pointer; color: #6b7280; }
        .selected-pill .clear-sel:hover { color: #ef4444; }
        .input-group { position: relative; }
        .input-group .form-control { padding-right: 40px; }
        .input-group .suffix {
            position: absolute;
            right: 13px;
            top: 50%;
            transform: translateY(-50%);
            font-size: .82rem;
            color: #9ca3af;
            pointer-events: none;
        }
        .btn-submit {
            width: 100%;
            padding: 11px;
            background: #4f46e5;
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: .95rem;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: background .15s;
            margin-top: 8px;
        }
        .btn-submit:hover { background: #4338ca; }

        .preview-card {
            background: #fff;
            border-radius: 14px;
            padding: 24px;
            box-shadow: 0 1px 4px rgba(0,0,0,.07);
            border: 1px solid #f0f0f0;
            position: sticky;
            top: 80px;
        }
        .preview-card h3 {
            margin: 0 0 16px;
            font-size: 1rem;
            font-weight: 700;
            color: #111827;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .preview-empty {
            text-align: center;
            color: #9ca3af;
            font-size: .85rem;
            padding: 20px 0;
        }
        .preview-empty i { font-size: 2rem; display: block; margin-bottom: 8px; }

        .product-preview-box {
            display: none;
        }
        .product-preview-box .pimg {
            width: 100%;
            height: 160px;
            object-fit: contain;
            border-radius: 10px;
            background: #f9fafb;
            border: 1px solid #f0f0f0;
            margin-bottom: 14px;
        }
        .product-preview-box .pname {
            font-weight: 700;
            font-size: .95rem;
            color: #111827;
            margin-bottom: 6px;
        }
        .product-preview-box .pid {
            font-size: .78rem;
            color: #9ca3af;
            margin-bottom: 14px;
        }
        .preview-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 9px 0;
            border-bottom: 1px solid #f3f4f6;
            font-size: .85rem;
        }
        .preview-row:last-child { border-bottom: none; }
        .preview-row .label { color: #6b7280; }
        .preview-row .value { font-weight: 600; color: #111827; }
        .preview-row .value.stock-after {
            color: #059669;
            font-size: 1.05rem;
        }
        .preview-row .value.cost-val { color: #4f46e5; }

        .alert {
            border-radius: 10px;
            padding: 12px 18px;
            margin-bottom: 20px;
            font-size: .875rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-success { background: #f0fdf4; border: 1px solid #bbf7d0; color: #166534; }
        .alert-error   { background: #fef2f2; border: 1px solid #fecaca; color: #991b1b; }
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"/>
    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <h2><i class="fa-solid fa-dolly" style="color:#4f46e5;margin-right:8px;"></i>Nhập hàng</h2>
            </div>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/import-history" class="btn-secondary">
                    <i class="fa-solid fa-clock-rotate-left"></i> Lịch sử nhập hàng
                </a>
                <a href="${pageContext.request.contextPath}/admin/restock-suggestion" class="btn-secondary">
                    <i class="fa-solid fa-boxes-stacked"></i> Đề xuất nhập hàng
                </a>
            </div>
        </header>

        <div class="admin-content">

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    Nhập hàng thành công! Đã cộng thêm <strong>${success}</strong> sản phẩm vào kho.
                    <a href="${pageContext.request.contextPath}/admin/import" style="margin-left:auto;color:#166534;font-weight:600;">Nhập thêm</a>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>

            <div class="import-layout">

                <div class="form-card">
                    <h3><i class="fa-solid fa-file-import" style="color:#4f46e5;"></i> Thông tin nhập hàng</h3>

                    <form method="post" action="${pageContext.request.contextPath}/admin/import" id="importForm">

                        <div class="form-group">
                            <label>Sản phẩm <span class="req">*</span></label>
                            <div class="search-container">
                                <input type="text" id="productSearch" class="form-control"
                                       placeholder="Gõ tên sản phẩm để tìm kiếm..." autocomplete="off">
                                <div id="suggestions" class="suggestions"></div>
                            </div>
                            <input type="hidden" name="productId" id="productId">
                            <div class="selected-pill" id="selectedPill">
                                <i class="fa-solid fa-circle-check"></i>
                                <span id="selectedPillText"></span>
                                <i class="fa-solid fa-xmark clear-sel" id="clearSelected" title="Bỏ chọn"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Nhà cung cấp</label>
                            <select name="supplierId" class="form-control">
                                <option value="">-- Không xác định --</option>
                                <c:forEach var="s" items="${suppliers}">
                                    <option value="${s.supplier_id}">${s.company_name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Số lượng nhập <span class="req">*</span></label>
                            <div class="input-group">
                                <input type="number" name="quantity" id="quantity" class="form-control"
                                       min="1" placeholder="Nhập số lượng..." required
                                       oninput="updatePreview()">
                                <span class="suffix">sp</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Đơn giá nhập</label>
                            <div class="input-group">
                                <input type="text" name="unitPrice" id="unitPrice" class="form-control"
                                       placeholder="VD: 18500000" oninput="updatePreview()">
                                <span class="suffix">₫</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Ghi chú</label>
                            <textarea name="note" class="form-control" placeholder="Lô nhập, nguồn gốc, ghi chú..."></textarea>
                        </div>

                        <button type="submit" class="btn-submit">
                            <i class="fa-solid fa-truck-ramp-box"></i> Xác nhận nhập hàng
                        </button>
                    </form>
                </div>

                <div class="preview-card">
                    <h3><i class="fa-solid fa-eye" style="color:#6b7280;"></i> Xem trước</h3>

                    <div class="preview-empty" id="previewEmpty">
                        <i class="fa-solid fa-box-open"></i>
                        Chọn sản phẩm để xem thông tin
                    </div>

                    <div class="product-preview-box" id="previewBox">
                        <img id="prevImg" class="pimg" src="" alt="">
                        <div class="pname" id="prevName"></div>
                        <div class="pid"   id="prevId"></div>

                        <div class="preview-row">
                            <span class="label">Tồn kho hiện tại</span>
                            <span class="value" id="prevStock">—</span>
                        </div>
                        <div class="preview-row">
                            <span class="label">Số lượng nhập</span>
                            <span class="value" style="color:#4f46e5;" id="prevQty">—</span>
                        </div>
                        <div class="preview-row">
                            <span class="label">Tồn kho sau nhập</span>
                            <span class="value stock-after" id="prevAfter">—</span>
                        </div>
                        <div class="preview-row">
                            <span class="label">Đơn giá nhập</span>
                            <span class="value" id="prevPrice">—</span>
                        </div>
                        <div class="preview-row">
                            <span class="label">Thành tiền</span>
                            <span class="value cost-val" id="prevCost">—</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </main>
</div>

<script>
    const ctx = '${pageContext.request.contextPath}';
    let selectedProduct = null; // { id, name, stock, price, image }

    const searchInput   = document.getElementById('productSearch');
    const suggestionsBox = document.getElementById('suggestions');
    const productIdInput = document.getElementById('productId');
    const selectedPill   = document.getElementById('selectedPill');
    const selectedPillText = document.getElementById('selectedPillText');

    let searchTimer = null;

    searchInput.addEventListener('input', function() {
        const query = this.value.trim();

        // Mỗi khi gõ lại, sản phẩm đã chọn trước đó (nếu có) không còn hợp lệ nữa
        if (productIdInput.value) {
            clearSelection();
        }

        clearTimeout(searchTimer);

        if (query.length < 1) {
            suggestionsBox.style.display = 'none';
            return;
        }

        searchTimer = setTimeout(function() {
            fetch(ctx + '/api/product-search?q=' + encodeURIComponent(query))
                .then(res => res.json())
                .then(data => {
                    suggestionsBox.innerHTML = '';

                    if (!data || data.length === 0) {
                        suggestionsBox.innerHTML = '<div class="suggestion-empty">Không tìm thấy sản phẩm phù hợp</div>';
                        suggestionsBox.style.display = 'block';
                        return;
                    }

                    data.forEach(function(prod) {
                        const div = document.createElement('div');
                        div.className = 'suggestion-item';

                        const imgSrc = prod.image && prod.image.startsWith('http')
                            ? prod.image : (ctx + '/' + prod.image);

                        div.innerHTML =
                            '<img src="' + imgSrc + '" onerror="this.src=\'https://placehold.co/32?text=SP\'">' +
                            '<div>' +
                            '<div class="s-name">' + prod.product_name + '</div>' +
                            '<div class="s-meta">ID: ' + prod.product_id + ' &middot; Tồn: ' + prod.stock_quantity + ' sp</div>' +
                            '</div>';

                        div.addEventListener('click', function() {
                            selectProduct(prod);
                        });

                        suggestionsBox.appendChild(div);
                    });

                    suggestionsBox.style.display = 'block';
                })
                .catch(function() {
                    suggestionsBox.innerHTML = '<div class="suggestion-empty">Lỗi tìm kiếm, vui lòng thử lại</div>';
                    suggestionsBox.style.display = 'block';
                });
        }, 300);
    });

    document.addEventListener('click', function(e) {
        if (e.target !== searchInput && !suggestionsBox.contains(e.target)) {
            suggestionsBox.style.display = 'none';
        }
    });

    function selectProduct(prod) {
        selectedProduct = {
            id: prod.product_id,
            name: prod.product_name,
            stock: parseInt(prod.stock_quantity) || 0,
            price: parseFloat(prod.price) || 0,
            image: prod.image || ''
        };

        productIdInput.value = selectedProduct.id;
        searchInput.value = selectedProduct.name;
        suggestionsBox.style.display = 'none';

        selectedPillText.textContent = '[ID:' + selectedProduct.id + '] ' + selectedProduct.name + ' (Tồn: ' + selectedProduct.stock + ')';
        selectedPill.style.display = 'flex';

        updatePreview();
    }

    function clearSelection() {
        selectedProduct = null;
        productIdInput.value = '';
        selectedPill.style.display = 'none';
        updatePreview();
    }

    document.getElementById('clearSelected').addEventListener('click', function() {
        searchInput.value = '';
        clearSelection();
        searchInput.focus();
    });

    function updatePreview() {
        const qty   = parseInt(document.getElementById('quantity').value) || 0;
        const price = parseFloat(document.getElementById('unitPrice').value.replace(/[,\.]/g, '').replace(/[^\d]/g,'')) || 0;

        if (!selectedProduct) {
            document.getElementById('previewEmpty').style.display = 'block';
            document.getElementById('previewBox').style.display   = 'none';
            return;
        }

        const name  = selectedProduct.name;
        const stock = selectedProduct.stock;
        const pid   = selectedProduct.id;
        const img   = selectedProduct.image;

        document.getElementById('previewEmpty').style.display = 'none';
        document.getElementById('previewBox').style.display   = 'block';

        const imgEl = document.getElementById('prevImg');
        if (img.startsWith('http')) {
            imgEl.src = img;
        } else if (img) {
            imgEl.src = ctx + '/' + img;
        } else {
            imgEl.src = 'https://placehold.co/300x160?text=SP';
        }
        imgEl.onerror = () => { imgEl.src = 'https://placehold.co/300x160?text=SP'; };

        document.getElementById('prevName').textContent  = name;
        document.getElementById('prevId').textContent    = 'ID: ' + pid;
        document.getElementById('prevStock').textContent = stock.toLocaleString('vi-VN') + ' sp';
        document.getElementById('prevQty').textContent   = qty > 0 ? '+' + qty.toLocaleString('vi-VN') + ' sp' : '—';
        document.getElementById('prevAfter').textContent = qty > 0 ? (stock + qty).toLocaleString('vi-VN') + ' sp' : stock.toLocaleString('vi-VN') + ' sp';

        if (price > 0) {
            document.getElementById('prevPrice').textContent = price.toLocaleString('vi-VN') + ' ₫';
            document.getElementById('prevCost').textContent  = qty > 0
                ? (price * qty).toLocaleString('vi-VN') + ' ₫' : '—';
        } else {
            document.getElementById('prevPrice').textContent = '—';
            document.getElementById('prevCost').textContent  = '—';
        }
    }

    document.getElementById('importForm').addEventListener('submit', function(e) {
        const pid = productIdInput.value;
        const qty = parseInt(document.getElementById('quantity').value);
        if (!pid) { e.preventDefault(); alert('Vui lòng chọn sản phẩm.'); return; }
        if (!qty || qty <= 0) { e.preventDefault(); alert('Số lượng phải lớn hơn 0.'); return; }
    });
</script>
</body>
</html>

