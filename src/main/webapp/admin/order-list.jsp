<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đơn hàng | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
    <script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspdf-autotable@3.8.2/dist/jspdf.plugin.autotable.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/pdf-vn-font.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/export-utils.js"></script>
    <style>
        .page-link.disabled { opacity:.4; pointer-events:none; cursor:default; }
        .admin-pagination   { justify-content:center; }
        .pagination-info    { text-align:center; font-size:.82rem; color:#6b7280; margin-top:8px; }
        .export-group       { display:flex; gap:5px; }
        .btn-export         { display:inline-flex; align-items:center; gap:5px; padding:6px 12px; border-radius:8px;
            border:1px solid #e5e7eb; background:#fff; cursor:pointer; font-size:.8rem;
            color:#374151; font-weight:500; transition:background .15s; }
        .btn-export:hover   { background:#f3f4f6; }
        .btn-export.csv     { border-color:#10b981; color:#10b981; }
        .btn-export.csv:hover   { background:#ecfdf5; }
        .btn-export.excel   { border-color:#2563eb; color:#2563eb; }
        .btn-export.excel:hover { background:#eff6ff; }
        .btn-export.pdf     { border-color:#ef4444; color:#ef4444; }
        .btn-export.pdf:hover   { background:#fef2f2; }
        .card-header-row    { display:flex; align-items:center; justify-content:space-between; margin-bottom:14px; flex-wrap:wrap; gap:10px; }
        .card-header-row h3 { margin:0; }
    </style>
</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left"><h2>Quản lý Đơn hàng</h2></div>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/order" class="btn-secondary">
                    <i class="fa-solid fa-rotate-right"></i> Làm mới
                </a>
            </div>
        </header>

        <div class="admin-content">

            <c:if test="${not empty param.msg}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-check-circle"></i> ${param.msg}
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger">
                    <i class="fa-solid fa-exclamation-circle"></i>
                    Đã có lỗi xảy ra, vui lòng thử lại!
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/order" method="get" class="admin-filters">
                <input type="hidden" name="action" value="list">
                <input type="text" name="keyword"
                       placeholder="Tìm theo mã đơn hoặc tên khách..."
                       value="${keyword}" style="max-width:300px;">
                <select name="status_filter" style="width:200px;">
                    <option value="">-- Tất cả trạng thái --</option>
                    <option value="CHO_XAC_NHAN"  ${statusFilter == 'CHO_XAC_NHAN'  ? 'selected' : ''}>Chờ xác nhận</option>
                    <option value="VAN_CHUYEN"     ${statusFilter == 'VAN_CHUYEN'    ? 'selected' : ''}>Đang vận chuyển</option>
                    <option value="HOAN_THANH"     ${statusFilter == 'HOAN_THANH'    ? 'selected' : ''}>Hoàn thành</option>
                    <option value="DA_HUY"         ${statusFilter == 'DA_HUY'        ? 'selected' : ''}>Đã hủy</option>
                </select>
                <button type="submit" class="btn-filter">
                    <i class="fa-solid fa-search"></i> Tìm kiếm
                </button>
            </form>

            <div class="admin-card">
                <div class="card-header-row">
                    <h3>Danh sách đơn hàng
                        <span style="font-size:.85rem;font-weight:400;color:#6b7280;">(${totalRecords} đơn)</span>
                    </h3>
                    <div class="export-group">
                        <button class="btn-export csv"   onclick="exportOrderCSV()">  <i class="fa-solid fa-file-csv"></i> CSV</button>
                        <button class="btn-export excel" onclick="exportOrderExcel()"><i class="fa-solid fa-file-excel"></i> Excel</button>
                        <button class="btn-export pdf"   onclick="exportOrderPDF()">  <i class="fa-solid fa-file-pdf"></i> PDF</button>
                    </div>
                </div>

                <table class="admin-table" id="orderTable">
                    <thead>
                    <tr>
                        <th width="10%">Mã ĐH</th>
                        <th width="20%">Khách hàng</th>
                        <th width="15%">Ngày đặt</th>
                        <th width="15%">Tổng tiền</th>
                        <th width="15%">Trạng thái</th>
                        <th width="10%">Thanh toán</th>
                        <th width="15%" class="text-right">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr data-id="${o.order_id}"
                            data-name="${o.userName}"
                            data-date="${o.created_at.toLocalDate()} ${o.created_at.toLocalTime().toString().substring(0,5)}"
                            data-amount="${o.total_amount}"
                            data-status="${o.status}"
                            data-payment="${o.payment_method}">
                            <td><strong>#${o.order_id}</strong></td>
                            <td>
                                <div style="font-weight:600;">${o.userName}</div>
                                <div style="font-size:.8rem;color:#9ca3af;">
                                    <c:choose>
                                        <c:when test="${not empty o.addressDetail and o.addressDetail.length() > 30}">
                                            ${o.addressDetail.substring(0,30)}...
                                        </c:when>
                                        <c:otherwise>${o.addressDetail}</c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                            <td>
                                    ${o.created_at.toLocalDate()}<br>
                                <span style="font-size:.8rem;color:#9ca3af;">${o.created_at.toLocalTime().toString().substring(0,5)}</span>
                            </td>
                            <td style="font-weight:600;">
                                <fmt:setLocale value="vi_VN"/>
                                <fmt:formatNumber value="${o.total_amount}" type="currency"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${o.status == 'CHO_XAC_NHAN'}"><span class="status processing">Chờ xác nhận</span></c:when>
                                    <c:when test="${o.status == 'VAN_CHUYEN' or o.status == 'CHO_GIAO_HANG'}"><span class="status processing" style="background:#e0f7fa;color:#006064;">Vận chuyển</span></c:when>
                                    <c:when test="${o.status == 'HOAN_THANH'}"><span class="status completed">Hoàn thành</span></c:when>
                                    <c:when test="${o.status == 'DA_HUY'}"><span class="status cancelled">Đã hủy</span></c:when>
                                    <c:otherwise><span class="status" style="background:#f1f5f9;color:#64748b;">${o.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td><span style="font-size:.85rem;color:#9ca3af;">${o.payment_method == 'COD' ? 'Tiền mặt' : 'Chuyển khoản'}</span></td>
                            <td class="text-right">
                                <a href="${pageContext.request.contextPath}/admin/order?action=detail&id=${o.order_id}" class="btn-view" title="Xem chi tiết">
                                    <i class="fa-solid fa-eye"></i> Xem
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orders}">
                        <tr><td colspan="7" style="text-align:center;padding:30px;color:#9ca3af;">Không tìm thấy đơn hàng nào.</td></tr>
                    </c:if>
                    </tbody>
                </table>

                <%-- Phân trang --%>
                <c:if test="${totalRecords > 0}">
                    <div class="admin-pagination">
                        <c:choose>
                            <c:when test="${currentPage <= 1}"><a href="#" class="page-link disabled"><i class="fa-solid fa-chevron-left"></i></a></c:when>
                            <c:otherwise><a href="${pageContext.request.contextPath}/admin/order?action=list&page=${currentPage-1}&keyword=${keyword}&status_filter=${statusFilter}" class="page-link"><i class="fa-solid fa-chevron-left"></i></a></c:otherwise>
                        </c:choose>
                        <c:if test="${currentPage > 3}">
                            <a href="${pageContext.request.contextPath}/admin/order?action=list&page=1&keyword=${keyword}&status_filter=${statusFilter}" class="page-link">1</a>
                            <c:if test="${currentPage > 4}"><a href="#" class="page-link disabled">…</a></c:if>
                        </c:if>
                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                            <c:if test="${i >= 1 and i <= totalPages}">
                                <c:choose>
                                    <c:when test="${i == currentPage}"><a href="#" class="page-link active">${i}</a></c:when>
                                    <c:otherwise><a href="${pageContext.request.contextPath}/admin/order?action=list&page=${i}&keyword=${keyword}&status_filter=${statusFilter}" class="page-link">${i}</a></c:otherwise>
                                </c:choose>
                            </c:if>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages - 2}">
                            <c:if test="${currentPage < totalPages - 3}"><a href="#" class="page-link disabled">…</a></c:if>
                            <a href="${pageContext.request.contextPath}/admin/order?action=list&page=${totalPages}&keyword=${keyword}&status_filter=${statusFilter}" class="page-link">${totalPages}</a>
                        </c:if>
                        <c:choose>
                            <c:when test="${currentPage >= totalPages}"><a href="#" class="page-link disabled"><i class="fa-solid fa-chevron-right"></i></a></c:when>
                            <c:otherwise><a href="${pageContext.request.contextPath}/admin/order?action=list&page=${currentPage+1}&keyword=${keyword}&status_filter=${statusFilter}" class="page-link"><i class="fa-solid fa-chevron-right"></i></a></c:otherwise>
                        </c:choose>
                    </div>
                    <p class="pagination-info">Trang ${currentPage} / ${totalPages} &nbsp;|&nbsp; Tổng ${totalRecords} đơn hàng</p>
                </c:if>
            </div>
        </div>
    </main>
</div>

<script>
    const STATUS_MAP = {
        'CHO_XAC_NHAN':'Chờ xác nhận','VAN_CHUYEN':'Vận chuyển',
        'CHO_GIAO_HANG':'Vận chuyển','HOAN_THANH':'Hoàn thành','DA_HUY':'Đã hủy'
    };
    const ORDER_HEADERS = ['Mã ĐH','Khách hàng','Ngày đặt','Tổng tiền (đ)','Trạng thái','Thanh toán'];

    function getOrderRows() {
        const rows = [];
        document.querySelectorAll('#orderTable tbody tr[data-id]').forEach(tr => {
            rows.push([
                '#' + tr.dataset.id,
                tr.dataset.name,
                tr.dataset.date,
                tr.dataset.amount,
                STATUS_MAP[tr.dataset.status] || tr.dataset.status,
                tr.dataset.payment === 'COD' ? 'Tiền mặt' : 'Chuyển khoản'
            ]);
        });
        return rows;
    }
    const fname = 'danh-sach-don-hang-' + new Date().toLocaleDateString('vi-VN').replace(/\//g,'-');
    function exportOrderCSV()   { exportCSV(ORDER_HEADERS,   getOrderRows(), fname); }
    function exportOrderExcel() { exportExcel(ORDER_HEADERS, getOrderRows(), fname, 'Đơn hàng'); }
    function exportOrderPDF()   { exportPDF(ORDER_HEADERS,   getOrderRows(), fname, 'Danh sách đơn hàng'); }
</script>
</body>
</html>
