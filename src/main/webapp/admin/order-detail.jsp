<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng #${order.order_id} | Admin</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">

    <style>
        /* CSS bổ sung riêng cho trang này để đẹp hơn */
        .card-header {
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 15px;
            margin-bottom: 20px;
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--admin-text);
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 0.95rem;
        }
        .info-label { color: var(--admin-text-light); }
        .info-value { font-weight: 600; color: var(--admin-text); text-align: right; }
    </style>
</head>
<body>

<div class="admin-layout">

    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/admin/order" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                </a>
                <h2 style="margin-left: 15px;">Đơn hàng #${order.order_id}</h2>

                <div style="margin-left: 15px;">
                    <c:choose>
                        <c:when test="${order.status == 'CHO_XAC_NHAN'}"><span class="status processing">Chờ xác nhận</span></c:when>
                        <c:when test="${order.status == 'VAN_CHUYEN' || order.status == 'CHO_GIAO_HANG'}"><span class="status processing" style="background-color: #e0f7fa; color: #006064;">Đang vận chuyển</span></c:when>
                        <c:when test="${order.status == 'HOAN_THANH'}"><span class="status completed">Hoàn thành</span></c:when>
                        <c:when test="${order.status == 'DA_HUY'}"><span class="status cancelled">Đã hủy</span></c:when>
                        <c:otherwise><span class="status">${order.status}</span></c:otherwise>
                    </c:choose>
                </div>
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
                    <i class="fa-solid fa-exclamation-triangle"></i> Có lỗi xảy ra!
                </div>
            </c:if>

            <div class="order-layout">
                <div class="left-column">
                    <div class="admin-card">
                        <div class="card-header">Danh sách sản phẩm</div>

                        <table class="admin-table order-table">
                            <thead>
                            <tr>
                                <th width="50%">Sản phẩm</th>
                                <th width="15%" class="text-right">Đơn giá</th>
                                <th width="15%" class="text-right">Số lượng</th>
                                <th width="20%" class="text-right">Thành tiền</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${items}">
                                <tr>
                                    <td>
                                        <div class="product-cell">
                                            <img src="${not empty item.productImage ? item.productImage : 'https://placehold.co/50x50'}"
                                                 alt="${item.productName}"
                                                 onerror="this.src='https://via.placeholder.com/50'">
                                            <div>
                                                <div class="p-name">${item.productName}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-right">
                                        <fmt:setLocale value="vi_VN"/>
                                        <fmt:formatNumber value="${item.price_at_purchase}" type="currency"/>
                                    </td>
                                    <td class="text-right">x${item.quantity}</td>
                                    <td class="text-right text-bold">
                                        <fmt:formatNumber value="${item.price_at_purchase * item.quantity}" type="currency"/>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                            <tfoot>
                            <tr>
                                <td colspan="3" class="text-right info-label">Tạm tính:</td>
                                <td class="text-right text-bold">
                                    <fmt:formatNumber value="${order.total_amount}" type="currency"/>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" class="text-right info-label">Phí vận chuyển:</td>
                                <td class="text-right">Miễn phí</td>
                            </tr>
                            <tr style="background-color: #f8fafc;">
                                <td colspan="3" class="text-right text-bold" style="font-size: 1.1rem;">Tổng cộng:</td>
                                <td class="text-right total-price">
                                    <fmt:formatNumber value="${order.total_amount}" type="currency"/>
                                </td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>

                    <c:if test="${not empty order.note}">
                        <div class="admin-card" style="margin-top: 20px;">
                            <div class="card-header">Ghi chú từ khách hàng</div>
                            <p style="color: var(--admin-text-light); font-style: italic;">
                                "${order.note}"
                            </p>
                        </div>
                    </c:if>
                </div>

                <div class="right-column admin-grid" style="gap: 20px; display: flex; flex-direction: column;">

                    <div class="admin-card">
                        <div class="card-header">Cập nhật trạng thái</div>
                        <form action="${pageContext.request.contextPath}/admin/order" method="post">
                            <input type="hidden" name="action" value="update_status">
                            <input type="hidden" name="order_id" value="${order.order_id}">

                            <div class="form-group">
                                <label style="font-size: 0.9rem; color: var(--admin-text-light);">Trạng thái hiện tại:</label>
                                <select name="status" class="form-control">
                                    <option value="CHO_XAC_NHAN" ${order.status == 'CHO_XAC_NHAN' ? 'selected' : ''}>Chờ xác nhận</option>
                                    <option value="VAN_CHUYEN" ${order.status == 'VAN_CHUYEN' ? 'selected' : ''}>Đang vận chuyển</option>
                                    <option value="CHO_GIAO_HANG" ${order.status == 'CHO_GIAO_HANG' ? 'selected' : ''}>Chờ giao hàng</option>
                                    <option value="HOAN_THANH" ${order.status == 'HOAN_THANH' ? 'selected' : ''}>Hoàn thành</option>
                                    <option value="DA_HUY" ${order.status == 'DA_HUY' ? 'selected' : ''}>Đã hủy</option>
                                </select>
                            </div>

                            <button type="submit" class="btn-primary" style="width: 100%; margin-top: 10px; justify-content: center;">
                                <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
                            </button>
                        </form>
                    </div>

                    <div class="admin-card">
                        <div class="card-header">Thông tin khách hàng</div>
                        <div class="customer-info">
                            <div class="avatar-circle">
                                ${not empty order.userName ? order.userName.charAt(0) : 'U'}
                            </div>
                            <div>
                                <div class="name">${order.userName}</div>
                                <div class="email">Mã TK: #${order.user_id}</div>
                            </div>
                        </div>
                        <div class="divider"></div>

                        <div style="margin-top: 15px;">
                            <div class="info-label" style="margin-bottom: 5px;">Địa chỉ giao hàng:</div>
                            <div class="address-text">
                                <i class="fa-solid fa-location-dot" style="color: var(--red); margin-right: 5px;"></i>
                                ${not empty order.addressDetail ? order.addressDetail : 'Khách chưa nhập địa chỉ'}
                            </div>
                        </div>
                    </div>

                    <div class="admin-card">
                        <div class="card-header">Thanh toán & Thời gian</div>

                        <div class="info-row">
                            <span class="info-label">Phương thức:</span>
                            <span class="info-value">
                                ${order.payment_method == 'COD' ? 'Thanh toán khi nhận (COD)' : 'Chuyển khoản ngân hàng'}
                            </span>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Ngày đặt hàng:</span>
                            <span class="info-value">
                                ${order.created_at.toLocalDate()}
                            </span>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Giờ đặt:</span>
                            <span class="info-value">
                                ${order.created_at.toLocalTime()}
                            </span>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>