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

        .btn-print {
            padding: 10px 15px;
            background-color: #fff;
            border: 1px solid #cbd5e1;
            color: var(--admin-text);
            border-radius: 5px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }
        .btn-print:hover { background-color: #f1f5f9; }

        /* ====== PHIẾU IN VẬN ĐƠN ====== */
        #print-area { display: none; }

        @media print {
            body * { visibility: hidden; }
            #print-area, #print-area * { visibility: visible; }
            #print-area {
                display: block;
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
            }

            .shipping-label {
                width: 100%;
                max-width: 480px;
                margin: 0 auto;
                padding: 16px;
                border: 2px solid #000;
                font-family: Arial, sans-serif;
                color: #000;
            }
            .shipping-label .label-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 2px dashed #000;
                padding-bottom: 10px;
                margin-bottom: 10px;
            }
            .shipping-label .label-header h2 {
                margin: 0;
                font-size: 18px;
            }
            .shipping-label .order-code {
                font-size: 16px;
                font-weight: bold;
            }
            .shipping-label .section {
                margin-bottom: 10px;
                padding-bottom: 8px;
                border-bottom: 1px dashed #999;
            }
            .shipping-label .section:last-child { border-bottom: none; }
            .shipping-label .section-title {
                font-size: 11px;
                text-transform: uppercase;
                color: #555;
                margin-bottom: 4px;
                letter-spacing: 0.5px;
            }
            .shipping-label .name-line {
                font-size: 16px;
                font-weight: bold;
            }
            .shipping-label .phone-line {
                font-size: 14px;
                font-weight: bold;
            }
            .shipping-label .address-line {
                font-size: 13px;
            }
            .shipping-label table.print-items {
                width: 100%;
                border-collapse: collapse;
                font-size: 12px;
                margin-top: 4px;
            }
            .shipping-label table.print-items th,
            .shipping-label table.print-items td {
                border: 1px solid #999;
                padding: 4px 6px;
                text-align: left;
            }
            .shipping-label table.print-items th:last-child,
            .shipping-label table.print-items td:last-child {
                text-align: right;
            }
            .shipping-label .cod-box {
                margin-top: 10px;
                text-align: center;
                border: 2px solid #000;
                padding: 8px;
                font-size: 18px;
                font-weight: bold;
            }
            .shipping-label .note-line {
                font-size: 12px;
                font-style: italic;
            }
        }
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

            <button type="button" class="btn-print" onclick="window.print()">
                <i class="fa-solid fa-print"></i> In thông tin đơn hàng
            </button>
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

                                    <c:if test="${order.status == 'CHO_XAC_NHAN'}">
                                        <option value="CHO_XAC_NHAN" selected>
                                            Chờ xác nhận
                                        </option>

                                        <option value="VAN_CHUYEN">
                                            Xác nhận giao hàng
                                        </option>

                                        <option value="DA_HUY">
                                            Hủy đơn
                                        </option>
                                    </c:if>

                                    <c:if test="${order.status == 'VAN_CHUYEN'
                                             || order.status == 'CHO_GIAO_HANG'
                                             || order.status == 'HOAN_THANH'
                                             || order.status == 'DA_HUY'}">

                                        <option selected>
                                                ${order.statusText}
                                        </option>

                                    </c:if>

                                </select>
                            </div>

                            <button type="submit" class="btn-primary" style="width: 100%; margin-top: 10px; justify-content: center;"
                                    <c:if test="${order.status != 'CHO_XAC_NHAN'}">
                                        disabled
                                    </c:if>
                            >
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
                            <span class="info-label">Trạng thái thanh toán:</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${order.payment_status == 'PAID'}">
                                        <span class="status completed">Đã thanh toán</span>
                                    </c:when>
                                    <c:when test="${order.payment_status == 'FAILED'}">
                                        <span class="status cancelled">Thanh toán thất bại</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status processing">Chưa thanh toán</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <c:if test="${order.payment_status == 'PAID' and not empty order.payment_time}">
                            <div class="info-row">
                                <span class="info-label">Thời gian thanh toán:</span>
                                <span class="info-value">${order.payment_time}</span>
                            </div>
                        </c:if>
                        <div class="info-row">
                            <span class="info-label">Voucher:</span>
                            <span class="info-value" style="display: flex; gap: 4px; flex-wrap: wrap; justify-content: flex-end; align-items: center;">
                                <c:choose>
                                    <c:when test="${not empty orderVouchers}">
                                        <c:forEach var="v" items="${orderVouchers}" varStatus="status">
                                            <span style="font-weight: 600; color: #333;">#${v.id}</span>
                                            <span style="color: var(--red); font-weight: bold; background: #fff5f5; padding: 2px 6px; border: 1px solid #ffe3e3; border-radius: 4px; font-size: 12px; letter-spacing: 0.5px;">${v.code}</span>
                                            <c:if test="${not status.last}">
                                                <span style="margin: 0 4px; color: #ccc;">,</span>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: var(--admin-text-light); font-style: italic;">None</span>
                                    </c:otherwise>
                                </c:choose>
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

        <div id="print-area">
            <div class="shipping-label">
                <div class="label-header">
                    <h2>PHIẾU GIAO HÀNG</h2>
                    <div class="order-code">Đơn #${order.order_id}</div>
                </div>

                <div class="section">
                    <div class="section-title">Người gửi</div>
                    <div class="name-line">WEB THIET BI BEP</div>
                    <div class="phone-line">SĐT: 0353334530</div>
                    <div class="address-line">Tân Định, Quận 1, Hồ Chí Minh</div>
                </div>

                <div class="section">
                    <div class="section-title">Người nhận</div>
                    <div class="name-line">${not empty order.receiverName ? order.receiverName : order.userName}</div>
                    <div class="phone-line">
                        <c:if test="${not empty order.receiverPhone}">SĐT: ${order.receiverPhone}</c:if>
                    </div>
                    <div class="address-line">
                        ${not empty order.addressDetail ? order.addressDetail : 'Khách chưa nhập địa chỉ'}
                    </div>
                </div>

                <div class="section">
                    <div class="section-title">Sản phẩm</div>
                    <table class="print-items">
                        <thead>
                        <tr>
                            <th>Tên sản phẩm</th>
                            <th>SL</th>
                            <th>Thành tiền</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${items}">
                            <tr>
                                <td>${item.productName}</td>
                                <td>${item.quantity}</td>
                                <td>
                                    <fmt:setLocale value="vi_VN"/>
                                    <fmt:formatNumber value="${item.price_at_purchase * item.quantity}" type="currency"/>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="section">
                    <div class="section-title">Thanh toán</div>
                    <div class="address-line">
                        Phương thức:
                        ${order.payment_method == 'COD' ? 'Thanh toán khi nhận (COD)' : 'Đã chuyển khoản'}
                    </div>
                    <div class="address-line">
                        Trạng thái:
                        <b>${order.payment_status == 'PAID' ? 'Đã thanh toán' : 'Chưa thanh toán'}</b>
                    </div>
                    <c:if test="${not empty order.ghn_order_code}">
                        <div class="address-line">Mã vận đơn GHN: ${order.ghn_order_code}</div>
                    </c:if>
                    <div class="address-line">
                        Ngày đặt: ${order.created_at.toLocalDate()}
                    </div>
                </div>

                <c:if test="${order.payment_method == 'COD'}">
                    <div class="cod-box">
                        Thu tiền COD:
                        <fmt:formatNumber value="${order.payment_status == 'PAID' ? 0 : order.total_amount}" type="currency"/>
                    </div>
                </c:if>

                <c:if test="${not empty order.note}">
                    <div class="section" style="margin-top: 10px;">
                        <div class="section-title">Ghi chú</div>
                        <div class="note-line">"${order.note}"</div>
                    </div>
                </c:if>
            </div>
        </div>

    </main>
</div>

</body>
</html>