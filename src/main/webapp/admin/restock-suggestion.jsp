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
    <style>
        .restock-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        .restock-stat-card {
            background: #fff;
            border-radius: 12px;
            padding: 20px 24px;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: 0 1px 4px rgba(0,0,0,.06);
            border: 1px solid #f0f0f0;
        }
        .restock-stat-card .icon {
            width: 48px; height: 48px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem; flex-shrink: 0;
        }
        .icon-urgent  { background: #fef2f2; color: #ef4444; }
        .icon-warning { background: #fffbeb; color: #f59e0b; }
        .icon-total   { background: #eff6ff; color: #3b82f6; }
        .restock-stat-card .info p { margin: 0; font-size: .82rem; color: #6b7280; }
        .restock-stat-card .info h3 { margin: 4px 0 0; font-size: 1.6rem; font-weight: 700; color: #111827; }

        .badge-urgent {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 10px; border-radius: 20px;
            background: #fef2f2; color: #dc2626;
            font-size: .78rem; font-weight: 600;
        }
        .badge-warning {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 10px; border-radius: 20px;
            background: #fffbeb; color: #d97706;
            font-size: .78rem; font-weight: 600;
        }

        .days-critical { color: #dc2626; font-weight: 700; }
        .days-warning  { color: #d97706; font-weight: 600; }
        .days-ok       { color: #059669; }

        .suggest-qty {
            font-weight: 700;
            color: #4f46e5;
            font-size: 1rem;
        }

        .product-cell {
            display: flex; align-items: center; gap: 10px;
        }
        .product-cell img {
            width: 42px; height: 42px; object-fit: cover;
            border-radius: 8px; border: 1px solid #f0f0f0;
        }
        .product-cell .pname {
            font-weight: 600; font-size: .88rem; color: #111827;
            display: -webkit-box; -webkit-line-clamp: 2;
            -webkit-box-orient: vertical; overflow: hidden;
        }

        .filter-tabs {
            display: flex; gap: 8px; margin-bottom: 16px;
        }
        .filter-tab {
            padding: 7px 18px; border-radius: 8px; border: 1px solid #e5e7eb;
            background: #fff; cursor: pointer; font-size: .875rem; color: #374151;
            transition: background .15s;
        }
        .filter-tab.active        { background: #4f46e5; color: #fff; border-color: #4f46e5; font-weight: 600; }
        .filter-tab.tab-urgent    { }
        .filter-tab.tab-urgent.active  { background: #ef4444; border-color: #ef4444; }
        .filter-tab.tab-warning.active { background: #f59e0b; border-color: #f59e0b; }

        .hidden-row { display: none; }
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
                <a href="${pageContext.request.contextPath}/admin/restock" class="btn-secondary">
                    <i class="fa-solid fa-rotate-right"></i> Làm mới
                </a>
            </div>
        </header>

        <div class="admin-content">

            <div class="restock-stats">
                <div class="restock-stat-card">
                    <div class="icon icon-urgent"><i class="fa-solid fa-circle-exclamation"></i></div>
                    <div class="info">
                        <p>Cần nhập gấp</p>
                        <h3>${urgentCount}</h3>
                    </div>
                </div>
                <div class="restock-stat-card">
                    <div class="icon icon-warning"><i class="fa-solid fa-triangle-exclamation"></i></div>
                    <div class="info">
                        <p>Sắp hết hàng</p>
                        <h3>${warningCount}</h3>
                    </div>
                </div>
                <div class="restock-stat-card">
                    <div class="icon icon-total"><i class="fa-solid fa-list-check"></i></div>
                    <div class="info">
                        <p>Tổng cần xử lý</p>
                        <h3>${urgentCount + warningCount}</h3>
                    </div>
                </div>
            </div>

            <div class="admin-card">
                <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px; margin-bottom:16px;">
                    <h3 style="margin:0;">Danh sách sản phẩm cần nhập</h3>
                    <div class="filter-tabs">
                        <button class="filter-tab active" onclick="filterTable('all', this)">
                            Tất cả (${urgentCount + warningCount})
                        </button>
                        <button class="filter-tab tab-urgent" onclick="filterTable('URGENT', this)">
                            <i class="fa-solid fa-circle-exclamation"></i> Gấp (${urgentCount})
                        </button>
                        <button class="filter-tab tab-warning" onclick="filterTable('WARNING', this)">
                            <i class="fa-solid fa-triangle-exclamation"></i> Sắp hết (${warningCount})
                        </button>
                    </div>
                </div>

                <table class="admin-table" id="restockTable">
                    <thead>
                    <tr>
                        <th width="30%">Sản phẩm</th>
                        <th width="10%" style="text-align:center;">Tồn kho</th>
                        <th width="13%" style="text-align:center;">TB bán/ngày</th>
                        <th width="14%" style="text-align:center;">Dự kiến hết</th>
                        <th width="14%" style="text-align:center;">Đề xuất nhập</th>
                        <th width="13%" style="text-align:center;">Mức độ</th>
                        <th width="6%" style="text-align:center;">Chi tiết</th>
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
                                <tr class="restock-row" data-urgency="${s.urgencyLevel}">
                                    <td>
                                        <div class="product-cell">
                                            <c:choose>
                                                <c:when test="${empty s.productImage}">
                                                    <img src="https://placehold.co/42x42?text=SP" alt="No image">
                                                </c:when>
                                                <c:when test="${s.productImage.startsWith('http://') or s.productImage.startsWith('https://')}">
                                                    <img src="${s.productImage}"
                                                         onerror="this.src='https://placehold.co/42x42?text=SP'"
                                                         alt="${s.productName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/${s.productImage}"
                                                         onerror="this.src='https://placehold.co/42x42?text=SP'"
                                                         alt="${s.productName}">
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="pname">${s.productName}</span>
                                        </div>
                                    </td>
                                    <td style="text-align:center;font-weight:600;">
                                        <c:choose>
                                            <c:when test="${s.urgencyLevel == 'URGENT'}">
                                                <span style="color:#dc2626;">${s.stockQuantity}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:#d97706;">${s.stockQuantity}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center;">${s.avgSoldPerDay}</td>
                                    <td style="text-align:center;">
                                        <c:choose>
                                            <c:when test="${s.daysUntilEmpty <= 7}">
                                                <span class="days-critical">
                                                    <i class="fa-solid fa-clock"></i>
                                                    ${s.daysUntilEmpty} ngày
                                                </span>
                                            </c:when>
                                            <c:when test="${s.daysUntilEmpty <= 14}">
                                                <span class="days-warning">${s.daysUntilEmpty} ngày</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="days-ok">${s.daysUntilEmpty} ngày</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center;">
                                        <span class="suggest-qty">+${s.suggestedQuantity}</span>
                                    </td>
                                    <td style="text-align:center;">
                                        <c:choose>
                                            <c:when test="${s.urgencyLevel == 'URGENT'}">
                                                <span class="badge-urgent">
                                                    <i class="fa-solid fa-circle-exclamation"></i> Cần gấp
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-warning">
                                                    <i class="fa-solid fa-triangle-exclamation"></i> Sắp hết
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center;">
                                        <a href="${pageContext.request.contextPath}/admin/product-save?action=edit&id=${s.productId}"
                                           class="btn-view" title="Xem sản phẩm">
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
                    * Dựa trên dữ liệu đơn hoàn thành trong 30 ngày gần nhất.
                    Ngưỡng cần gấp: tồn kho &le; TB 7 ngày &times; 2.
                    Ngưỡng sắp hết: tồn kho &le; TB 14 ngày &times; 2.
                </p>
            </div>
        </div>
    </main>
</div>

<script>
    function filterTable(urgency, btn) {
        document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
        btn.classList.add('active');

        document.querySelectorAll('.restock-row').forEach(function(row) {
            if (urgency === 'all' || row.dataset.urgency === urgency) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>
