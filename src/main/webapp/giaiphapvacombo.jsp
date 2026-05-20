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

                            <a href="add-combo?id=${c.id}&q=1" style="margin-bottom: 10px" class="btn btn-primary btn-full-width">Thêm vào giỏ hàng</a>

                            <a href="combo?id=${c.id}" class="btn btn-primary btn-full-width">Xem chi tiết </a>
                        </div>
                    </div>
                </c:forEach>


            </div>
        </div>
    </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>
<script>
    document.addEventListener('click', function (event) {
        const addCartLink = event.target.closest('a[href*="add-combo"]');

        if (addCartLink) {
            event.preventDefault();

            const originalText = addCartLink.innerHTML;
            const originalBg = addCartLink.style.backgroundColor;
            const originalBorder = addCartLink.style.borderColor;
            const originalColor = addCartLink.style.color;

            addCartLink.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang thêm...';
            addCartLink.style.pointerEvents = 'none';
            addCartLink.style.opacity = '0.7';

            const url = addCartLink.getAttribute('href');

            fetch(url)
                .then(response => {
                    if (response.redirected && response.url.includes('login')) {
                        window.location.href = response.url;
                        return;
                    }
                    return response.text();
                })
                .then(html => {
                    if (!html) return;

                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');

                    const currentHeader = document.querySelector('header');
                    const newHeader = doc.querySelector('header');
                    if (currentHeader && newHeader) {
                        currentHeader.replaceWith(newHeader);
                    }

                    const newMessage = doc.querySelector('.mb-6');
                    const currentMessage = document.querySelector('.mb-6');

                    if (newMessage) {
                        if (currentMessage) {
                            currentMessage.replaceWith(newMessage);
                        } else {
                            const mainLayout = document.querySelector('main');
                            if (mainLayout) {
                                mainLayout.insertAdjacentElement('afterbegin', newMessage);
                            }
                        }
                        const targetScroll = document.querySelector('.mb-6') || newMessage;
                        targetScroll.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }

                    addCartLink.innerHTML = '<i class="fa-solid fa-check"></i> Đã thêm thành công!';
                    addCartLink.style.backgroundColor = '#28a745';
                    addCartLink.style.borderColor = '#28a745';
                    addCartLink.style.color = '#ffffff';
                    addCartLink.style.opacity = '1';

                    setTimeout(() => {
                        addCartLink.innerHTML = originalText;
                        addCartLink.style.pointerEvents = 'auto';
                        addCartLink.style.backgroundColor = originalBg;
                        addCartLink.style.borderColor = originalBorder;
                        addCartLink.style.color = originalColor;
                    }, 2000);
                })
                .catch(error => {
                    console.error('Lỗi:', error);
                    addCartLink.innerHTML = originalText;
                    addCartLink.style.pointerEvents = 'auto';
                    addCartLink.style.opacity = '1';
                });
        }
    });
</script>
</body>
</html>