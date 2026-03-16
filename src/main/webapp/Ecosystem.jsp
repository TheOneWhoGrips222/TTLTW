<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Hệ sinh thái Bếp - Giải pháp đồng bộ</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <link rel="stylesheet" href="assets/css/main.css" />
    <link rel="stylesheet" href="assets/css/Header.css" />
    <link rel="stylesheet" href="assets/css/index.css" />
    <link rel="stylesheet" href="assets/css/indexfont.css" />
    <link rel="stylesheet" href="assets/css/ecosystem.css" />
</head>
<body>

<jsp:include page="common/header.jsp"></jsp:include>

<main class="main-content">
    <section class="eco-hero">
        <div class="container">
            <div class="eco-hero-box">
                <h1>Hệ Sinh Thái Bếp Đồng Bộ</h1>
                <p>Giải pháp tối ưu cho không gian bếp hiện đại, kết nối hoàn hảo giữa công năng và thẩm mỹ.</p>
            </div>
        </div>
    </section>

    <section class="section-padding bg-light">
        <div class="container">
            <h2 class="section-title">Hệ Sinh Thái</h2>

            <div class="eco-grid">
                <c:forEach var="e" items="${listE}">
                    <div class="eco-item">
                        <div class="eco-image">
                            <img src="${e.image}" alt="${e.name}">
                        </div>
                        <div class="eco-info">
                            <h3>${e.name}</h3>
                            <div class="eco-footer">
                                <a href="detail-ecosystem?id=${e.id}" class="btn-eco">Khám phá ngay</a>
                            </div>
                        </div>
                    </div> </c:forEach>
            </div> <c:if test="${empty listE}">
            <p style="text-align: center;">Hiện chưa có hệ sinh thái nào để hiển thị.</p>
        </c:if>
        </div>
    </section>


</main>

<jsp:include page="common/footer.jsp"></jsp:include>

</body>
</html>