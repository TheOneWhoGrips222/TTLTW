<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspdf-autotable@3.8.2/dist/jspdf.plugin.autotable.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/pdf-vn-font.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/export-utils.js"></script>
    <style>
        .dashboard-cards{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;margin-bottom:28px}
        .dash-card{background:#fff;border-radius:14px;padding:22px 24px;display:flex;align-items:center;gap:18px;box-shadow:0 1px 4px rgba(0,0,0,.07);border:1px solid #f0f0f0}
        .dash-card .icon{width:54px;height:54px;border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:1.5rem;flex-shrink:0}
        .icon-green{background:#ecfdf5;color:#10b981}.icon-blue{background:#eff6ff;color:#3b82f6}.icon-yellow{background:#fffbeb;color:#f59e0b}
        .dash-card .info p{margin:0;font-size:.82rem;color:#6b7280}
        .dash-card .info h3{margin:4px 0 0;font-size:1.55rem;font-weight:700;color:#111827}
        .chart-card,.table-card{background:#fff;border-radius:14px;padding:24px;box-shadow:0 1px 4px rgba(0,0,0,.07);border:1px solid #f0f0f0;margin-bottom:24px}
        .chart-header{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;margin-bottom:16px}
        .chart-header h3{margin:0;font-size:1.05rem}
        .chart-toolbar{display:flex;align-items:center;gap:8px;flex-wrap:wrap}
        .mode-tabs{display:flex;gap:5px}
        .mode-tab{padding:6px 14px;border-radius:8px;border:1px solid #e5e7eb;background:#fff;cursor:pointer;font-size:.82rem;color:#374151;transition:background .15s}
        .mode-tab:hover{background:#f3f4f6}
        .mode-tab.active{background:#4f46e5;color:#fff;border-color:#4f46e5;font-weight:600}
        .custom-range{display:none;align-items:center;gap:8px;margin-top:10px;flex-wrap:wrap}
        .custom-range.show{display:flex}
        .custom-range input[type=date]{padding:6px 10px;border:1px solid #d1d5db;border-radius:8px;font-size:.85rem}
        .btn-apply{padding:6px 14px;background:#4f46e5;color:#fff;border:none;border-radius:8px;cursor:pointer;font-size:.82rem;font-weight:600}
        .export-group{display:flex;gap:5px}
        .btn-export{display:inline-flex;align-items:center;gap:5px;padding:6px 12px;border-radius:8px;border:1px solid #e5e7eb;background:#fff;cursor:pointer;font-size:.8rem;color:#374151;font-weight:500;transition:background .15s;text-decoration:none}
        .btn-export:hover{background:#f3f4f6}
        .btn-export.csv{border-color:#10b981;color:#10b981}.btn-export.csv:hover{background:#ecfdf5}
        .btn-export.excel{border-color:#2563eb;color:#2563eb}.btn-export.excel:hover{background:#eff6ff}
        .btn-export.pdf{border-color:#ef4444;color:#ef4444}.btn-export.pdf:hover{background:#fef2f2}
        .chart-wrap{position:relative;height:320px}
        #chartLoading{position:absolute;inset:0;display:none;align-items:center;justify-content:center;background:rgba(255,255,255,.7);border-radius:8px;z-index:10;font-size:.9rem;color:#6b7280}
        #chartLoading.show{display:flex}
        .product-img{width:46px;height:46px;object-fit:cover;border-radius:8px}
        .section-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:16px}
        .section-header h3{margin:0;font-size:1.05rem}
        .modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,.45);z-index:1000;display:none;align-items:center;justify-content:center}
        .modal-overlay.open{display:flex}
        .detail-modal-box{background:#fff;border-radius:16px;padding:26px 28px;width:700px;max-width:95vw;max-height:85vh;overflow-y:auto;box-shadow:0 8px 32px rgba(0,0,0,.18)}
        .detail-modal-box h3{margin:0;font-size:1.1rem;font-weight:700;color:#111827;display:flex;align-items:center;gap:8px}
        .detail-modal-box .detail-sub{margin:4px 0 18px;font-size:.85rem;color:#6b7280}
        .detail-close{padding:6px 10px;border-radius:8px;border:1px solid #e5e7eb;background:#fff;cursor:pointer;color:#6b7280}
        .detail-close:hover{background:#f3f4f6}
        .detail-summary{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:20px}
        .detail-summary .box{background:#f9fafb;border-radius:10px;padding:12px 14px;border:1px solid #f0f0f0}
        .detail-summary .box p{margin:0;font-size:.75rem;color:#6b7280}
        .detail-summary .box h4{margin:4px 0 0;font-size:1.05rem;color:#111827}
        .detail-modal-box h5{margin:18px 0 10px;font-size:.9rem;color:#374151;display:flex;align-items:center;gap:6px}
        .detail-table{width:100%;border-collapse:collapse;font-size:.85rem}
        .detail-table th{text-align:left;color:#6b7280;font-weight:600;padding:8px 6px;border-bottom:1px solid #e5e7eb}
        .detail-table td{padding:8px 6px;border-bottom:1px solid #f3f4f6;color:#111827;vertical-align:middle}
        .detail-table img{width:34px;height:34px;object-fit:cover;border-radius:6px}
        .detail-empty{text-align:center;color:#9ca3af;padding:16px;font-size:.85rem}
        #pdLoading{display:none;text-align:center;padding:20px;color:#6b7280;font-size:.85rem}
        #pdLoading.show{display:block}
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"/>
    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left"><h2>Tổng quan kinh doanh</h2></div>
        </header>
        <div class="admin-content">

            <div class="dashboard-cards">
                <div class="dash-card">
                    <div class="icon icon-green"><i class="fa-solid fa-coins"></i></div>
                    <div class="info"><p>Doanh thu thực tế</p><h3>${totalRevenueFormat} đ</h3></div>
                </div>
                <div class="dash-card">
                    <div class="icon icon-blue"><i class="fa-solid fa-cart-shopping"></i></div>
                    <div class="info"><p>Tổng đơn hàng</p><h3>${totalOrders}</h3></div>
                </div>
                <div class="dash-card">
                    <div class="icon icon-yellow"><i class="fa-solid fa-users"></i></div>
                    <div class="info"><p>Khách hàng thành viên</p><h3>${totalUsers}</h3></div>
                </div>
            </div>

            <div class="chart-card">
                <div class="chart-header">
                    <h3><i class="fa-solid fa-chart-line" style="color:#4f46e5;margin-right:6px;"></i>Biểu đồ doanh thu</h3>
                    <div class="chart-toolbar">
                        <div class="mode-tabs">
                            <button class="mode-tab active" onclick="setMode('day',this)">Ngày</button>
                            <button class="mode-tab" onclick="setMode('week',this)">Tuần</button>
                            <button class="mode-tab" onclick="setMode('month',this)">Tháng</button>
                            <button class="mode-tab" onclick="setMode('year',this)">Năm</button>
                            <button class="mode-tab" onclick="setMode('custom',this)">Tùy chỉnh</button>
                        </div>
                        <div class="export-group">
                            <button class="btn-export csv"   onclick="exportChartCSV()">  <i class="fa-solid fa-file-csv"></i> CSV</button>
                            <button class="btn-export excel" onclick="exportChartExcel()"><i class="fa-solid fa-file-excel"></i> Excel</button>
                            <button class="btn-export pdf"   onclick="exportChartPDF()">  <i class="fa-solid fa-file-pdf"></i> PDF</button>
                        </div>
                    </div>
                </div>
                <div class="custom-range" id="customRange">
                    <label style="font-size:.85rem;">Từ</label>
                    <input type="date" id="fromDate">
                    <label style="font-size:.85rem;">Đến</label>
                    <input type="date" id="toDate">
                    <button class="btn-apply" onclick="loadCustom()">Áp dụng</button>
                </div>
                <div class="chart-wrap">
                    <div id="chartLoading"><i class="fa-solid fa-spinner fa-spin" style="margin-right:6px;"></i>Đang tải...</div>
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>

            <%-- TOP SẢN PHẨM --%>
            <div class="table-card">
                <div class="section-header">
                    <h3><i class="fa-solid fa-trophy" style="color:#f59e0b;margin-right:6px;"></i>Top 5 Sản phẩm bán chạy</h3>
                    <div class="export-group">
                        <button class="btn-export csv"   onclick="exportTopCSV()">  <i class="fa-solid fa-file-csv"></i> CSV</button>
                        <button class="btn-export excel" onclick="exportTopExcel()"><i class="fa-solid fa-file-excel"></i> Excel</button>
                        <button class="btn-export pdf"   onclick="exportTopPDF()">  <i class="fa-solid fa-file-pdf"></i> PDF</button>
                    </div>
                </div>
                <table class="admin-table" id="topProductTable">
                    <thead>
                    <tr><th width="8%">Ảnh</th><th>Tên sản phẩm</th><th width="12%">Đã bán</th><th width="22%">Doanh thu</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${topProducts}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${p.productImage.startsWith('http://') or p.productImage.startsWith('https://')}">
                                        <img src="${p.productImage}" class="product-img" alt="${p.productName}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/${p.productImage}" class="product-img" alt="${p.productName}">
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${p.productName}</td>
                            <td><strong>${p.totalSold}</strong></td>
                            <td>${p.formattedRevenue}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty topProducts}">
                        <tr><td colspan="4" style="text-align:center;color:#9ca3af;padding:20px;">Chưa có dữ liệu.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<div class="modal-overlay" id="periodDetailModal">
    <div class="detail-modal-box">
        <div style="display:flex;align-items:center;justify-content:space-between;">
            <h3 id="pdTitle"><i class="fa-solid fa-circle-info" style="color:#4f46e5;"></i> Chi tiết</h3>
            <div style="display:flex;align-items:center;gap:8px;">
                <button class="btn-export pdf" id="pdExportBtn" onclick="exportCurrentPeriodPDF()"><i class="fa-solid fa-file-pdf"></i> Xuất PDF</button>
                <button class="detail-close" onclick="closePeriodDetail()"><i class="fa-solid fa-xmark"></i></button>
            </div>
        </div>
        <p class="detail-sub" id="pdSub"></p>

        <div class="detail-summary">
            <div class="box"><p>Doanh thu</p><h4 id="pdRevenue">-</h4></div>
            <div class="box"><p>Số đơn</p><h4 id="pdOrderCount">-</h4></div>
            <div class="box"><p>SP bán được</p><h4 id="pdProductsSold">-</h4></div>
        </div>

        <h5><i class="fa-solid fa-box" style="color:#4f46e5;"></i> Sản phẩm đã bán trong kỳ</h5>
        <table class="detail-table">
            <thead><tr><th width="8%"></th><th>Tên sản phẩm</th><th width="16%">Số lượng</th><th width="24%">Doanh thu</th></tr></thead>
            <tbody id="pdProductBody"></tbody>
        </table>

        <h5><i class="fa-solid fa-receipt" style="color:#4f46e5;"></i> Đơn hàng trong kỳ</h5>
        <table class="detail-table">
            <thead><tr><th width="10%">Mã đơn</th><th>Khách hàng</th><th width="22%">Thời gian</th><th width="20%">Thanh toán</th><th width="18%">Tổng tiền</th></tr></thead>
            <tbody id="pdOrderBody"></tbody>
        </table>

        <div id="pdLoading"><i class="fa-solid fa-spinner fa-spin"></i> Đang tải...</div>
    </div>
</div>


<script>
    const CTX = document.getElementById('revenueChart').getContext('2d');
    const API = '${pageContext.request.contextPath}/admin/chart-data';
    const API_PERIOD_DETAIL = '${pageContext.request.contextPath}/admin/period-detail';
    const CTX_PATH = '${pageContext.request.contextPath}';
    let chart   = null;
    let curMode = 'day';
    let chartData = [];

    function fmtMoney(v) { return new Intl.NumberFormat('vi-VN').format(v) + ' đ'; }

    function buildChart(data) {
        chartData = data;
        const labels   = data.map(d => d.date);
        const revenues = data.map(d => d.value);
        const orders   = data.map(d => d.orderCount);
        const products = data.map(d => d.productsSold);
        if (chart) chart.destroy();
        chart = new Chart(CTX, {
            type: 'line',
            data: {
                labels,
                datasets: [{
                    label: 'Doanh thu',
                    data: revenues,
                    borderColor: '#4f46e5',
                    backgroundColor: 'rgba(79,70,229,0.08)',
                    borderWidth: 2.5,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 4,
                    pointHoverRadius: 7,
                    pointBackgroundColor: '#4f46e5'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: { mode: 'index', intersect: false },
                onHover: (evt, elements) => {
                    evt.native.target.style.cursor = elements.length ? 'pointer' : 'default';
                },
                onClick: (evt, elements) => {
                    if (elements.length) openPeriodDetail(elements[0].index);
                },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            title: i => 'Kỳ: ' + i[0].label,
                            afterTitle: i => ['📦 Số đơn: ' + orders[i[0].dataIndex], '🛍️ SP bán được: ' + products[i[0].dataIndex]],
                            label:  i => '💰 Doanh thu: ' + fmtMoney(i.raw)
                        },
                        backgroundColor: '#1f2937',
                        titleColor: '#f9fafb',
                        bodyColor: '#d1d5db',
                        padding: 12,
                        cornerRadius: 10,
                        displayColors: false
                    }
                },
                scales: {
                    x: { grid: { display: false } },
                    y: {
                        beginAtZero: true,
                        ticks: { callback: v => v >= 1e6 ? (v/1e6).toFixed(0)+'tr' : v >= 1e3 ? (v/1e3).toFixed(0)+'k' : v }
                    }
                }
            }
        });
    }

    function showLoading(s) { document.getElementById('chartLoading').classList.toggle('show', s); }

    function loadData(mode, from, to) {
        showLoading(true);
        let url = API + '?mode=' + mode;
        if (mode === 'custom' && from && to) url += '&from=' + from + '&to=' + to;
        fetch(url).then(r => r.json()).then(buildChart).catch(e => console.error(e)).finally(() => showLoading(false));
    }

    function setMode(mode, btn) {
        curMode = mode;
        document.querySelectorAll('.mode-tab').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        const cr = document.getElementById('customRange');
        if (mode === 'custom') { cr.classList.add('show'); }
        else { cr.classList.remove('show'); loadData(mode); }
    }

    function loadCustom() {
        const f = document.getElementById('fromDate').value;
        const t = document.getElementById('toDate').value;
        if (!f || !t) { alert('Vui lòng chọn đầy đủ khoảng thời gian.'); return; }
        if (f > t)    { alert('Ngày bắt đầu phải nhỏ hơn ngày kết thúc.'); return; }
        loadData('custom', f, t);
    }

    const CHART_HEADERS = ['Kỳ', 'Doanh thu (đ)', 'Số đơn', 'SP bán được'];
    function chartRows() {
        return chartData.map(d => [d.date, d.value, d.orderCount, d.productsSold]);
    }
    function chartFilename() { return 'doanh-thu-' + curMode + '-' + new Date().toLocaleDateString('vi-VN').replace(/\//g,'-'); }
    function exportChartCSV()   { exportCSV(CHART_HEADERS, chartRows(), chartFilename()); }
    function exportChartExcel() { exportExcel(CHART_HEADERS, chartRows(), chartFilename(), 'Doanh thu'); }
    function exportChartPDF()   { exportPDF(CHART_HEADERS, chartRows(), chartFilename(), 'Báo cáo doanh thu'); }

    function topRows() {
        const rows = [];
        document.querySelectorAll('#topProductTable tbody tr').forEach(tr => {
            const tds = tr.querySelectorAll('td');
            if (tds.length >= 4) rows.push([tds[1].innerText.trim(), tds[2].innerText.trim(), tds[3].innerText.trim()]);
        });
        return rows;
    }
    const TOP_HEADERS = ['Tên sản phẩm', 'Đã bán', 'Doanh thu'];
    function exportTopCSV()   { exportCSV(TOP_HEADERS, topRows(), 'top-san-pham-ban-chay'); }
    function exportTopExcel() { exportExcel(TOP_HEADERS, topRows(), 'top-san-pham-ban-chay', 'Top sản phẩm'); }
    function exportTopPDF()   { exportPDF(TOP_HEADERS, topRows(), 'top-san-pham-ban-chay', 'Top 5 sản phẩm bán chạy'); }

    function fmtDateVN(iso) {
        if (!iso) return '';
        const [y, m, d] = iso.split('-');
        return d + '/' + m + '/' + y;
    }

    function escapeHtml(s) {
        if (s === null || s === undefined) return '';
        return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
    }

    function productImgSrc(img) {
        if (!img) return '';
        return (img.startsWith('http://') || img.startsWith('https://')) ? img : (CTX_PATH + '/' + img);
    }

    let currentPeriodMeta = null;
    let currentPeriodData = null;

    function openPeriodDetail(index) {
        const d = chartData[index];
        if (!d || !d.periodStart || !d.periodEnd) return;
        currentPeriodMeta = d;
        currentPeriodData = null;

        document.getElementById('pdTitle').innerHTML =
            '<i class="fa-solid fa-circle-info" style="color:#4f46e5;"></i> Chi tiết kỳ: ' + escapeHtml(d.date);
        document.getElementById('pdSub').textContent = (d.periodStart === d.periodEnd)
            ? 'Ngày ' + fmtDateVN(d.periodStart)
            : 'Từ ' + fmtDateVN(d.periodStart) + ' đến ' + fmtDateVN(d.periodEnd);
        document.getElementById('pdRevenue').textContent = fmtMoney(d.value);
        document.getElementById('pdOrderCount').textContent = d.orderCount;
        document.getElementById('pdProductsSold').textContent = d.productsSold;

        document.getElementById('pdProductBody').innerHTML = '';
        document.getElementById('pdOrderBody').innerHTML = '';
        document.getElementById('pdExportBtn').disabled = true;
        document.getElementById('pdLoading').classList.add('show');
        document.getElementById('periodDetailModal').classList.add('open');

        fetch(API_PERIOD_DETAIL + '?from=' + encodeURIComponent(d.periodStart) + '&to=' + encodeURIComponent(d.periodEnd))
            .then(r => r.json())
            .then(data => { currentPeriodData = data; renderPeriodDetail(data); })
            .catch(e => {
                console.error(e);
                document.getElementById('pdProductBody').innerHTML = '<tr><td colspan="4" class="detail-empty">Không tải được dữ liệu.</td></tr>';
                document.getElementById('pdOrderBody').innerHTML = '';
            })
            .finally(() => {
                document.getElementById('pdLoading').classList.remove('show');
                document.getElementById('pdExportBtn').disabled = false;
            });
    }

    function renderPeriodDetail(data) {
        const pBody = document.getElementById('pdProductBody');
        if (!data.products || !data.products.length) {
            pBody.innerHTML = '<tr><td colspan="4" class="detail-empty">Không có sản phẩm nào được bán trong kỳ này.</td></tr>';
        } else {
            pBody.innerHTML = data.products.map(p =>
                '<tr>' +
                '<td><img src="' + productImgSrc(p.productImage) + '" onerror="this.style.visibility=\'hidden\'"></td>' +
                '<td>' + escapeHtml(p.productName) + '</td>' +
                '<td><strong>' + p.totalSold + '</strong></td>' +
                '<td>' + fmtMoney(p.totalRevenue) + '</td>' +
                '</tr>'
            ).join('');
        }

        const oBody = document.getElementById('pdOrderBody');
        if (!data.orders || !data.orders.length) {
            oBody.innerHTML = '<tr><td colspan="5" class="detail-empty">Không có đơn hàng nào trong kỳ này.</td></tr>';
        } else {
            oBody.innerHTML = data.orders.map(o =>
                '<tr>' +
                '<td>#' + o.orderId + '</td>' +
                '<td>' + escapeHtml(o.customerName) + '</td>' +
                '<td>' + escapeHtml(o.createdAt) + '</td>' +
                '<td>' + escapeHtml(o.paymentMethod) + (o.paymentStatus ? ' · ' + escapeHtml(o.paymentStatus) : '') + '</td>' +
                '<td>' + fmtMoney(o.totalAmount) + '</td>' +
                '</tr>'
            ).join('');
        }
    }

    function exportCurrentPeriodPDF() {
        if (!currentPeriodMeta) return;
        if (!currentPeriodData) {
            alert('Dữ liệu chi tiết đang được tải, vui lòng thử lại sau vài giây.');
            return;
        }
        const d = currentPeriodMeta;
        const sub = (d.periodStart === d.periodEnd)
            ? 'Ngày ' + fmtDateVN(d.periodStart)
            : 'Từ ' + fmtDateVN(d.periodStart) + ' đến ' + fmtDateVN(d.periodEnd);
        exportPeriodDetailPDF({
            title: 'Báo cáo doanh thu - Kỳ ' + d.date,
            sub: sub,
            revenueText: fmtMoney(d.value),
            orderCountText: d.orderCount,
            productsSoldText: d.productsSold,
            products: currentPeriodData.products,
            orders: currentPeriodData.orders,
            filename: 'bao-cao-ky-' + d.periodStart + (d.periodStart !== d.periodEnd ? '_' + d.periodEnd : '')
        });
    }

    function closePeriodDetail() {
        document.getElementById('periodDetailModal').classList.remove('open');
    }
    document.getElementById('periodDetailModal').addEventListener('click', function(e) {
        if (e.target === this) closePeriodDetail();
    });

    (function() {
        const today = new Date().toISOString().slice(0,10);
        const ago30 = new Date(Date.now()-30*864e5).toISOString().slice(0,10);
        document.getElementById('fromDate').value = ago30;
        document.getElementById('toDate').value   = today;
        loadData('day');
    })();
</script>
</body>
</html>
