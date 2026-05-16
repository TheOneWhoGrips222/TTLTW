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
    <style>
        /* Chỉ bổ sung style chưa có trong admin_style.css */
        .page-link.disabled {
            opacity: 0.4;
            pointer-events: none;
            cursor: default;
        }
        .admin-pagination {
            justify-content: center; /* ghi đè flex-end thành căn giữa */
        }
        .pagination-info {
            text-align: center;
            font-size: 0.82rem;
            color: #6b7280;
            margin-top: 8px;
        }
    </style>
</head>
<body>

<div class="admin-layout">

    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <h2>Quản lý Đơn hàng</h2>
            </div>
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

            <%-- ===== Tìm kiếm & Lọc ===== --%>
            <form action="${pageContext.request.contextPath}/admin/order" method="get" class="admin-filters">
                <input type="hidden" name="action" value="list">

                <input type="text" name="keyword"
                       placeholder="Tìm theo mã đơn hoặc tên khách..."
                       value="${keyword}"
                       style="max-width: 300px;">

                <select name="status_filter" style="width: 200px;">
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
                <h3>Danh sách đơn hàng
                    <span style="font-size:0.85rem; font-weight:400; color:#6b7280;">
                        (${totalRecords} đơn)
                    </span>
                </h3>

                <table class="admin-table">
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
                        <tr>
                            <td><strong>#${o.order_id}</strong></td>

                            <td>
                                <div style="font-weight:600;">${o.userName}</div>
                                <div style="font-size:0.8rem; color:#9ca3af;">
                                    <c:choose>
                                        <c:when test="${not empty o.addressDetail and o.addressDetail.length() > 30}">
                                            ${o.addressDetail.substring(0, 30)}...
                                        </c:when>
                                        <c:otherwise>${o.addressDetail}</c:otherwise>
                                    </c:choose>
                                </div>
                            </td>

                            <td>
                                    ${o.created_at.toLocalDate()}<br>
                                <span style="font-size:0.8rem; color:#9ca3af;">
                                        ${o.created_at.toLocalTime().toString().substring(0,5)}
                                </span>
                            </td>

                            <td style="font-weight:600;">
                                <fmt:setLocale value="vi_VN"/>
                                <fmt:formatNumber value="${o.total_amount}" type="currency"/>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${o.status == 'CHO_XAC_NHAN'}">
                                        <span class="status processing">Chờ xác nhận</span>
                                    </c:when>
                                    <c:when test="${o.status == 'VAN_CHUYEN' or o.status == 'CHO_GIAO_HANG'}">
                                        <span class="status processing" style="background:#e0f7fa;color:#006064;">Vận chuyển</span>
                                    </c:when>
                                    <c:when test="${o.status == 'HOAN_THANH'}">
                                        <span class="status completed">Hoàn thành</span>
                                    </c:when>
                                    <c:when test="${o.status == 'DA_HUY'}">
                                        <span class="status cancelled">Đã hủy</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status" style="background:#f1f5f9;color:#64748b;">${o.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <span style="font-size:0.85rem;color:#9ca3af;">
                                        ${o.payment_method == 'COD' ? 'Tiền mặt' : 'Chuyển khoản'}
                                </span>
                            </td>

                            <td class="text-right">
                                <a href="${pageContext.request.contextPath}/admin/order?action=detail&id=${o.order_id}"
                                   class="btn-view" title="Xem chi tiết">
                                    <i class="fa-solid fa-eye"></i> Xem
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="7" style="text-align:center;padding:30px;color:#9ca3af;">
                                Không tìm thấy đơn hàng nào.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>

                <%-- ===== PHÂN TRANG — dùng đúng class của admin_style.css ===== --%>
                <c:if test="${totalRecords > 0}">
                    <div class="admin-pagination">

                            <%-- Nút Trước --%>
                        <c:choose>
                            <c:when test="${currentPage <= 1}">
                                <a href="#" class="page-link disabled">
                                    <i class="fa-solid fa-chevron-left"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/admin/order?action=list&page=${currentPage-1}&keyword=${keyword}&status_filter=${statusFilter}"
                                   class="page-link">
                                    <i class="fa-solid fa-chevron-left"></i>
                                </a>
                            </c:otherwise>
                        </c:choose>

                            <%-- Trang đầu + "..." --%>
                        <c:if test="${currentPage > 3}">
                            <a href="${pageContext.request.contextPath}/admin/order?action=list&page=1&keyword=${keyword}&status_filter=${statusFilter}"
                               class="page-link">1</a>
                            <c:if test="${currentPage > 4}">
                                <a href="#" class="page-link disabled">…</a>
                            </c:if>
                        </c:if>

                            <%-- Window 5 trang xung quanh trang hiện tại --%>
                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                            <c:if test="${i >= 1 and i <= totalPages}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <a href="#" class="page-link active">${i}</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/admin/order?action=list&page=${i}&keyword=${keyword}&status_filter=${statusFilter}"
                                           class="page-link">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </c:forEach>

                            <%-- "..." + trang cuối --%>
                        <c:if test="${currentPage < totalPages - 2}">
                            <c:if test="${currentPage < totalPages - 3}">
                                <a href="#" class="page-link disabled">…</a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/admin/order?action=list&page=${totalPages}&keyword=${keyword}&status_filter=${statusFilter}"
                               class="page-link">${totalPages}</a>
                        </c:if>

                            <%-- Nút Sau --%>
                        <c:choose>
                            <c:when test="${currentPage >= totalPages}">
                                <a href="#" class="page-link disabled">
                                    <i class="fa-solid fa-chevron-right"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/admin/order?action=list&page=${currentPage+1}&keyword=${keyword}&status_filter=${statusFilter}"
                                   class="page-link">
                                    <i class="fa-solid fa-chevron-right"></i>
                                </a>
                            </c:otherwise>
                        </c:choose>

                    </div>
                    <p class="pagination-info">
                        Trang ${currentPage} / ${totalPages} &nbsp;|&nbsp; Tổng ${totalRecords} đơn hàng
                    </p>
                </c:if>
                <%-- ===== /PHÂN TRANG ===== --%>

            </div>
        </div>
    </main>
</div>

</body>
</html>
