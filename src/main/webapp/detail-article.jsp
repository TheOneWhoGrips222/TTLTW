<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${article.title}</title>
    <link rel="stylesheet" href="assets/css/Header.css">
    <link rel="stylesheet" href="assets/css/index.css">
    <link rel="stylesheet" href="assets/css/goctuvan.css">
    <link rel="stylesheet" href="assets/css/indexfont.css">
    <link rel="stylesheet" href="assets/css/detailarticle.css">

</head>
<body style="background-color: #f4f4f4;">
<jsp:include page="common/header.jsp"/>

<main>
    <div class="content">
        <div class="container_grid">

            <div class="left article-content-wrapper">
                <div class="breadcrumb-static">
                    <a href="arcticle">Góc tư vấn</a> / <a href="#">Bài viết</a>
                </div>

                <h1 class="article-title-static" style="text-align: left; line-height: 1.3;">${article.title}</h1>

                <div class="article-meta-static">
                    Ngày đăng: ${article.formatDate(article.create_date)} |
                    Tác giả: ${article.author} |
                    Lượt thích: ${article.likecount}
                </div>

                <c:if test="${not empty article.image}">
                    <div class="featured-image-container">
                        <img src="${article.image}" alt="${article.title}">
                    </div>
                </c:if>

                <div class="article-body-static">
                    ${article.body}
                </div>

                <div class="hot-articles-static">
                    <h3>Bài viết nổi bật</h3>
                    <ul>
                        <c:forEach var="item" items="${hotarticle}">
                            <li>
                                <a href="detail-article?id=${item.id}">• ${item.title}</a>
                            </li>
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