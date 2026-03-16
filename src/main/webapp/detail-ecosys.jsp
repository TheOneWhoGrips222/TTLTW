<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Chi tiết Hệ sinh thái - Bếp Đồng Bộ</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <link rel="stylesheet" href="assets/css/main.css" />
    <link rel="stylesheet" href="assets/css/Header.css" />
    <link rel="stylesheet" href="assets/css/index.css" />
    <link rel="stylesheet" href="assets/css/ecosystem.css" />
</head>
<body>

<jsp:include page="common/header.jsp"></jsp:include>

<main class="main-content">
    <section class="eco-detail-header section-padding">
        <div class="container">
            <div class="eco-detail-grid">
                <div class="eco-detail-image">
                    <img src="${eco.image}" alt="Hệ sinh thái Bosch">
                </div>
                <div class="eco-detail-info">
                    <nav class="breadcrumb">
                        <a href="ecos-list">Hệ sinh thái</a> / <span>${eco.name}</span>
                    </nav>
                    <h1>${eco.name}</h1>
                    <div class="eco-meta">
                        <span><i class="fa fa-layer-group"></i> ${count} Thiết bị đồng bộ</span>

                    </div>
                    <a href="#" class="btn-eco-contact">
                        <i class="fa fa-comments"></i> Nhận tư vấn lắp đặt trọn gói
                    </a>
                </div>
            </div>
        </div>
    </section>

    <section class="section-padding bg-light">
        <div class="container">
            <h2 class="section-title">Thiết bị trong hệ sinh thái</h2>

            <div class="product-grid">
                <c:forEach var="p" items="${eco.products}">
                <div class="product-card">
                    <div class="product-img">
                        <img src="${p.image}" alt="Bếp từ">
                    </div>
                    <div class="product-info">
                        <h4>${p.product_name}</h4>

                        <a href="product-detail?id=${p.product_id}" class="btn-view">Xem chi tiết</a>
                    </div>
                </div>
                </c:forEach>
            </div>
        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp"></jsp:include>

</body>
</html>