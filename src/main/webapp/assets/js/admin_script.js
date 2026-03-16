document.addEventListener("DOMContentLoaded", function() {

    // --- Biểu đồ Doanh thu (Line Chart) ---
    const revenueCtx = document.getElementById('revenueChart').getContext('2d');
    if (revenueCtx) {
        // Tạo gradient
        const gradient = revenueCtx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, 'rgba(59, 130, 246, 0.5)');
        gradient.addColorStop(1, 'rgba(59, 130, 246, 0)');

        new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'],
                datasets: [{
                    label: 'Doanh thu (triệu đồng)',
                    data: [5, 9, 7, 8, 6, 12, 15],
                    backgroundColor: gradient,
                    borderColor: '#3b82f6',
                    borderWidth: 2,
                    pointBackgroundColor: '#3b82f6',
                    pointRadius: 4,
                    fill: true,
                    tension: 0.4 // Làm mượt đường
                }]
            },
            options: {
                responsive: true,
                // ĐÃ XÓA: maintainAspectRatio: false
                scales: {
                    y: {
                        beginAtZero: true
                    }
                },
                plugins: {
                    legend: {
                        display: false // Ẩn chú thích 'Doanh thu'
                    }
                }
            }
        });
    }

    // --- Biểu đồ Sản phẩm (Doughnut Chart) ---
    const productCtx = document.getElementById('productChart').getContext('2d');
    if (productCtx) {
        new Chart(productCtx, {
            type: 'doughnut',
            data: {
                labels: ['Bếp từ Bosch', 'Robot Xiaomi', 'Tủ lạnh Samsung', 'Máy rửa bát Hafele', 'Khác'],
                datasets: [{
                    label: 'Doanh số',
                    data: [30, 25, 15, 10, 20],
                    backgroundColor: [
                        '#3b82f6', // blue
                        '#f59e0b', // yellow
                        '#1e293b', // dark blue
                        '#22c55e', // green
                        '#94a3b8'  // gray
                    ],
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                // ĐÃ XÓA: maintainAspectRatio: false
                plugins: {
                    legend: {
                        position: 'bottom' // Đưa chú thích xuống dưới
                    }
                }
            }
        });
    }

});
// --- LOGIC CHO SIDEBAR ACCORDION ---
document.querySelectorAll('.menu-item-has-children .sidebar-link').forEach(link => {
    link.addEventListener('click', function(e) {
        // Ngăn click vào link cha (href="#")
        if (this.getAttribute('href') === '#') {
            e.preventDefault();
        }

        // Lấy mục li cha
        const parentLi = this.closest('.menu-item-has-children');

        // Toggle class 'open'
        parentLi.classList.toggle('open');
    });
});