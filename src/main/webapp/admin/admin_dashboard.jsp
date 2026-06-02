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
    <style>
        .dashboard-cards { display:grid; grid-template-columns:repeat(3,1fr); gap:20px; margin-bottom:28px; }
        .dash-card { background:#fff; border-radius:14px; padding:22px 24px; display:flex; align-items:center;
            gap:18px; box-shadow:0 1px 4px rgba(0,0,0,.07); border:1px solid #f0f0f0; }
        .dash-card .icon { width:54px; height:54px; border-radius:14px; display:flex; align-items:center;
            justify-content:center; font-size:1.5rem; flex-shrink:0; }
        .icon-green  { background:#ecfdf5; color:#10b981; }
        .icon-blue   { background:#eff6ff; color:#3b82f6; }
        .icon-yellow { background:#fffbeb; color:#f59e0b; }
        .dash-card .info p  { margin:0; font-size:.82rem; color:#6b7280; }
        .dash-card .info h3 { margin:4px 0 0; font-size:1.55rem; font-weight:700; color:#111827; }

        .chart-card { background:#fff; border-radius:14px; padding:24px; box-shadow:0 1px 4px rgba(0,0,0,.07);
            border:1px solid #f0f0f0; margin-bottom:24px; }
        .chart-header { display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:12px; margin-bottom:20px; }
        .chart-header h3 { margin:0; font-size:1.05rem; }

        .mode-tabs { display:flex; gap:6px; }
        .mode-tab { padding:6px 16px; border-radius:8px; border:1px solid #e5e7eb; background:#fff;
            cursor:pointer; font-size:.82rem; color:#374151; transition:background .15s; }
        .mode-tab:hover { background:#f3f4f6; }
        .mode-tab.active { background:#4f46e5; color:#fff; border-color:#4f46e5; font-weight:600; }

        .custom-range { display:none; align-items:center; gap:8px; margin-top:12px; flex-wrap:wrap; }
        .custom-range.show { display:flex; }
        .custom-range input[type=date] { padding:6px 10px; border:1px solid #d1d5db; border-radius:8px;
            font-size:.85rem; color:#374151; outline:none; }
        .custom-range input[type=date]:focus { border-color:#4f46e5; }
        .btn-apply { padding:6px 16px; background:#4f46e5; color:#fff; border:none; border-radius:8px;
            cursor:pointer; font-size:.85rem; font-weight:600; }
        .btn-apply:hover { background:#4338ca; }

        .chart-wrap { position:relative; height:320px; }

        .table-card { background:#fff; border-radius:14px; padding:24px; box-shadow:0 1px 4px rgba(0,0,0,.07); border:1px solid #f0f0f0; }
        .table-card h3 { margin:0 0 16px; font-size:1.05rem; }
        .product-img { width:46px; height:46px; object-fit:cover; border-radius:8px; }

        #chartLoading { position:absolute; inset:0; display:none; align-items:center; justify-content:center;
            background:rgba(255,255,255,.7); border-radius:8px; z-index:10; font-size:.9rem; color:#6b7280; }
        #chartLoading.show { display:flex; }
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
                    <div class="info">
                        <p>Doanh thu thực tế</p>
                        <h3>${totalRevenueFormat} đ</h3>
                    </div>
                </div>
                <div class="dash-card">
                    <div class="icon icon-blue"><i class="fa-solid fa-cart-shopping"></i></div>
                    <div class="info">
                        <p>Tổng đơn hàng</p>
                        <h3>${totalOrders}</h3>
                    </div>
                </div>
                <div class="dash-card">
                    <div class="icon icon-yellow"><i class="fa-solid fa-users"></i></div>
                    <div class="info">
                        <p>Khách hàng thành viên</p>
                        <h3>${totalUsers}</h3>
                    </div>
                </div>
            </div>

            <div class="chart-card">
                <div class="chart-header">
                    <h3><i class="fa-solid fa-chart-line" style="color:#4f46e5;margin-right:6px;"></i>Biểu đồ doanh thu</h3>
                    <div class="mode-tabs">
                        <button class="mode-tab active" data-mode="day"   onclick="setMode('day',   this)">Ngày</button>
                        <button class="mode-tab"         data-mode="week"  onclick="setMode('week',  this)">Tuần</button>
                        <button class="mode-tab"         data-mode="month" onclick="setMode('month', this)">Tháng</button>
                        <button class="mode-tab"         data-mode="year"  onclick="setMode('year',  this)">Năm</button>
                        <button class="mode-tab"         data-mode="custom" onclick="setMode('custom',this)">Tùy chỉnh</button>
                    </div>
                </div>

                <div class="custom-range" id="customRange">
                    <label style="font-size:.85rem;color:#374151;">Từ</label>
                    <input type="date" id="fromDate">
                    <label style="font-size:.85rem;color:#374151;">Đến</label>
                    <input type="date" id="toDate">
                    <button class="btn-apply" onclick="loadCustom()">Áp dụng</button>
                </div>

                <div class="chart-wrap">
                    <div id="chartLoading"><i class="fa-solid fa-spinner fa-spin" style="margin-right:6px;"></i>Đang tải...</div>
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>

            <div class="table-card">
                <h3><i class="fa-solid fa-trophy" style="color:#f59e0b;margin-right:6px;"></i>Top 5 Sản phẩm bán chạy</h3>
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th width="8%">Ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th width="12%">Đã bán</th>
                        <th width="22%">Doanh thu</th>
                    </tr>
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

<script>
    const CTX   = document.getElementById('revenueChart').getContext('2d');
    const API   = '${pageContext.request.contextPath}/admin/chart-data';
    let chart   = null;
    let curMode = 'day';

    function fmtMoney(v) {
        return new Intl.NumberFormat('vi-VN').format(v) + ' đ';
    }

    function buildChart(labels, revenues, orders, products) {
        if (chart) chart.destroy();
        chart = new Chart(CTX, {
            type: 'line',
            data: {
                labels: labels,
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
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            title: function(items) {
                                return 'Kỳ: ' + items[0].label;
                            },
                            afterTitle: function(items) {
                                const i = items[0].dataIndex;
                                return [
                                    '📦 Số đơn: ' + orders[i],
                                    '🛍️ SP bán được: ' + products[i]
                                ];
                            },
                            label: function(item) {
                                return '💰 Doanh thu: ' + fmtMoney(item.raw);
                            }
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
                        ticks: {
                            callback: function(v) {
                                if (v >= 1000000) return (v/1000000).toFixed(0) + 'tr';
                                if (v >= 1000)    return (v/1000).toFixed(0) + 'k';
                                return v;
                            }
                        }
                    }
                }
            }
        });
    }

    function showLoading(show) {
        document.getElementById('chartLoading').classList.toggle('show', show);
    }

    function loadData(mode, from, to) {
        showLoading(true);
        let url = API + '?mode=' + mode;
        if (mode === 'custom' && from && to) url += '&from=' + from + '&to=' + to;

        fetch(url)
            .then(r => r.json())
            .then(data => {
                const labels   = data.map(d => d.date);
                const revenues = data.map(d => d.value);
                const orders   = data.map(d => d.orderCount);
                const products = data.map(d => d.productsSold);
                buildChart(labels, revenues, orders, products);
            })
            .catch(e => console.error('Chart error:', e))
            .finally(() => showLoading(false));
    }

    function setMode(mode, btn) {
        curMode = mode;
        document.querySelectorAll('.mode-tab').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        const customRange = document.getElementById('customRange');
        if (mode === 'custom') {
            customRange.classList.add('show');
        } else {
            customRange.classList.remove('show');
            loadData(mode);
        }
    }

    function loadCustom() {
        const from = document.getElementById('fromDate').value;
        const to   = document.getElementById('toDate').value;
        if (!from || !to) { alert('Vui lòng chọn đầy đủ khoảng thời gian.'); return; }
        if (from > to)    { alert('Ngày bắt đầu phải nhỏ hơn ngày kết thúc.'); return; }
        loadData('custom', from, to);
    }

    (function initDatePicker() {
        const today = new Date().toISOString().slice(0, 10);
        const ago30 = new Date(Date.now() - 30*24*60*60*1000).toISOString().slice(0, 10);
        document.getElementById('fromDate').value = ago30;
        document.getElementById('toDate').value   = today;
    })();

    loadData('day');
</script>
</body>
</html>
