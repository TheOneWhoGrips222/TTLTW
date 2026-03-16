package com.webthietbibep.dao;

import com.webthietbibep.model.ChartData;
import com.webthietbibep.model.TopProduct;

import java.util.List;

public class StatsDAO extends BaseDao {

    // 1. Tổng doanh thu (Chỉ tính đơn HOAN_THANH)
    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status = 'HOAN_THANH'";
        return get().withHandle(h -> h.createQuery(sql).mapTo(Double.class).one());
    }

    // 2. Đếm tổng số đơn hàng (Tất cả trạng thái)
    public int countAllOrders() {
        return get().withHandle(h -> h.createQuery("SELECT COUNT(*) FROM orders").mapTo(Integer.class).one());
    }

    // 3. Đếm tổng User
    public int countUsers() {
        return get().withHandle(h -> h.createQuery("SELECT COUNT(*) FROM users").mapTo(Integer.class).one());
    }

    // 4. Lấy doanh thu 7 ngày gần nhất (Để vẽ biểu đồ)
    public List<ChartData> getRevenueLast7Days() {
        String sql = """
            SELECT 
                DATE_FORMAT(created_at, '%d/%m') as date, 
                SUM(total_amount) as value
            FROM orders 
            WHERE status = 'HOAN_THANH' 
              AND created_at >= DATE(NOW()) - INTERVAL 6 DAY
            GROUP BY DATE(created_at)
            ORDER BY DATE(created_at) ASC
        """;
        return get().withHandle(h -> h.createQuery(sql).mapToBean(ChartData.class).list());
    }

    // 5. Top 5 sản phẩm bán chạy nhất (Tính theo số lượng đã bán trong đơn HOAN_THANH)
    public List<TopProduct> getTopSellingProducts() {
        String sql = """
            SELECT 
                p.product_name AS productName,
                p.image AS productImage,
                SUM(oi.quantity) AS totalSold,
                SUM(oi.quantity * oi.price_at_purchase) AS totalRevenue
            FROM order_items oi
            JOIN orders o ON oi.order_id = o.order_id
            JOIN products p ON oi.product_id = p.product_id
            WHERE o.status = 'HOAN_THANH'
            GROUP BY p.product_id, p.product_name, p.image
            ORDER BY totalSold DESC
            LIMIT 5
        """;
        return get().withHandle(h -> h.createQuery(sql).mapToBean(TopProduct.class).list());
    }
}