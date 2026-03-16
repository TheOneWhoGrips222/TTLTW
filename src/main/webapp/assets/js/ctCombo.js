
    // 1. Chọn ảnh chính và tất cả các ảnh nhỏ (thumbnails)
    const mainImage = document.querySelector('.main-image'); // Chọn thẻ img chính
    const thumbnails = document.querySelectorAll('.thumb-item'); // Chọn danh sách các ô ảnh nhỏ

    // 2. Duyệt qua từng ảnh nhỏ để lắng nghe sự kiện click
    thumbnails.forEach(thumb => {
    thumb.addEventListener('click', function() {
        // Lấy đường dẫn (src) của ảnh bên trong ô được click
        const newSrc = this.querySelector('img').src;

        // Thay đổi ảnh chính thành ảnh vừa click
        mainImage.src = newSrc;

        // 3. Cập nhật hiệu ứng viền đen (active)
        // Xóa class 'active' ở tất cả các ảnh nhỏ
        thumbnails.forEach(t => t.classList.remove('active'));
        // Thêm class 'active' vào ảnh vừa được nhấn
        this.classList.add('active');
    });
});

