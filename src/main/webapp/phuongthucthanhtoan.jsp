<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phương thức thanh toán - Thế Giới Bếp Thông Minh</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&family=Manrope:wght@600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/index.css">
    <link rel="stylesheet" href="assets/css/Header.css">
    <link rel="stylesheet" href="assets/css/main.css">
    <link rel="stylesheet" href="assets/css/tuyendung.css">
    <script src="assets/css/tuyendung.js"></script>
    <link rel="stylesheet" href="assets/css/phuongthucthanhtoan.css">
</head>
<body>

<jsp:include page="common/header.jsp"/>

<main class="main-content">
    <section class="policy-section section-padding">
        <div class="container">
            <h1 class="section-title">Phương thức Thanh toán</h1>

            <div class="policy-content">
                <p>Để mang đến trải nghiệm mua sắm thuận tiện nhất, Bếp Thông Minh ABC hỗ trợ đa dạng các phương thức thanh toán. Quý khách có thể lựa chọn hình thức phù hợp nhất dưới đây:</p>

                <div class="policy-block">
                    <h3>1. Thanh toán tiền mặt khi nhận hàng (COD)</h3>
                    <p>Quý khách thanh toán trực tiếp bằng tiền mặt cho nhân viên giao hàng hoặc nhân viên kỹ thuật lắp đặt sau khi đã nhận và kiểm tra sản phẩm.</p>
                    <p><strong>Lưu ý:</strong> Chúng tôi chỉ áp dụng COD cho các đơn hàng có giá trị dưới 20.000.000 VNĐ. Đối với các đơn hàng giá trị cao hơn, quý khách vui lòng đặt cọc trước (theo phương thức 2).</p>
                </div>

                <div class="policy-block">
                    <h3>2. Chuyển khoản Ngân hàng</h3>
                    <p>Quý khách có thể thanh toán bằng cách chuyển khoản vào tài khoản ngân hàng của chúng tôi. Vui lòng ghi rõ <strong>[Mã đơn hàng] - [Số điện thoại]</strong> trong nội dung chuyển khoản.</p>
                    <p><strong>Thông tin tài khoản:</strong></p>
                    <ul>
                        <li><strong>Ngân hàng:</strong> Vietcombank - Chi nhánh TP.HCM</li>
                        <li><strong>Chủ tài khoản:</strong> CÔNG TY TNHH BẾP THÔNG MINH ABC</li>
                        <li><strong>Số tài khoản:</strong> 0123456789</li>
                    </ul>
                    <div class="payment-logos">
                        <img src=https://cdn.haitrieu.com/wp-content/uploads/2022/02/Logo-Vietcombank.png" alt="Logo Vietcombank">
                    </div>
                </div>

                <div class="policy-block">
                    <h3>3. Thanh toán Online qua VNPAY / Momo</h3>
                    <p>Chúng tôi chấp nhận thanh toán qua các ví điện tử và cổng thanh toán VNPAY (bao gồm ATM nội địa, thẻ Visa/Mastercard). Giao dịch nhanh chóng, an toàn và bảo mật.</p>
                    <div class="payment-logos">
                        <img src="https://vinadesign.vn/uploads/images/2023/05/vnpay-logo-vinadesign-25-12-57-55.jpg" alt="Logo VNPAY">
                        <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Logo-MoMo-Square.png" alt="Logo Momo">
                        <img src="https://example.com/logo-visa.png" alt="Logo Visa">
                        <img src="https://example.com/logo-mastercard.png" alt="Logo Mastercard">
                    </div>
                </div>

                <div class="policy-block">
                    <h3>4. Thanh toán Trả góp</h3>
                    <p>Bếp Thông Minh ABC hỗ trợ chương trình trả góp 0% lãi suất qua thẻ tín dụng của các ngân hàng liên kết. Quý khách có thể lựa chọn hình thức này ở bước thanh toán hoặc liên hệ hotline <strong>1900.5678</strong> để được tư vấn chi tiết.</p>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp"/>
</body>
</html>