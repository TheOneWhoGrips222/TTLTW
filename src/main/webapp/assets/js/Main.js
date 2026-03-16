// Chờ cho toàn bộ nội dung HTML được tải xong
document.addEventListener('DOMContentLoaded', function() {

    // ===== CHỨC NĂNG 1: KHỞI TẠO HERO BANNER SLIDER (BLOCK 1) =====
    // Sử dụng thư viện Swiper.js đã liên kết ở HTML
    const heroSlider = new Swiper('#hero-slider', {
        // Tùy chọn
        loop: true, // Lặp lại
        autoplay: {
            delay: 5000, // Tự động trượt sau 5 giây
        },
        pagination: { // Hiển thị dấu chấm phân trang
            el: '.swiper-pagination',
            clickable: true,
        },
    });

    // ===== CHỨC NĂNG 2: KHỞI TẠO BEST SELLER SLIDER (BLOCK 4) =====
    const bestsellerSlider = new Swiper('#bestseller-slider', {
        loop: true,
        slidesPerView: 4, // Hiển thị 4 sản phẩm
        spaceBetween: 20, // Khoảng cách giữa các sản phẩm
        navigation: { // Hiển thị nút next/prev
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
        // Tùy chọn responsive (điều chỉnh cho mobile)
        breakpoints: {
            // Khi màn hình <= 768px
            768: {
                slidesPerView: 2,
                spaceBetween: 10
            },
            // Khi màn hình <= 480px
            480: {
                slidesPerView: 1,
                spaceBetween: 10
            }
        }
    });

    // ===== CHỨC NĂNG 3: KHỞI TẠO TESTIMONIAL SLIDER (BLOCK 8) =====
    const testimonialSlider = new Swiper('#testimonial-slider', {
        loop: true,
        slidesPerView: 1,
        autoplay: {
            delay: 4000,
        },
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
    });

    // ===== CHỨC NĂNG 4: KHỞI TẠO BRAND SLIDER (BLOCK 9) =====
    const brandSlider = new Swiper('#brand-slider', {
        loop: true,
        slidesPerView: 5,
        spaceBetween: 30,
        autoplay: {
            delay: 3000,
        },
        breakpoints: {
            768: {
                slidesPerView: 3,
            },
            480: {
                slidesPerView: 2,
            }
        }
    });

    // ===== CHỨC NĂNG 5: MEGA MENU (BLOCK 0) =====
    // Đây là logic cơ bản (dùng hover)
    // Cần CSS phức tạp hơn để định vị và tạo kiểu cho .mega-menu
    const navItem = document.querySelector('.nav-item.has-megamenu');
    const megaMenu = document.querySelector('.mega-menu');

    if (navItem && megaMenu) {
        navItem.addEventListener('mouseenter', function() {
            // Hiện mega menu (cần CSS để tạo hiệu ứng)
            megaMenu.style.display = 'block';
        });

        navItem.addEventListener('mouseleave', function() {
            // Ẩn mega menu
            megaMenu.style.display = 'none';
        });
    }

    // ===== CÁC CHỨC NĂNG KHÁC CẦN LÀM =====
    // 1. Logic cho "Thêm vào giỏ hàng" (Thường phức tạp, cần AJAX)
    // 2. Logic cho Search Bar (Gợi ý sản phẩm khi gõ)
    // 3. Logic cho Popup Đăng ký nhận tin (nếu có)

});
