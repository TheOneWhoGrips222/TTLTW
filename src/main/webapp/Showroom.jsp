<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hệ thống Showroom</title>
    <link rel="stylesheet" href="assets/css/Header.css">
    <link rel="stylesheet" href="assets/css/index.css">
    <link rel="stylesheet" href="assets/css/showroom.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="assets/css/indexfont.css">
    <script src="assets/js/showroom.js"></script>

</head>
<body>
<jsp:include page="common/header.jsp"></jsp:include>
<main >
 <c:forEach var = "s" items="${listS}">
   <div class = "showroom-name"><h1>${s.name} </h1> </div>
    <div class = "introduce">${s.content}</div>
    <section class="hero-banner swiper" id="hero-slider">
        <div class="swiper-wrapper">
            <c:forEach var = "i" items="${s.images}">
            <div class="swiper-slide hero-slide" style="background-image: url('https://placehold.co/1920x600/333/fff?text=Hero+Banner+1');">
                <div class="hero-content">
                    <img src="${i.image}">

                </div>
            </div>

            </c:forEach>
        </div>
        <div class="swiper-pagination"></div>
    </section>
    <div class = "content">
          <div class = "adress">Bếp Thông Minh TTB : ${s.address}</div>
          <ul>
              <li><i class="fas fa-map-marker-alt"></i> ${s.address}</li>
              <li><i class="fas fa-phone"></i> ${s.phone}</li>
              <li><i class="fas fa-envelope"></i> ${s.email}</li>
              <li><i class="fas fa-clock"></i> ${s.time}</li>
          </ul>
    </div>
    <iframe src="${s.map_url}" width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>

<hr>
 </c:forEach>


</main>

<jsp:include page="common/footer.jsp"></jsp:include>
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
</body>
</html>