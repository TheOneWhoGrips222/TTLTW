<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chính sách Bảo hành - Thế Giới Bếp Thông Minh</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&family=Manrope:wght@600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/index.css">
    <link rel="stylesheet" href="assets/css/Header.css">
    <link rel="stylesheet" href="assets/css/main.css">
    <link rel="stylesheet" href="assets/css/chinhsachbaohanh.css">
    <link rel="stylesheet" href="assets/css/indexfont.css">
</head>
<body>

<jsp:include page="common/header.jsp"/>

<main class="main-content">
    <section class="policy-section section-padding">
        <div class="container">
            <h1 class="section-title">Chính sách Bảo hành</h1>

            <div class="policy-content">
                <div class="policy-block">
                    <h3>1. Thời hạn bảo hành</h3>
                    <p>Tất cả sản phẩm do Bếp Thông Minh ABC phân phối đều được bảo hành chính hãng theo thời hạn quy định của nhà sản xuất. Thời gian bảo hành tiêu chuẩn là 24 tháng kể từ ngày mua hàng (trừ các phụ kiện hoặc sản phẩm tiêu hao).</p>
                </div>

                <div class="policy-block">
                    <h3>2. Điều kiện bảo hành (Sản phẩm được bảo hành miễn phí)</h3>
                    <ul>
                        <li>Sản phẩm còn trong thời hạn bảo hành được ghi trên phiếu bảo hành hoặc tem bảo hành.</li>
                        <li>Lỗi kỹ thuật do nhà sản xuất, không bao gồm các lỗi do người dùng gây ra.</li>
                        <li>Sản phẩm không bị can thiệp, sửa chữa bởi bên thứ ba không được ủy quyền.</li>
                        <li>Tem bảo hành (nếu có) phải còn nguyên vẹn, không bị rách, tẩy xóa.</li>
                        <li>Khách hàng phải xuất trình phiếu bảo hành (bản cứng hoặc bản điện tử) khi có yêu cầu.</li>
                    </ul>
                </div>

                <div class="policy-block">
                    <h3>3. Các trường hợp từ chối bảo hành (Sửa chữa có tính phí)</h3>
                    <ul>
                        <li>Sản phẩm đã hết thời hạn bảo hành.</li>
                        <li>Sản phẩm bị hư hỏng do thiên tai, hỏa hoạn, lụt lội, sét đánh, côn trùng xâm nhập.</li>
                        <li>Sản phẩm bị hư hỏng do lỗi của người sử dụng:
                            <ul>
                                <li>Sử dụng sai điện áp quy định, nguồn điện không ổn định.</li>
                                <li>Lắp đặt, sử dụng không đúng theo hướng dẫn của nhà sản xuất.</li>
                                <li>Sản phẩm bị rơi, vỡ, va đập mạnh trong quá trình sử dụng.</li>
                                <li>Sản phẩm bị ẩm ướt, oxy hóa do để trong môi trường không phù hợp.</li>
                            </ul>
                        </li>
                        <li>Tự ý tháo dỡ, sửa chữa hoặc thay đổi cấu trúc sản phẩm.</li>
                        <li>Phiếu bảo hành bị mất, rách, hoặc thông tin bị tẩy xóa.</li>
                    </ul>
                </div>

                <div class="policy-block">
                    <h3>4. Quy trình tiếp nhận bảo hành</h3>
                    <p>Khi sản phẩm phát sinh lỗi, quý khách vui lòng thực hiện theo các bước sau:</p>
                    <ol>
                        <li>Liên hệ Hotline Kỹ thuật <strong>1900.1234</strong> để được hỗ trợ từ xa. Rất nhiều sự cố về cài đặt app hoặc kết nối có thể được giải quyết ngay lập tức.</li>
                        <li>Nếu không thể khắc phục từ xa, quý khách vui lòng mang sản phẩm đến trung tâm bảo hành của Bếp Thông Minh ABC hoặc trung tâm bảo hành ủy quyền của hãng.</li>
                        <li>Đối với các sản phẩm cồng kềnh (tủ lạnh, bếp từ, máy rửa bát...), chúng tôi sẽ hỗ trợ bảo hành tận nhà trong phạm vi nội thành TP.HCM.</li>
                        <li>Thời gian xử lý bảo hành dự kiến: từ 3 - 7 ngày làm việc (không tính Thứ 7, Chủ Nhật) tùy thuộc vào mức độ hư hỏng của thiết bị.</li>
                    </ol>
                </div>

                <div class="policy-block">
                    <h3>5. Địa điểm tiếp nhận bảo hành</h3>
                    <p><strong>Trung tâm Bảo hành Bếp Thông Minh TTB</strong></p>
                    <p><strong>Địa chỉ:</strong> Khu phố 6, Phường Linh Trung, TP. Thủ Đức, TP. Hồ Chí Minh</p>
                    <p><strong>Hotline:</strong> 1900.1234</p>
                    <p><strong>Giờ làm việc:</strong> 08:30 - 17:30 (Thứ 2 - Thứ 7)</p>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp"/>
</body>
</html>