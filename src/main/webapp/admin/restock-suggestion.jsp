<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đề xuất nhập hàng | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
    <script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspdf-autotable@3.8.2/dist/jspdf.plugin.autotable.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/export-utils.js"></script>
    <style>
        .restock-stats{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:24px}
        .restock-stat-card{background:#fff;border-radius:12px;padding:20px 24px;display:flex;align-items:center;gap:16px;box-shadow:0 1px 4px rgba(0,0,0,.06);border:1px solid #f0f0f0}
        .restock-stat-card .icon{width:48px;height:48px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.4rem;flex-shrink:0}
        .icon-urgent{background:#fef2f2;color:#ef4444}.icon-warning{background:#fffbeb;color:#f59e0b}.icon-total{background:#eff6ff;color:#3b82f6}
        .restock-stat-card .info p{margin:0;font-size:.82rem;color:#6b7280}
        .restock-stat-card .info h3{margin:4px 0 0;font-size:1.6rem;font-weight:700;color:#111827}
        .badge-urgent{display:inline-flex;align-items:center;gap:5px;padding:4px 10px;border-radius:20px;background:#fef2f2;color:#dc2626;font-size:.78rem;font-weight:600}
        .badge-warning{display:inline-flex;align-items:center;gap:5px;padding:4px 10px;border-radius:20px;background:#fffbeb;color:#d97706;font-size:.78rem;font-weight:600}
        .days-critical{color:#dc2626;font-weight:700}.days-warning{color:#d97706;font-weight:600}.days-ok{color:#059669}
        .suggest-qty{font-weight:700;color:#4f46e5;font-size:1rem}
        .product-cell{display:flex;align-items:center;gap:10px}
        .product-cell img{width:42px;height:42px;object-fit:cover;border-radius:8px;border:1px solid #f0f0f0}
        .product-cell .pname{font-weight:600;font-size:.88rem;color:#111827}
        .filter-tabs{display:flex;gap:8px}
        .filter-tab{padding:7px 18px;border-radius:8px;border:1px solid #e5e7eb;background:#fff;cursor:pointer;font-size:.875rem;color:#374151;transition:background .15s}
        .filter-tab.active{background:#4f46e5;color:#fff;border-color:#4f46e5;font-weight:600}
        .filter-tab.tab-urgent.active{background:#ef4444;border-color:#ef4444}
        .filter-tab.tab-warning.active{background:#f59e0b;border-color:#f59e0b}
        .toolbar-row{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;margin-bottom:16px}
        .export-group{display:flex;gap:5px}
        .btn-export{display:inline-flex;align-items:center;gap:5px;padding:6px 12px;border-radius:8px;border:1px solid #e5e7eb;background:#fff;cursor:pointer;font-size:.8rem;color:#374151;font-weight:500;transition:background .15s}
        .btn-export:hover{background:#f3f4f6}
        .btn-export.csv{border-color:#10b981;color:#10b981}.btn-export.csv:hover{background:#ecfdf5}
        .btn-export.excel{border-color:#2563eb;color:#2563eb}.btn-export.excel:hover{background:#eff6ff}
        .btn-export.pdf{border-color:#ef4444;color:#ef4444}.btn-export.pdf:hover{background:#fef2f2}
        .btn-import{display:inline-flex;align-items:center;gap:6px;padding:6px 14px;border-radius:8px;border:none;background:#4f46e5;color:#fff;cursor:pointer;font-size:.82rem;font-weight:600;transition:background .15s}
        .btn-import:hover{background:#4338ca}
        .modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,.45);z-index:1000;display:none;align-items:center;justify-content:center}
        .modal-overlay.open{display:flex}
        .modal-box{background:#fff;border-radius:16px;padding:28px 32px;width:440px;max-width:95vw;box-shadow:0 8px 32px rgba(0,0,0,.18)}
        .modal-box h3{margin:0 0 20px;font-size:1.1rem;font-weight:700;color:#111827;display:flex;align-items:center;gap:8px}
        .form-row{margin-bottom:14px}
        .form-row label{display:block;font-size:.82rem;font-weight:600;color:#374151;margin-bottom:5px}
        .form-row input,.form-row select,.form-row textarea{width:100%;padding:8px 12px;border:1px solid #d1d5db;border-radius:8px;font-size:.875rem;box-sizing:border-box}
        .form-row textarea{resize:vertical;height:70px}
        .modal-actions{display:flex;gap:10px;justify-content:flex-end;margin-top:18px}
        .btn-cancel{padding:8px 18px;border-radius:8px;border:1px solid #e5e7eb;background:#fff;cursor:pointer;font-size:.875rem;color:#6b7280}
        .btn-submit{padding:8px 20px;border-radius:8px;border:none;background:#4f46e5;color:#fff;cursor:pointer;font-size:.875rem;font-weight:600}
        .btn-submit:hover{background:#4338ca}
        .toast{position:fixed;bottom:28px;right:28px;background:#10b981;color:#fff;padding:12px 20px;border-radius:10px;font-size:.9rem;font-weight:600;box-shadow:0 4px 16px rgba(0,0,0,.15);z-index:2000;display:none}
        .toast.show{display:block;animation:slideUp .3s ease}
        @keyframes slideUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"/>
    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <h2><i class="fa-solid fa-boxes-stacked" style="color:#4f46e5;margin-right:8px;"></i>Đề xuất nhập hàng</h2>
            </div>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/import-history" class="btn-secondary">
                    <i class="fa-solid fa-clock-rotate-left"></i> Lịch sử nhập hàng
                </a>
                <a href="${pageContext.request.contextPath}/admin/restock" class="btn-secondary" style="margin-left:8px;">
                    <i class="fa-solid fa-rotate-right"></i> Làm mới
                </a>
            </div>
        </header>

        <div class="admin-content">

            <c:if test="${importSuccess}">
                <div class="toast show" id="successToast">
                    <i class="fa-solid fa-check-circle"></i> Nhập kho thành công! Tồn kho đã được cập nhật.
                </div>
            </c:if>

            <div class="restock-stats">
                <div class="restock-stat-card">
                    <div class="icon icon-urgent"><i class="fa-solid fa-circle-exclamation"></i></div>
                    <div class="info"><p>Cần nhập gấp</p><h3>${urgentCount}</h3></div>
                </div>
                <div class="restock-stat-card">
                    <div class="icon icon-warning"><i class="fa-solid fa-triangle-exclamation"></i></div>
                    <div class="info"><p>Sắp hết hàng</p><h3>${warningCount}</h3></div>
                </div>
                <div class="restock-stat-card">
                    <div class="icon icon-total"><i class="fa-solid fa-list-check"></i></div>
                    <div class="info"><p>Tổng cần xử lý</p><h3>${urgentCount + warningCount}</h3></div>
                </div>
            </div>

            <div class="admin-card">
                <div class="toolbar-row">
                    <div style="display:flex;align-items:center;gap:12px;flex-wrap:wrap;">
                        <h3 style="margin:0;">Danh sách sản phẩm cần nhập</h3>
                        <div class="filter-tabs">
                            <button class="filter-tab active" onclick="filterTable('all',this)">Tất cả (${urgentCount + warningCount})</button>
                            <button class="filter-tab tab-urgent" onclick="filterTable('URGENT',this)"><i class="fa-solid fa-circle-exclamation"></i> Gấp (${urgentCount})</button>
                            <button class="filter-tab tab-warning" onclick="filterTable('WARNING',this)"><i class="fa-solid fa-triangle-exclamation"></i> Sắp hết (${warningCount})</button>
                        </div>
                    </div>
                    <div class="export-group">
                        <button class="btn-export csv"   onclick="exportRestockCSV()">  <i class="fa-solid fa-file-csv"></i> CSV</button>
                        <button class="btn-export excel" onclick="exportRestockExcel()"><i class="fa-solid fa-file-excel"></i> Excel</button>
                        <button class="btn-export pdf"   onclick="exportRestockPDF()">  <i class="fa-solid fa-file-pdf"></i> PDF</button>
                    </div>
                </div>

                <table class="admin-table" id="restockTable">
                    <thead>
                    <tr>
                        <th width="28%">Sản phẩm</th>
                        <th width="9%"  style="text-align:center;">Tồn kho</th>
                        <th width="12%" style="text-align:center;">TB bán/ngày</th>
                        <th width="12%" style="text-align:center;">Dự kiến hết</th>
                        <th width="13%" style="text-align:center;">Đề xuất nhập</th>
                        <th width="11%" style="text-align:center;">Mức độ</th>
                        <th width="15%" style="text-align:center;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty suggestions}">
                            <tr>
                                <td colspan="7" style="text-align:center;padding:40px;color:#9ca3af;">
                                    <i class="fa-solid fa-check-circle" style="font-size:2rem;color:#10b981;margin-bottom:10px;display:block;"></i>
                                    Tất cả sản phẩm đang có tồn kho đủ dùng.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="s" items="${suggestions}">
                                <tr class="restock-row"
                                    data-urgency="${s.urgencyLevel}"
                                    data-id="${s.productId}"
                                    data-name="${s.productName}"
                                    data-stock="${s.stockQuantity}"
                                    data-avg="${s.avgSoldPerDay}"
                                    data-days="${s.daysUntilEmpty}"
                                    data-suggest="${s.suggestedQuantity}"
                                    data-level="${s.urgencyLevel == 'URGENT' ? 'Cần gấp' : 'Sắp hết'}">
                                    <td>
                                        <div class="product-cell">
                                            <c:choose>
                                                <c:when test="${empty s.productImage}">
                                                    <img src="https://placehold.co/42x42?text=SP" alt="No image">
                                                </c:when>
                                                <c:when test="${s.productImage.startsWith('http://') or s.productImage.startsWith('https://')}">
                                                    <img src="${s.productImage}" onerror="this.src='https://placehold.co/42x42?text=SP'" alt="${s.productName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/${s.productImage}" onerror="this.src='https://placehold.co/42x42?text=SP'" alt="${s.productName}">
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="pname">${s.productName}</span>
                                        </div>
                                    </td>
                                    <td style="text-align:center;font-weight:600;">
                                        <span style="color:${s.urgencyLevel == 'URGENT' ? '#dc2626' : '#d97706'};">${s.stockQuantity}</span>
                                    </td>
                                    <td style="text-align:center;">${s.avgSoldPerDay}</td>
                                    <td style="text-align:center;">
                                        <c:choose>
                                            <c:when test="${s.daysUntilEmpty <= 7}"><span class="days-critical"><i class="fa-solid fa-clock"></i> ${s.daysUntilEmpty} ngày</span></c:when>
                                            <c:when test="${s.daysUntilEmpty <= 14}"><span class="days-warning">${s.daysUntilEmpty} ngày</span></c:when>
                                            <c:otherwise><span class="days-ok">${s.daysUntilEmpty} ngày</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center;"><span class="suggest-qty">+${s.suggestedQuantity}</span></td>
                                    <td style="text-align:center;">
                                        <c:choose>
                                            <c:when test="${s.urgencyLevel == 'URGENT'}"><span class="badge-urgent"><i class="fa-solid fa-circle-exclamation"></i> Cần gấp</span></c:when>
                                            <c:otherwise><span class="badge-warning"><i class="fa-solid fa-triangle-exclamation"></i> Sắp hết</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center;display:flex;gap:6px;justify-content:center;padding:8px 0;">
                                        <button class="btn-import"
                                                onclick="openImportModal(${s.productId}, '${s.productName}', ${s.suggestedQuantity})"
                                                title="Ghi nhận nhập kho">
                                            <i class="fa-solid fa-truck-ramp-box"></i> Nhập kho
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin/product-save?action=edit&id=${s.productId}" class="btn-view" title="Chỉnh sửa sản phẩm">
                                            <i class="fa-solid fa-pen"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
                <p style="font-size:.8rem;color:#9ca3af;margin-top:12px;text-align:right;">
                    * Dựa trên lịch sử bán hàng thực tế (bảng <code>product_sold_history</code>).
                    Đề xuất = nhu cầu 30 ngày × 1,5 − tồn kho − đã nhập gần đây.
                    Ngưỡng gấp: tồn ≤ TB 7 ngày × 2 | Ngưỡng sắp hết: tồn ≤ TB 14 ngày × 2.
                </p>
            </div>
        </div>
    </main>
</div>

<div class="modal-overlay" id="importModal">
    <div class="modal-box">
        <h3><i class="fa-solid fa-truck-ramp-box" style="color:#4f46e5;"></i> Ghi nhận nhập kho</h3>
        <form method="post" action="${pageContext.request.contextPath}/admin/import-history">
            <input type="hidden" id="modalProductId" name="productId">

            <div class="form-row">
                <label>Sản phẩm</label>
                <input type="text" id="modalProductName" readonly style="background:#f9fafb;color:#6b7280;">
            </div>

            <div class="form-row">
                <label>Số lượng nhập <span style="color:#ef4444;">*</span></label>
                <input type="number" name="quantity" id="modalQuantity" min="1" required placeholder="Nhập số lượng">
            </div>

            <div class="form-row">
                <label>Nhà cung cấp</label>
                <select name="supplierId">
                    <option value="">-- Chọn nhà cung cấp --</option>
                    <c:forEach var="sup" items="${suppliers}">
                        <option value="${sup.supplier_id}">${sup.company_name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-row">
                <label>Đơn giá nhập (VNĐ)</label>
                <input type="number" name="unitPrice" min="0" step="1000" placeholder="Để trống nếu chưa có">
            </div>

            <div class="form-row">
                <label>Ghi chú</label>
                <textarea name="note" placeholder="Ghi chú lô hàng, điều kiện,..."></textarea>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closeImportModal()">Hủy</button>
                <button type="submit" class="btn-submit"><i class="fa-solid fa-check"></i> Xác nhận nhập kho</button>
            </div>
        </form>
    </div>
</div>

<div class="toast" id="successToast2"></div>

<script>
    let curFilter = 'all';
    function filterTable(urgency, btn) {
        curFilter = urgency;
        document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
        btn.classList.add('active');
        document.querySelectorAll('.restock-row').forEach(row => {
            row.style.display = (urgency === 'all' || row.dataset.urgency === urgency) ? '' : 'none';
        });
    }

    function openImportModal(productId, productName, suggestedQty) {
        document.getElementById('modalProductId').value   = productId;
        document.getElementById('modalProductName').value = productName;
        document.getElementById('modalQuantity').value    = suggestedQty;
        document.getElementById('importModal').classList.add('open');
    }
    function closeImportModal() {
        document.getElementById('importModal').classList.remove('open');
    }
    document.getElementById('importModal').addEventListener('click', function(e) {
        if (e.target === this) closeImportModal();
    });

    window.addEventListener('DOMContentLoaded', () => {
        const t = document.getElementById('successToast');
        if (t && t.classList.contains('show')) {
            setTimeout(() => t.style.opacity = '0', 3000);
        }
    });

    const RESTOCK_HEADERS = ['Sản phẩm','Tồn kho','TB bán/ngày','Dự kiến hết (ngày)','Đề xuất nhập','Mức độ'];
    function getRestockRows() {
        const rows = [];
        document.querySelectorAll('.restock-row').forEach(tr => {
            if (curFilter !== 'all' && tr.dataset.urgency !== curFilter) return;
            rows.push([
                tr.dataset.name,
                tr.dataset.stock,
                tr.dataset.avg,
                tr.dataset.days,
                '+' + tr.dataset.suggest,
                tr.dataset.level
            ]);
        });
        return rows;
    }
    const fname = 'de-xuat-nhap-hang-' + new Date().toLocaleDateString('vi-VN').replace(/\//g,'-');
    function exportRestockCSV()   { exportCSV(RESTOCK_HEADERS,   getRestockRows(), fname); }
    function exportRestockExcel() { exportExcel(RESTOCK_HEADERS, getRestockRows(), fname, 'Nhập hàng'); }
    function exportRestockPDF()   { exportPDF(RESTOCK_HEADERS,   getRestockRows(), fname, 'Đề xuất nhập hàng'); }
</script>
</body>
</html>