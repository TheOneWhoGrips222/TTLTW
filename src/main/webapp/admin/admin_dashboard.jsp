<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Admin Dashboard - Thống kê</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        .dashboard-cards { display: flex; gap: 20px; margin-bottom: 30px; }
        .card { flex: 1; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); display: flex; align-items: center; justify-content: space-between; }
        .card-info h3 { margin: 0; font-size: 24px; color: #333; }
        .card-info p { margin: 5px 0 0; color: #777; }
        .card-icon { font-size: 40px; color: #3498db; }
        .chart-container { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .table-container { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        table th, table td { padding: 12px; text-align: left; border-bottom: 1px solid #eee; }
        .product-img { width: 50px; height: 50px; object-fit: cover; border-radius: 4px; }
    </style>
</head>
<body>

<jsp:include page="common/sidebar.jsp" />

<div class="main-content" style="margin-left: 250px; padding: 20px; background: #f5f6fa; min-height: 100vh;">

    <h2>Tổng quan kinh doanh</h2>

    <div class="dashboard-cards">
        <div class="card">
            <div class="card-info">
                <h3>${totalRevenueFormat} đ</h3>
                <p>Doanh thu thực tế</p>
            </div>
            <div class="card-icon"><i class="fas fa-coins" style="color: #2ecc71;"></i></div>
        </div>

        <div class="card">
            <div class="card-info">
                <h3>${totalOrders}</h3>
                <p>Tổng đơn hàng</p>
            </div>
            <div class="card-icon"><i class="fas fa-shopping-cart" style="color: #3498db;"></i></div>
        </div>

        <div class="card">
            <div class="card-info">
                <h3>${totalUsers}</h3>
                <p>Khách hàng thành viên</p>
            </div>
            <div class="card-icon"><i class="fas fa-users" style="color: #f1c40f;"></i></div>
        </div>
    </div>

    <div class="chart-container">
        <h3>Biểu đồ doanh thu 7 ngày qua</h3>
        <canvas id="revenueChart" height="100"></canvas>
    </div>

    <div class="table-container">
        <h3>Top 5 Sản Phẩm Bán Chạy Nhất</h3>
        <table>
            <thead>
            <tr>
                <th>Hình ảnh</th>
                <th>Tên sản phẩm</th>
                <th>Đã bán</th>
                <th>Doanh thu đem lại</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${topProducts}">
                <tr>
                    <td><img src="${pageContext.request.contextPath}/${p.productImage}" class="product-img" alt="Product"></td>
                    <td>${p.productName}</td>
                    <td><strong>${p.totalSold}</strong></td>
                    <td>
                            ${p.formattedRevenue}
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty topProducts}">
                <tr><td colspan="4">Chưa có dữ liệu đơn hàng thành công.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<script>
    // Lấy dữ liệu từ JSP đổ vào mảng JavaScript
    const labels = [];
    const dataValues = [];

    <c:forEach var="item" items="${chartDataList}">
    labels.push("${item.date}");
    dataValues.push(${item.value});
    </c:forEach>

    // Cấu hình Chart.js
    const ctx = document.getElementById('revenueChart').getContext('2d');
    const revenueChart = new Chart(ctx, {
        type: 'line', // Loại biểu đồ: line, bar, pie...
        data: {
            labels: labels, // Ngày (Trục X)
            datasets: [{
                label: 'Doanh thu (VNĐ)',
                data: dataValues, // Tiền (Trục Y)
                borderColor: '#3498db',
                backgroundColor: 'rgba(52, 152, 219, 0.2)',
                borderWidth: 2,
                fill: true,
                tension: 0.4 // Làm mềm đường cong
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'top' },
            },
            scales: {
                y: { beginAtZero: true }
            }
        }
    });
</script>
</body>
</html>