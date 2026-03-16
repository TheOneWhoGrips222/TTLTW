<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Về Chúng Tôi - Thế Giới Bếp Thông Minh</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&family=Manrope:wght@600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/index.css">
    <link rel="stylesheet" href="assets/css/Header.css">
    <link rel="stylesheet" href="assets/css/main.css">
    <link rel="stylesheet" href="assets/css/vechungtoi.css">
</head>
<body>

<jsp:include page="common/header.jsp"/>

<main class="main-content">
    <section class="about-us-section section-padding">
        <div class="container">
            <h1 class="section-title">Về Chúng Tôi</h1>

            <div class="about-hero">
                <img src="https://s3-ap-southeast-1.amazonaws.com/atap-main/gallery-full/ad11f551-7fad-47a1-a734-f2acc495de93/puchong-lagenda-the-dark-elegance.jpg" alt="Không gian bếp hiện đại">
                <h2>Sứ mệnh của chúng tôi là mang đến trải nghiệm sống tiện nghi, hiện đại qua các giải pháp bếp thông minh toàn diện.</h2>
            </div>

            <div class="about-content">
                <h3>Câu chuyện của Bếp Thông Minh ABC</h3>
                <p>
                    Chúng tôi bắt đầu với một niềm tin đơn giản: căn bếp không chỉ là nơi nấu nướng, mà là trái tim của ngôi nhà. Trong kỷ nguyên 4.0, chúng tôi nhận thấy nhu cầu kết nối và tự động hóa các thiết bị bếp ngày càng tăng.
                </p>
                <p>
                    Vì vậy, Bếp Thông Minh ABC ra đời với mong muốn trở thành nhà tư vấn và cung cấp các giải pháp smarthome chuyên biệt cho căn bếp của bạn. Chúng tôi không chỉ bán sản phẩm; chúng tôi mang đến sự tiện lợi, an toàn và nguồn cảm hứng nấu nướng mỗi ngày.
                </p>
            </div>

            <div class="values-section">
                <h3 class="section-title">Giá Trị Cốt Lõi</h3>
                <div class="values-grid">
                    <div class="value-item">
                        <i class="fas fa-brain"></i>
                        <h4>Chuyên môn Sâu</h4>
                        <p>Đội ngũ của chúng tôi là các chuyên gia am hiểu về IoT và hệ sinh thái smarthome, sẵn sàng tư vấn giải pháp tương thích nhất.</p>
                    </div>
                    <div class="value-item">
                        <i class="fas fa-shield-alt"></i>
                        <h4>Chất lượng Chính hãng</h4>
                        <p>Chúng tôi cam kết 100% sản phẩm là hàng chính hãng, với chính sách bảo hành rõ ràng và minh bạch từ các thương hiệu hàng đầu.</p>
                    </div>
                    <div class="value-item">
                        <i class="fas fa-headset"></i>
                        <h4>Dịch vụ Tận tâm</h4>
                        <p>Hỗ trợ lắp đặt, cài đặt app và hướng dẫn sử dụng trọn đời. Sự hài lòng của bạn là ưu tiên số 1 của chúng tôi.</p>
                    </div>
                </div>
            </div>

            <div class="showroom-section">
                <h3 class="section-title">Showroom Trải Nghiệm</h3>
                <div class="showroom-content">
                    <div class="showroom-map">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.447171783424!2d106.697334!3d10.776991!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752f38f9ed8cb5%3A0x1c2250f14890501a!2zQ2jhu6MgQuG6v24gVGjDoG5o!5e0!3m2!1svi!2s!4v1678888888888!5m2!1svi!2s" width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                    </div>
                    <div class="showroom-info">
                        <h4>Ghé thăm chúng tôi</h4>
                        <p>Trải nghiệm trực tiếp các kịch bản bếp thông minh và nhận tư vấn 1-1 từ các chuyên gia.</p>
                        <ul>
                            <li><i class="fas fa-map-marker-alt"></i> Khu phố 6, Phường Linh Trung, TP. Thủ Đức, TP. Hồ Chí Minh</li>
                            <li><i class="fas fa-phone"></i> 1900.5678 (Kinh doanh)</li>
                            <li><i class="fas fa-envelope"></i> 23130356@st.hcmuaf.edu.vn</li>
                            <li><i class="fas fa-clock"></i> Mở cửa: 08:00 - 21:00 (Tất cả các ngày)</li>
                        </ul>
                    </div>
                </div>
            </div>

        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp"/>
</body>
</html>