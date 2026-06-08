<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chọn Mã Giảm Giá</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/select-voucher.css">
</head>
<body>

<jsp:include page="common/header.jsp"/>

<main>
    <form action="${pageContext.request.contextPath}/select-voucher" method="POST">
        <div class="voucher-page-container">
            <div class="voucher-header">
                <button type="button" class="btn-back" onclick="window.location.href='checkout.jsp'">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                </button>
                <h2>Chọn Mã Giảm Giá</h2>
            </div>

            <div class="voucher-list-title">Mã Miễn Phí Vận Chuyển</div>

            <div class="voucher-list">
                <c:forEach items="${listV}" var="v">
                    <c:if test="${v.discountType == 'freeship'}">
                        <label class="voucher-card ${v.validVoucher ? 'eligible' : 'ineligible'}">
                            <div class="v-left">
                                <div class="v-icon-box ${v.validVoucher ? 'freeship' : 'disabled'}">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                                </div>
                                <span>Free Ship</span>
                            </div>
                            <div class="v-right">
                                <div class="v-info">
                                    <h4>Giảm ${v.discountFormat}</h4>
                                    <p>${v.title}</p>
                                    <p>Đơn Tối Thiểu ${v.minvalueFormat}</p>
                                    <c:if test="${!v.validVoucher}">
                                        <small style="color: red; display: block;">Chưa đạt giá trị đơn hàng tối thiểu</small>
                                    </c:if>
                                    <small>
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 5px;"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                        Ngày hết hạn: ${v.dateFormat}
                                    </small>
                                </div>
                                <input type="radio" name="idF" value="${v.id}" ${v.validVoucher ? '' : 'disabled'} style="width: 20px; height: 20px;">
                            </div>
                        </label>
                    </c:if>
                </c:forEach>

                <div class="voucher-list-title" style="padding-left: 0; padding-top: 10px;">Mã Giảm Giá </div>

                <c:forEach items="${listV}" var="v">
                    <c:if test="${v.discountType != 'freeship'}">
                        <label class="voucher-card ${v.validVoucher ? 'eligible' : 'ineligible'}">
                            <div class="v-left">
                                <div class="v-icon-box ${v.validVoucher ? 'discount' : 'disabled'}">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path><line x1="7" y1="7" x2="7.01" y2="7"></line></svg>
                                </div>
                                <span>Giảm giá</span>
                            </div>
                            <div class="v-right">
                                <div class="v-info">
                                    <h4>Giảm ${v.discountFormat}</h4>
                                    <p>${v.title}</p>
                                    <p>Đơn Tối Thiểu ${v.minvalueFormat} </p>
                                    <c:if test="${!v.validVoucher}">
                                        <small style="color: red; display: block;">Chưa đạt giá trị đơn hàng tối thiểu</small>
                                    </c:if>
                                    <small>
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 5px;"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                        Ngày hết hạn: ${v.dateFormat}
                                    </small>
                                </div>
                                <input type="radio" name="discount" value="${v.id}" ${v.validVoucher ? '' : 'disabled'} style="width: 20px; height: 20px;">
                            </div>
                        </label>
                    </c:if>
                </c:forEach>
            </div>

            <div class="voucher-footer">
                <button type="submit" class="btn-ok">ĐỒNG Ý</button>
            </div>
        </div>
    </form>
</main>

<jsp:include page="common/footer.jsp"/>

</body>
</html>