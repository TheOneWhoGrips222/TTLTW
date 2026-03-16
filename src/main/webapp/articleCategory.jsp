<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Góc tư vấn</title>
    <link rel="stylesheet" href="assets/css/Header.css">
    <link rel="stylesheet" href="assets/css/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="assets/css//goctuvan.css">
    <link rel="stylesheet" href="assets/css/indexfont.css">
</head>
<body>
<jsp:include page="common/header.jsp"/>

<main>
    <div class = "content".>
        <h1>Góc tư vấn Bếp thông minh TTB</h1>
        <div class = "bar" >
            <span><b>Bài Viết | Danh mục: ${name}</b></span>

            <form action="article-category" method="get">
                <input type="hidden" name="cateId" value="${param.cateId}">
                <select name ="filter" onchange="this.form.submit()">
                    <option   value = "new" ${filter == 'new' ? 'selected' : ' '}>Sắp xếp: Mới nhất</option>
                    <option  value = "population" ${filter == 'population' ? 'selected' : ''}>Sắp xếp: Phổ biến nhất</option>
                    <option  value = "AZ" ${filter == 'AZ' ? 'selected' :' '}>Sắp xếp: Theo A-Z</option>
                </select>
            </form>
        </div>
        <div class = "container_grid">
            <div class = "left">
                <c:forEach var = "a" items="${listC}">
                    <div class ="item">
                        <div class = "img_content"><img src="${a.image}"></div>
                        <div class = "text_content">
                            <h4>${a.tip}</h4>
                            <h2><a href="detail-article?id=${a.id}">${a.title}</a></h2>
                            <div>${a.content}</div>
                            <div class = "time">
                                <span><i class="fa fa-calendar"></i> ${a.formatDate(a.create_date)}</span>
                                <span style = "margin-left: 10px"><i class="fa fa-heart"></i> ${a.likecount}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>



            </div>
            <div class = "right">
                <div class = "list">
                    <h3><i class="fa fa-list"></i> Danh Mục Bài Viết</h3>
                    <ul>
                        <c:forEach var = "c" items="${listCate}">
                            <li><a href="article-category?cateId=${c.category_id}">${c.category_name}</a></li>
                        </c:forEach>
                    </ul>
                </div>

                <div class = "popular">
                    <h3><i class="fa fa-fire"></i> Đang Hot</h3>
                    <ul>
                        <c:forEach var ="a" items="${listHA}">
                            <li><a href="detail-article?id=${a.id}">${a.title}</a></li>
                        </c:forEach>
                    </ul>
                </div>
            </div>


        </div>

    </div>
</main>
<jsp:include page="common/footer.jsp"/>

</body>
</html>