<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Combo | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
</head>
<body>

<div class="admin-layout">
    <jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <h2>Quản lý Combo</h2>
            </div>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/combos?action=new" class="btn-primary">
                    <i class="fa-solid fa-plus"></i> Thêm Combo mới
                </a>
            </div>
        </header>

        <div class="admin-content">

            <c:if test="${not empty sessionScope.msg}">
                <div style="background-color: #dcfce7; color: #16a34a; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: 600;">
                    <i class="fa-solid fa-check-circle"></i> ${sessionScope.msg}
                    <% session.removeAttribute("msg"); %>
                </div>
            </c:if>

            <div class="admin-filters">
                <input type="text" placeholder="Tìm kiếm tên combo...">
                <select>
                    <option value="">Tất cả trạng thái</option>
                    <option value="1">Đang hiển thị</option>
                    <option value="0">Đã ẩn</option>
                </select>
                <button class="btn-filter"><i class="fa-solid fa-filter"></i> Lọc</button>
            </div>

            <div class="admin-card">
                <h3>Danh sách Combo hiện có</h3>
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th width="5%">ID</th>
                        <th width="10%">Hình ảnh</th>
                        <th width="30%">Tên Combo</th>
                        <th width="15%">Giá gốc</th>
                        <th width="15%">Giá KM</th>
                        <th width="10%">Kho</th>
                        <th width="10%">Trạng thái</th>
                        <th width="5%" class="text-right">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${listCombos}" var="c">
                        <tr>
                            <td>#${c.id}</td>
                            <td>
                                <img src="${c.image}" class="product-thumbnail"
                                     onerror="this.src='https://via.placeholder.com/60?text=No+Img'">
                            </td>
                            <td>
                                <div style="font-weight: 600; font-size: 0.95rem;">${c.name}</div>
                                <div style="color: var(--admin-text-light); font-size: 0.85rem; margin-top: 4px;">
                                    Tag: <span style="background: #e2e8f0; padding: 2px 6px; border-radius: 4px; font-size: 0.75rem;">${c.tag}</span>
                                </div>
                            </td>
                            <td style="color: var(--admin-text-light); text-decoration: line-through;">
                                <fmt:formatNumber value="${c.baseprice}" pattern="#,###"/> đ
                            </td>
                            <td style="color: var(--red); font-weight: 700;">
                                <fmt:formatNumber value="${c.discountprice}" pattern="#,###"/> đ
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.stock_quantity == 0}">
                                        <span style="color: var(--red); font-weight: 600;">Hết hàng</span>
                                    </c:when>
                                    <c:when test="${c.stock_quantity < 10}">
                                        <span style="color: var(--yellow); font-weight: 600;">${c.stock_quantity}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: var(--admin-text);">${c.stock_quantity}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.is_active == 1}">
                                        <span class="status status-published">Hiển thị</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status status-draft">Đã ẩn</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-right" style="white-space: nowrap;">
                                <a href="${pageContext.request.contextPath}/admin/combos?action=edit&id=${c.id}"
                                   class="btn-action edit" title="Sửa">
                                    <i class="fa-solid fa-pen"></i>
                                </a>
                                <a href="#" onclick="alert('Chức năng xóa tạm khóa')"
                                   class="btn-action delete" title="Xóa">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <div class="admin-pagination">
                    <a href="#" class="page-link"><i class="fa-solid fa-chevron-left"></i></a>
                    <a href="#" class="page-link active">1</a>
                    <a href="#" class="page-link">2</a>
                    <a href="#" class="page-link">3</a>
                    <a href="#" class="page-link"><i class="fa-solid fa-chevron-right"></i></a>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>