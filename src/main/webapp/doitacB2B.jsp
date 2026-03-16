<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <title>Đối tác B2B - Bếp Thông Minh TTB</title>
    <link rel="stylesheet" href="assets/css/indexfont.css" />
    <link rel="stylesheet" href="assets/css/Header.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <link rel="stylesheet" href="assets/css/main.css" />
    <link rel="stylesheet" href="assets/css/doitacB2B.css">
    <link rel="stylesheet" href="assets/css/index.css">
</head>

<body>
<jsp:include page="common/header.jsp"/>

<main class="main-content">
    <!-- HERO BANNER -->
    <section class="b2b-hero" style="background-image: url('https://placehold.co/1920x400/0D2C4A/fff?text=Giải+Pháp+Cho+Kiến+Trúc+Sư');">
        <div class="b2b-hero-content">
            <h1 class="section-title">Hợp tác cùng Bếp Thông Minh TTB</h1>
            <p>Chúng tôi cung cấp giải pháp thiết bị bếp thông minh toàn diện với chiết khấu tốt nhất <br> cho Kiến trúc sư, Nhà thầu, và Đơn vị Thiết kế.</p>
            <a href="#form-dang-ky" class="btn btn-primary">Liên hệ Hợp tác</a>
        </div>
    </section>

    <!-- LỢI ÍCH HỢP TÁC -->
    <section class="values-section section-padding">
        <div class="container">
            <h3 class="section-title">Tại sao nên chọn chúng tôi làm Đối tác?</h3>
            <div class="values-grid">
                <div class="value-item">
                    <i class="fas fa-percent"></i>
                    <h4>Chiết khấu Hấp dẫn</h4>
                    <p>Hưởng mức chiết khấu B2B cạnh tranh nhất thị trường, tối ưu hóa lợi nhuận cho dự án của bạn.</p>
                </div>
                <div class="value-item">
                    <i class="fas fa-cubes"></i>
                    <h4>Hệ sinh thái Đa dạng</h4>
                    <p>Cung cấp trọn gói thiết bị từ nhiều thương hiệu, tương thích đa hệ sinh thái (Google, Apple, Alexa...).</p>
                </div>
                <div class="value-item">
                    <i class="fas fa-headset"></i>
                    <h4>Hỗ trợ Kỹ thuật Chuyên sâu</h4>
                    <p>Đội ngũ kỹ thuật viên riêng hỗ trợ tư vấn, lắp đặt, và cài đặt smarthome cho khách hàng của bạn.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- FORM ĐĂNG KÝ -->
    <section id="form-dang-ky" class="b2b-form-section section-padding bg-light">
        <div class="container">
            <h3 class="section-title">Trở thành Đối tác</h3>
            <div class="b2b-form-layout">
                <div class="b2b-info">
                    <h4>Chúng tôi tìm kiếm:</h4>
                    <p>Chúng tôi luôn chào đón các đối tác uy tín trong ngành:</p>
                    <ul>
                        <li><i class="fas fa-pencil-ruler"></i> Kiến trúc sư & Công ty Thiết kế Nội thất</li>
                        <li><i class="fas fa-hard-hat"></i> Tổng thầu Xây dựng & Giám sát Dự án</li>
                        <li><i class="fas fa-store"></i> Showroom & Cửa hàng Bán lẻ Thiết bị</li>
                    </ul>
                    <p>Hãy để lại thông tin, bộ phận B2B của chúng tôi sẽ liên hệ với bạn trong vòng 24 giờ làm việc.</p>
                </div>

                <div class="b2b-form-container">
                    <form action="#" method="POST">
                        <div class="form-group">
                            <label for="company-name">Tên Công ty / Tên của bạn *</label>
                            <input type="text" id="company-name" name="company-name" required>
                        </div>
                        <div class="form-group-grid">
                            <div class="form-group">
                                <label for="email">Email *</label>
                                <input type="email" id="email" name="email" required>
                            </div>
                            <div class="form-group">
                                <label for="phone">Số điện thoại *</label>
                                <input type="text" id="phone" name="phone" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="partner-type">Bạn là *</label>
                            <select id="partner-type" name="partner-type" required>
                                <option value="">-- Chọn lĩnh vực --</option>
                                <option value="architect">Kiến trúc sư / Thiết kế</option>
                                <option value="contractor">Nhà thầu / Xây dựng</option>
                                <option value="reseller">Cửa hàng / Bán lẻ</option>
                                <option value="other">Khác</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="message">Lời nhắn (Tùy chọn)</label>
                            <textarea id="message" name="message" rows="4"></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Gửi thông tin</button>
                    </form>
                </div>
            </div>
        </div>
    </section>
</main>
<jsp:include page="common/footer.jsp"/>
</body>

</html>