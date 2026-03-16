<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <title>Khuyến mãi - Bếp Thông Minh TTB</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="assets/css/index.css" />
    <link rel="stylesheet" href="assets/css/indexfont.css" />
    <link rel="stylesheet" href="assets/css/Header.css" />
    <link rel="stylesheet" href="assets/css/main.css" />
    <link rel="stylesheet" href="assets/css/khuyenmai.css">
    <script src="../../js/jsBao/Main.js"></script>
</head>

<body>
<jsp:include page="common/header.jsp"/>

<main class="main-content">
    <section class="promo-hero section-padding bg-light">
        <div class="container">
            <h1 class="section-title">Chương trình Khuyến mãi</h1>
            <p class="promo-intro">
                Đừng bỏ lỡ các ưu đãi hấp dẫn nhất từ Bếp Thông Minh TTB để nâng tầm căn bếp của bạn!
            </p>
        </div>
    </section>

    <section class="promo-list section-padding">
        <div class="container">
            <div class="promo-grid">
            <c:forEach var = "p" items="${listP}">
                <article class="promo-card">
                    <div class="promo-image">
                        <img src="https://placehold.co/600x400/C79F27/fff?text=${p.name_promotion}" alt="">
                    </div>
                    <div class="promo-content">
                        <span class="promo-tag">${p.tag}</span>
                        <h3>${p.title}</h3>
                        <p>${p.content}</p>
                        <div class="promo-footer">
                            <span>${p.formatDate(p.endTime)}</span>
                            <a href="#" class="btn btn-primary">Xem chi tiết</a>
                        </div>
                    </div>
                </article>

                </c:forEach>
            </div>
        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp"/>
</body>

</html>