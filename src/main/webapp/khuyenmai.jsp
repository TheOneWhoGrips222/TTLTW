<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <title>Săn Mã Giảm Giá - Bếp Thông Minh TTB</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="assets/css/index.css" />
    <link rel="stylesheet" href="assets/css/indexfont.css" />
    <link rel="stylesheet" href="assets/css/Header.css" />
    <link rel="stylesheet" href="assets/css/main.css" />
    <link rel="stylesheet" href="assets/css/khuyenmai.css">
</head>

<body>
<jsp:include page="common/header.jsp"/>

<main class="main-content">
    <section class="promo-hero">
        <div class="container">
            <h1 class="section-title">
                <i class="fa-solid fa-ticket" style="color: #007bff; margin-right: 10px;"></i> Trạm Săn Voucher
            </h1>
            <p class="promo-intro">
                Nhấn lấy các mã giảm giá siêu hấp dẫn từ Bếp Thông Minh TTB để lưu ưu đãi vào ví của bạn ngay!
            </p>
        </div>
    </section>

    <section class="promo-list">
        <div class="container">
            <div class="voucher-grid">

                <c:forEach var="v" items="${listV}">
                    <c:if test="${v.status == 1 && !v.expired && v.quantity > 0}">
                        <article class="voucher-card">
                            <div class="voucher-left">
                                <div class="voucher-value">${v.discountFormat}</div>
                                <div class="voucher-type">${v.discountType}</div>
                            </div>
                            <div class="voucher-border-line"></div>
                            <div class="voucher-right">
                                <div class="voucher-info">
                                    <span class="voucher-code-tag">Mã: ${v.code}</span>
                                    <h3 class="voucher-title">Giảm ngay ${v.discountFormat} </h3>
                                    <p class="voucher-desc">${v.description}</p>
                                    <p class="voucher-condition">
                                        <i class="fa-solid fa-circle-info"></i> Đơn tối thiểu: ${v.minvalueFormat}
                                    </p>
                                </div>
                                <div class="voucher-action">
                                    <c:if test="${v.collection == true}">
                                        <button type="button" class="btn-get-voucher success" disabled>
                                            Đã lấy
                                        </button>
                                    </c:if>

                                    <c:if test="${v.collection == false || empty v.collection}">
                                        <button type="button" class="btn-get-voucher" onclick="collectVoucher('${v.id}', this)">
                                            Lấy mã
                                        </button>
                                    </c:if>
                                    <div class="voucher-expiry">Hạn dùng: ${v.dateFormat}</div>
                                </div>
                            </div>
                        </article>
                    </c:if>
                </c:forEach>

            </div>

            <c:if test="${nextLastId > 0}">
                <div class="see-more-container">
                    <a href="list-voucher?lastId=${nextLastId}" class="btn-see-more" style="text-decoration: none; display: inline-block;">Xem thêm »</a>
                </div>
            </c:if>

        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp"/>

<script>
    function collectVoucher(voucherId, buttonElement) {
        const originalText = buttonElement.innerText;

        buttonElement.innerText = "Đang xử lý...";
        buttonElement.disabled = true;

        fetch("getVoucher", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "id=" + encodeURIComponent(voucherId)
        })
            .then(response => {
                if (response.redirected) {
                    buttonElement.innerText = originalText;
                    buttonElement.disabled = false;


                    window.location.href = response.url;
                    return;
                }


                buttonElement.innerText = "Đã lấy";
                buttonElement.classList.add("success");
                buttonElement.disabled = true;
            })
            .catch(error => {
                buttonElement.innerText = originalText;
                buttonElement.disabled = false;
                console.error("Lỗi hệ thống:", error);
            });
    }
</script>

</body>
</html>