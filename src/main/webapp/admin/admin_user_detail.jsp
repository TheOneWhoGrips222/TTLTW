<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Khách hàng | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
    <style>
        /* === Layout === */
        .detail-layout {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 24px;
            align-items: start;
        }

        /* === Profile Card === */
        .profile-card {
            background: #fff;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            padding: 28px 24px;
            text-align: center;
        }
        .profile-avatar {
            width: 80px; height: 80px; border-radius: 50%;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 16px;
            font-size: 2rem; color: #fff; font-weight: 700;
        }
        .profile-name {
            font-size: 1.2rem; font-weight: 700; color: #1e293b; margin-bottom: 4px;
        }
        .profile-username {
            font-size: 0.9rem; color: #64748b; margin-bottom: 16px;
        }
        .profile-badge {
            display: inline-block; padding: 4px 14px; border-radius: 20px;
            font-size: 0.8rem; font-weight: 600; margin-bottom: 20px;
        }
        .badge-admin { background: #fee2e2; color: #dc2626; border: 1px solid #fecaca; }
        .badge-user  { background: #dcfce7; color: #16a34a; border: 1px solid #bbf7d0; }
        .badge-staff { background: #dbeafe; color: #1e40af; border: 1px solid #bfdbfe; }

        .profile-divider { border: none; border-top: 1px solid #f1f5f9; margin: 16px 0; }

        .profile-info-row {
            display: flex; align-items: flex-start; gap: 10px;
            text-align: left; margin-bottom: 12px; font-size: 0.9rem;
        }
        .profile-info-row i {
            width: 18px; color: #94a3b8; margin-top: 2px; flex-shrink: 0;
        }
        .profile-info-label { color: #94a3b8; font-size: 0.78rem; }
        .profile-info-value { color: #1e293b; font-weight: 500; }

        .profile-actions { display: flex; flex-direction: column; gap: 8px; margin-top: 20px; }
        .profile-actions a {
            display: flex; align-items: center; justify-content: center; gap: 8px;
            padding: 9px; border-radius: 8px; font-size: 0.88rem; font-weight: 600;
            text-decoration: none; transition: opacity .15s;
        }
        .profile-actions a:hover { opacity: .85; }
        .btn-edit-profile { background: #f1f5f9; color: #334155; }
        .btn-back-list    { background: #fff; color: #64748b; border: 1px solid #e2e8f0; }

        /* === Stats row === */
        .stats-row {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 20px;
        }
        .stat-card {
            background: #fff; border-radius: 12px; border: 1px solid #e2e8f0;
            padding: 18px 20px;
        }
        .stat-label { font-size: 0.8rem; color: #94a3b8; font-weight: 500; margin-bottom: 6px; }
        .stat-value { font-size: 1.45rem; font-weight: 700; color: #1e293b; }
        .stat-value.green  { color: #16a34a; }
        .stat-value.purple { color: #7c3aed; }

        /* === Section card === */
        .section-card {
            background: #fff; border-radius: 12px; border: 1px solid #e2e8f0;
            margin-bottom: 20px; overflow: hidden;
        }
        .section-header {
            padding: 16px 20px; border-bottom: 1px solid #f1f5f9;
            display: flex; align-items: center; justify-content: space-between;
        }
        .section-header h4 {
            font-size: 0.95rem; font-weight: 700; color: #1e293b; margin: 0;
            display: flex; align-items: center; gap: 8px;
        }
        .section-header h4 i { color: #6366f1; }
        .section-count {
            background: #f1f5f9; color: #64748b;
            font-size: 0.75rem; font-weight: 600;
            padding: 3px 10px; border-radius: 20px;
        }

        /* === Address list === */
        .address-list { padding: 16px 20px; }
        .address-item {
            border: 1px solid #e2e8f0; border-radius: 8px;
            padding: 14px 16px; margin-bottom: 10px; position: relative;
        }
        .address-item:last-child { margin-bottom: 0; }
        .address-default-badge {
            position: absolute; top: 10px; right: 12px;
            background: #dcfce7; color: #16a34a;
            font-size: 0.72rem; font-weight: 600; padding: 2px 8px; border-radius: 12px;
        }
        .address-receiver { font-weight: 600; color: #1e293b; margin-bottom: 4px; }
        .address-phone    { color: #64748b; font-size: 0.85rem; margin-bottom: 4px; }
        .address-full     { color: #475569; font-size: 0.88rem; }

        /* === Order table === */
        .order-table { width: 100%; border-collapse: collapse; }
        .order-table thead tr { background: #f8fafc; }
        .order-table th {
            padding: 10px 16px; text-align: left;
            font-size: 0.8rem; font-weight: 600; color: #64748b;
            border-bottom: 1px solid #e2e8f0;
        }
        .order-table td {
            padding: 12px 16px; font-size: 0.88rem; color: #334155;
            border-bottom: 1px solid #f1f5f9;
        }
        .order-table tbody tr:last-child td { border-bottom: none; }
        .order-table tbody tr:hover { background: #f8fafc; }

        .order-status {
            display: inline-block; padding: 3px 10px; border-radius: 12px;
            font-size: 0.75rem; font-weight: 600;
        }
        .status-HOAN_THANH    { background: #dcfce7; color: #16a34a; }
        .status-CHO_XAC_NHAN  { background: #fef9c3; color: #a16207; }
        .status-CHO_THANH_TOAN{ background: #fee2e2; color: #dc2626; }
        .status-VAN_CHUYEN    { background: #dbeafe; color: #1e40af; }
        .status-CHO_GIAO_HANG { background: #ede9fe; color: #6d28d9; }
        .status-DA_HUY        { background: #f1f5f9; color: #94a3b8; }

        .order-amount { font-weight: 600; color: #16a34a; }

        .empty-state {
            padding: 32px 20px; text-align: center; color: #94a3b8;
        }
        .empty-state i { font-size: 2rem; margin-bottom: 10px; display: block; }

        /* === Verified badge === */
        .verified-yes { color: #16a34a; }
        .verified-no  { color: #f59e0b; }

        @media (max-width: 900px) {
            .detail-layout { grid-template-columns: 1fr; }
            .stats-row { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"/>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
            <div class="admin-profile">
                <h3>Chi tiết Khách hàng</h3>
            </div>
        </header>

        <div class="admin-content">
            <div class="detail-layout">

                <%-- ===== CỘT TRÁI: Profile ===== --%>
                <div>
                    <div class="profile-card">
                        <div class="profile-avatar">
                            <i class="fa-solid fa-user"></i>
                        </div>
                        <div class="profile-name">${user.full_name}</div>
                        <div class="profile-username">@${user.username}</div>

                        <span class="profile-badge
                            ${user.role == 'ADMIN' ? 'badge-admin' :
                              user.role == 'STAFF' ? 'badge-staff' : 'badge-user'}">
                            ${user.role == 'ADMIN' ? 'Quản trị viên' :
                                    user.role == 'STAFF' ? 'Nhân viên' : 'Khách hàng'}
                        </span>

                        <hr class="profile-divider">

                        <div class="profile-info-row">
                            <i class="fa-regular fa-envelope"></i>
                            <div>
                                <div class="profile-info-label">Email</div>
                                <div class="profile-info-value">${user.email}</div>
                            </div>
                        </div>

                        <div class="profile-info-row">
                            <i class="fa-solid fa-phone"></i>
                            <div>
                                <div class="profile-info-label">Số điện thoại</div>
                                <div class="profile-info-value">
                                    <c:choose>
                                        <c:when test="${not empty user.phone}">${user.phone}</c:when>
                                        <c:otherwise><span style="color:#cbd5e1">Chưa cập nhật</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="profile-info-row">
                            <i class="fa-regular fa-calendar"></i>
                            <div>
                                <div class="profile-info-label">Ngày tạo tài khoản</div>
                                <div class="profile-info-value">${user.create_at}</div>
                            </div>
                        </div>

                        <div class="profile-info-row">
                            <i class="fa-solid fa-shield-check"></i>
                            <div>
                                <div class="profile-info-label">Trạng thái xác minh</div>
                                <div class="profile-info-value">
                                    <c:choose>
                                        <c:when test="${user.is_verified}">
                                            <span class="verified-yes"><i class="fa-solid fa-circle-check"></i> Đã xác minh</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="verified-no"><i class="fa-solid fa-circle-exclamation"></i> Chưa xác minh</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <hr class="profile-divider">

                        <div class="profile-actions">
                            <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${user.user_id}"
                               class="btn-edit-profile">
                                <i class="fa-solid fa-pen"></i> Chỉnh sửa tài khoản
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn-back-list">
                                <i class="fa-solid fa-list"></i> Về danh sách
                            </a>
                        </div>
                    </div>
                </div>

                <%-- ===== CỘT PHẢI: Thống kê + Địa chỉ + Đơn hàng ===== --%>
                <div>

                    <%-- Thống kê nhanh --%>
                    <div class="stats-row">
                        <div class="stat-card">
                            <div class="stat-label"><i class="fa-solid fa-bag-shopping"></i> Tổng đơn hàng</div>
                            <div class="stat-value">${orders.size()}</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label"><i class="fa-solid fa-check-circle"></i> Đơn hoàn thành</div>
                            <div class="stat-value green">${completedOrders}</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label"><i class="fa-solid fa-coins"></i> Tổng chi tiêu</div>
                            <div class="stat-value purple">
                                <fmt:formatNumber value="${totalSpent}" pattern="#,###" />đ
                            </div>
                        </div>
                    </div>

                    <%-- Địa chỉ --%>
                    <div class="section-card">
                        <div class="section-header">
                            <h4><i class="fa-solid fa-location-dot"></i> Địa chỉ giao hàng</h4>
                            <span class="section-count">${addresses.size()} địa chỉ</span>
                        </div>
                        <div class="address-list">
                            <c:choose>
                                <c:when test="${not empty addresses}">
                                    <c:forEach var="addr" items="${addresses}">
                                        <div class="address-item">
                                            <c:if test="${addr.is_default}">
                                                <span class="address-default-badge">
                                                    <i class="fa-solid fa-star"></i> Mặc định
                                                </span>
                                            </c:if>
                                            <div class="address-receiver">${addr.receiver_name}</div>
                                            <div class="address-phone"><i class="fa-solid fa-phone fa-xs"></i> ${addr.phone}</div>
                                            <div class="address-full">
                                                    ${addr.address_detail},
                                                    ${addr.ward},
                                                    ${addr.district},
                                                    ${addr.province}
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="fa-solid fa-location-dot"></i>
                                        Khách hàng chưa có địa chỉ nào.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <%-- Lịch sử đơn hàng --%>
                    <div class="section-card">
                        <div class="section-header">
                            <h4><i class="fa-solid fa-clock-rotate-left"></i> Lịch sử đơn hàng</h4>
                            <span class="section-count">${orders.size()} đơn</span>
                        </div>

                        <c:choose>
                            <c:when test="${not empty orders}">
                                <table class="order-table">
                                    <thead>
                                    <tr>
                                        <th>Mã đơn</th>
                                        <th>Ngày đặt</th>
                                        <th>Thanh toán</th>
                                        <th>Trạng thái</th>
                                        <th class="text-right">Tổng tiền</th>
                                        <th class="text-right">Chi tiết</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="o" items="${orders}">
                                        <tr>
                                            <td><strong>#${o.order_id}</strong></td>
                                            <td style="color:#64748b; font-size:0.83rem;">${o.created_at}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${o.payment_method == 'COD'}">
                                                        <i class="fa-solid fa-money-bill" style="color:#f59e0b"></i> COD
                                                    </c:when>
                                                    <c:when test="${o.payment_method == 'VNPAY'}">
                                                        <i class="fa-solid fa-credit-card" style="color:#6366f1"></i> VNPay
                                                    </c:when>
                                                    <c:otherwise>${o.payment_method}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="order-status status-${o.status}">
                                                        ${o.statusText}
                                                </span>
                                            </td>
                                            <td class="text-right order-amount">
                                                <fmt:formatNumber value="${o.total_amount}" pattern="#,###" />đ
                                            </td>
                                            <td class="text-right">
                                                <a href="${pageContext.request.contextPath}/admin/order?action=detail&id=${o.order_id}"
                                                   class="btn-action edit" title="Xem đơn hàng">
                                                    <i class="fa-solid fa-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fa-solid fa-bag-shopping"></i>
                                    Khách hàng chưa có đơn hàng nào.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
