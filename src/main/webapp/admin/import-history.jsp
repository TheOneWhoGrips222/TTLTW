<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Lịch sử nhập hàng | Admin</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
  <style>
    .import-stats{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:24px}
    .import-stat-card{background:#fff;border-radius:12px;padding:18px 22px;display:flex;align-items:center;gap:14px;box-shadow:0 1px 4px rgba(0,0,0,.06);border:1px solid #f0f0f0}
    .import-stat-card .icon{width:44px;height:44px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:1.3rem;flex-shrink:0}
    .icon-purple{background:#f5f3ff;color:#7c3aed}
    .icon-green{background:#ecfdf5;color:#059669}
    .icon-blue{background:#eff6ff;color:#2563eb}
    .import-stat-card .info p{margin:0;font-size:.8rem;color:#6b7280}
    .import-stat-card .info h3{margin:4px 0 0;font-size:1.45rem;font-weight:700;color:#111827}

    .product-cell{display:flex;align-items:center;gap:10px}
    .product-cell img{width:40px;height:40px;object-fit:cover;border-radius:8px;border:1px solid #f0f0f0;flex-shrink:0}
    .product-cell .pname{font-weight:600;font-size:.87rem;color:#111827}

    .badge-supplier{display:inline-block;padding:3px 9px;border-radius:12px;background:#f0fdf4;color:#16a34a;font-size:.78rem;font-weight:600}
    .no-supplier{color:#9ca3af;font-style:italic;font-size:.82rem}

    .pagination{display:flex;gap:6px;justify-content:center;margin-top:20px}
    .page-btn{padding:6px 13px;border-radius:8px;border:1px solid #e5e7eb;background:#fff;cursor:pointer;font-size:.85rem;color:#374151;text-decoration:none;display:inline-block}
    .page-btn.active{background:#4f46e5;color:#fff;border-color:#4f46e5;font-weight:600}
    .page-btn:hover:not(.active){background:#f3f4f6}

    .filter-bar{display:flex;align-items:center;gap:10px;flex-wrap:wrap;margin-bottom:16px}
    .filter-bar input{padding:7px 12px;border:1px solid #d1d5db;border-radius:8px;font-size:.875rem;width:260px}
    .filter-bar .btn-filter{padding:7px 16px;border-radius:8px;border:none;background:#4f46e5;color:#fff;cursor:pointer;font-size:.875rem;font-weight:600}

    .cost-cell{font-weight:600;color:#059669}
    .qty-cell{font-weight:700;color:#4f46e5;font-size:.95rem}
  </style>
</head>
<body>
<div class="admin-layout">
  <jsp:include page="common/sidebar.jsp"/>
  <main class="admin-main">
    <header class="admin-header">
      <div class="header-left">
        <h2><i class="fa-solid fa-clock-rotate-left" style="color:#7c3aed;margin-right:8px;"></i>Lịch sử nhập hàng</h2>
      </div>
      <div class="admin-header-actions">
        <a href="${pageContext.request.contextPath}/admin/restock-suggestion" class="btn-secondary">
          <i class="fa-solid fa-boxes-stacked"></i> Đề xuất nhập hàng
        </a>
      </div>
    </header>

    <div class="admin-content">


      <c:if test="${not empty filterProductId}">
        <div style="background:#eff6ff;border:1px solid #bfdbfe;border-radius:10px;padding:12px 18px;margin-bottom:16px;font-size:.875rem;color:#1e40af;">
          <i class="fa-solid fa-filter"></i>
          Đang hiển thị lịch sử nhập hàng cho sản phẩm ID <strong>${filterProductId}</strong>.
          <a href="${pageContext.request.contextPath}/admin/import-history" style="margin-left:10px;color:#4f46e5;font-weight:600;">Xem tất cả</a>
        </div>
      </c:if>


      <c:if test="${empty filterProductId}">
        <div class="import-stats">
          <div class="import-stat-card">
            <div class="icon icon-purple"><i class="fa-solid fa-truck-ramp-box"></i></div>
            <div class="info"><p>Tổng lần nhập</p><h3>${totalRecords}</h3></div>
          </div>
          <div class="import-stat-card">
            <div class="icon icon-green"><i class="fa-solid fa-boxes-stacked"></i></div>
            <div class="info"><p>Trang hiện tại</p><h3>${currentPage} / ${totalPages}</h3></div>
          </div>
          <div class="import-stat-card">
            <div class="icon icon-blue"><i class="fa-solid fa-calendar-days"></i></div>
            <div class="info"><p>Hiển thị mỗi trang</p><h3>20 bản ghi</h3></div>
          </div>
        </div>
      </c:if>

      <div class="admin-card">
        <div class="filter-bar">
          <form method="get" action="${pageContext.request.contextPath}/admin/import-history" style="display:flex;gap:10px;align-items:center;">
            <input type="number" name="productId" placeholder="Lọc theo ID sản phẩm..."
                   value="${filterProductId}" min="1">
            <button type="submit" class="btn-filter"><i class="fa-solid fa-magnifying-glass"></i> Lọc</button>
            <c:if test="${not empty filterProductId}">
              <a href="${pageContext.request.contextPath}/admin/import-history" class="btn-secondary">
                <i class="fa-solid fa-xmark"></i> Xóa lọc
              </a>
            </c:if>
          </form>
        </div>

        <table class="admin-table" id="importTable">
          <thead>
          <tr>
            <th width="5%"  style="text-align:center;">#</th>
            <th width="28%">Sản phẩm</th>
            <th width="11%" style="text-align:center;">Số lượng</th>
            <th width="14%" style="text-align:center;">Đơn giá</th>
            <th width="14%" style="text-align:center;">Thành tiền</th>
            <th width="15%">Nhà cung cấp</th>
            <th width="8%">Người nhập</th>
            <th width="13%" style="text-align:center;">Thời gian</th>
          </tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty historyList}">
              <tr>
                <td colspan="8" style="text-align:center;padding:40px;color:#9ca3af;">
                  <i class="fa-solid fa-inbox" style="font-size:2rem;margin-bottom:10px;display:block;"></i>
                  Chưa có lịch sử nhập hàng nào.
                </td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="ih" items="${historyList}" varStatus="st">
                <tr>
                  <td style="text-align:center;color:#9ca3af;font-size:.8rem;">${ih.importId}</td>
                  <td>
                    <div class="product-cell">
                      <c:choose>
                        <c:when test="${empty ih.productImage}">
                          <img src="https://placehold.co/40x40?text=SP" alt="">
                        </c:when>
                        <c:when test="${ih.productImage.startsWith('http://') or ih.productImage.startsWith('https://')}">
                          <img src="${ih.productImage}" onerror="this.src='https://placehold.co/40x40?text=SP'" alt="">
                        </c:when>
                        <c:otherwise>
                          <img src="${pageContext.request.contextPath}/${ih.productImage}" onerror="this.src='https://placehold.co/40x40?text=SP'" alt="">
                        </c:otherwise>
                      </c:choose>
                      <div>
                        <div class="pname">${ih.productName}</div>
                        <div style="font-size:.76rem;color:#9ca3af;">ID: ${ih.productId}</div>
                      </div>
                    </div>
                  </td>
                  <td style="text-align:center;"><span class="qty-cell">+${ih.quantity}</span></td>
                  <td style="text-align:center;">
                    <c:choose>
                      <c:when test="${ih.unitPrice != null}">
                        <fmt:formatNumber value="${ih.unitPrice}" type="number" groupingUsed="true"/>đ
                      </c:when>
                      <c:otherwise><span style="color:#9ca3af;">—</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td style="text-align:center;">
                    <c:choose>
                      <c:when test="${ih.totalCost != null and ih.totalCost > 0}">
                        <span class="cost-cell"><fmt:formatNumber value="${ih.totalCost}" type="number" groupingUsed="true"/>đ</span>
                      </c:when>
                      <c:otherwise><span style="color:#9ca3af;">—</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty ih.supplierName}">
                        <span class="badge-supplier"><i class="fa-solid fa-building"></i> ${ih.supplierName}</span>
                      </c:when>
                      <c:otherwise><span class="no-supplier">Chưa xác định</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td style="font-size:.82rem;">
                    <c:choose>
                      <c:when test="${not empty ih.importedByName}">${ih.importedByName}</c:when>
                      <c:otherwise><span style="color:#9ca3af;">—</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td style="text-align:center;font-size:.82rem;color:#6b7280;">
                    <c:if test="${ih.importedAt != null}">

                      <c:set var="dtStr" value="${ih.importedAt}"/>
                      <c:set var="datePart" value="${fn:substring(dtStr, 0, 10)}"/>
                      <c:set var="timePart" value="${fn:substring(dtStr, 11, 16)}"/>
                      <c:set var="y"  value="${fn:substring(datePart,0,4)}"/>
                      <c:set var="mo" value="${fn:substring(datePart,5,7)}"/>
                      <c:set var="d"  value="${fn:substring(datePart,8,10)}"/>
                      ${d}/${mo}/${y} ${timePart}
                    </c:if>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>


        <c:if test="${totalPages > 1}">
          <div class="pagination">
            <c:if test="${currentPage > 1}">
              <a class="page-btn" href="?page=${currentPage - 1}"><i class="fa-solid fa-chevron-left"></i></a>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="pg">
              <c:choose>
                <c:when test="${pg == currentPage}">
                  <span class="page-btn active">${pg}</span>
                </c:when>
                <c:otherwise>
                  <a class="page-btn" href="?page=${pg}">${pg}</a>
                </c:otherwise>
              </c:choose>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
              <a class="page-btn" href="?page=${currentPage + 1}"><i class="fa-solid fa-chevron-right"></i></a>
            </c:if>
          </div>
        </c:if>

      </div>
    </div>
  </main>
</div>
</body>
</html>
