<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tuyển dụng - Thế Giới Bếp Thông Minh</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&family=Manrope:wght@600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/index.css">
    <link rel="stylesheet" href="assets/css/Header.css">
    <link rel="stylesheet" href="assets/css/main.css">
    <link rel="stylesheet" href="assets/css/tuyendung.css">
    <script src="assets/css/tuyendung.js"></script>
</head>
<body>

<jsp:include page="common/header.jsp"/>

<main class="main-content">
    <section class="careers-hero section-padding bg-light">
        <div class="container">
            <h1 class="section-title">Gia nhập Đội ngũ</h1>
            <p class="careers-intro">
                Chúng tôi là một đội ngũ trẻ, đam mê công nghệ và smarthome. <br>
                Hãy cùng chúng tôi kiến tạo những căn bếp thông minh cho người Việt.
            </p>
        </div>
    </section>

    <section class="benefits-section section-padding">
        <div class="container">
            <h3 class="section-title">Tại sao bạn nên chọn chúng tôi?</h3>
            <div class="values-grid">
                <div class="value-item">
                    <i class="fas fa-rocket"></i>
                    <h4>Môi trường Đam mê</h4>
                    <p>Làm việc cùng những người trẻ, nhiệt huyết, luôn cập nhật các xu hướng công nghệ mới nhất.</p>
                </div>
                <div class="value-item">
                    <i class="fas fa-graduation-cap"></i>
                    <h4>Đào tạo Chuyên sâu</h4>
                    <p>Được đào tạo bài bản về sản phẩm, hệ sinh thái IoT và kỹ năng tư vấn giải pháp smarthome.</p>
                </div>
                <div class="value-item">
                    <i class="fas fa-gift"></i>
                    <h4>Chế độ Đãi ngộ</h4>
                    <p>Lương thưởng cạnh tranh, bảo hiểm đầy đủ, và các chuyến du lịch hàng năm.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="job-listings section-padding">
        <div class="container">
            <h3 class="section-title">Các vị trí đang mở</h3>
            <div class="job-accordion">

                <div class="job-item">
                    <button class="job-item-header">
                        <h4>Nhân viên Kỹ thuật Lắp đặt Smarthome</h4>
                        <div class="job-meta">
                            <span><i class="fas fa-map-marker-alt"></i> TP. Hồ Chí Minh</span>
                            <span><i class="fas fa-briefcase"></i> Toàn thời gian</span>
                        </div>
                    </button>
                    <div class="job-item-content">
                        <h5>Mô tả công việc:</h5>
                        <ul>
                            <li>Lắp đặt, cài đặt các thiết bị bếp thông minh (bếp từ, robot, cảm biến...).</li>
                            <li>Hướng dẫn khách hàng sử dụng app và tạo kịch bản tự động.</li>
                            <li>Bảo hành, bảo trì thiết bị tại nhà khách hàng.</li>
                        </ul>
                        <h5>Yêu cầu:</h5>
                        <ul>
                            <li>Có kiến thức cơ bản về điện, mạng Wi-Fi.</li>
                            <li>Đam mê công nghệ, smarthome là một lợi thế.</li>
                            <li>Trung thực, cẩn thận và có kỹ năng giao tiếp tốt.</li>
                        </ul>
                        <a href="mailto:tuyendung@bepthongminh.vn" class="btn btn-primary">Ứng tuyển ngay</a>
                    </div>
                </div>

                <div class="job-item">
                    <button class="job-item-header">
                        <h4>Nhân viên Tư vấn Bán hàng (Showroom)</h4>
                        <div class="job-meta">
                            <span><i class="fas fa-map-marker-alt"></i> TP. Hồ Chí Minh</span>
                            <span><i class="fas fa-briefcase"></i> Toàn thời gian</span>
                        </div>
                    </button>
                    <div class="job-item-content">
                        <h5>Mô tả công việc:</h5>
                        <ul>
                            <li>Đón tiếp và tư vấn cho khách hàng về các giải pháp bếp thông minh.</li>
                            <li>Demo sản phẩm, hệ sinh thái (Google Home, Alexa...).</li>
                            <li>Quản lý đơn hàng và chăm sóc khách hàng sau bán.</li>
                        </ul>
                        <h5>Yêu cầu:</h5>
                        <ul>
                            <li>Ngoại hình sáng, giọng nói rõ ràng, dễ nghe.</li>
                            <li>Yêu thích công nghệ và thiết bị nhà bếp.</li>
                            <li>Kỹ năng giao tiếp, thuyết phục tốt.</li>
                        </ul>
                        <a href="mailto:tuyendung@bepthongminh.vn" class="btn btn-primary">Ứng tuyển ngay</a>
                    </div>
                </div>

            </div>
        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp"/>
</body>
</html>