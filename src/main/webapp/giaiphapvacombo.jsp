<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Giải pháp và Combo</title>
    <link rel="stylesheet" href="assets/css/Header.css">
    <link rel="stylesheet" href="assets/css/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="assets/css/giaiphapvacombo.css">
</head>
<body>
<jsp:include page="common/header.jsp"/>
<main>
    <div class="combo-section section-padding bg-light">
        <div class="container">
            <h1 class="section-title text-center">Các Combo Sản phẩm </h1>
            <p class="section-subtitle text-center">Giảm giá khi mua trọn bộ thiết bị.</p>
            <div class="combo-grid">
             <c:forEach var="c" items="${listC}">
                <div class="combo-card">
                    <div class="combo-header">
                        <span class="combo-label combo-basic">${c.tag}</span>
                        <img src="${c.image}" alt="Combo Căn hộ" class="combo-image">
                    </div>
                    <div class="combo-body">
                        <h4>${c.name}</h4>
                        <p class="combo-desc">${c.content}</p>
                        <ul>
                            <c:forEach var = "i" items="${c.listadvance}">
                            <li><i class="fa fa-check-circle"></i> ${i.advance}</li>
                            </c:forEach>
                            <li><i class="fa fa-gift"></i> ${c.gift}</li>
                        </ul>
                        <div class="combo-price-block">
                            <span class="old-price">${c.getPriceFormat(c.baseprice)}</span>
                            <span class="current-price">${c.getPriceFormat(c.discountprice)}</span>
                        </div>
                        <a href="combo?id=${c.id}" class="btn btn-primary btn-full-width">Mua Combo </a>
                    </div>
                </div>
             </c:forEach>


                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>
</body>
</html>