package com.webthietbibep.dao;

import com.webthietbibep.model.ChartData;
import com.webthietbibep.model.TopProduct;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;

public class StatsDAO extends BaseDao {

    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status = 'HOAN_THANH'";
        return get().withHandle(h -> h.createQuery(sql).mapTo(Double.class).one());
    }

    public int countAllOrders() {
        return get().withHandle(h -> h.createQuery("SELECT COUNT(*) FROM orders").mapTo(Integer.class).one());
    }

    public int countUsers() {
        return get().withHandle(h -> h.createQuery("SELECT COUNT(*) FROM users").mapTo(Integer.class).one());
    }

    public List<TopProduct> getTopSellingProducts() {
        String sql = """
            SELECT
                p.product_name AS productName,
                p.image        AS productImage,
                SUM(oi.quantity) AS totalSold,
                SUM(oi.quantity * oi.price_at_purchase) AS totalRevenue
            FROM order_items oi
            JOIN orders o  ON oi.order_id  = o.order_id
            JOIN products p ON oi.product_id = p.product_id
            WHERE o.status = 'HOAN_THANH'
            GROUP BY p.product_id, p.product_name, p.image
            ORDER BY totalSold DESC
            LIMIT 5
        """;
        return get().withHandle(h -> h.createQuery(sql).mapToBean(TopProduct.class).list());
    }

    public List<ChartData> getRevenueLast7Days() {
        return getRevenueByMode("day", null, null);
    }

    public List<ChartData> getRevenueByMode(String mode, String fromDate, String toDate) {
        String sql;

        switch (mode == null ? "day" : mode) {
            case "week" -> sql = """
                SELECT
                    CONCAT('T', WEEK(created_at, 1), '/', YEAR(created_at)) AS label,
                    COALESCE(SUM(total_amount), 0)                            AS revenue,
                    COUNT(DISTINCT order_id)                                  AS order_count,
                    COALESCE((SELECT SUM(oi2.quantity)
                              FROM order_items oi2
                              WHERE oi2.order_id IN (
                                  SELECT o2.order_id FROM orders o2
                                  WHERE o2.status = 'HOAN_THANH'
                                    AND WEEK(o2.created_at,1) = WEEK(orders.created_at,1)
                                    AND YEAR(o2.created_at)   = YEAR(orders.created_at)
                              )), 0)                                           AS products_sold,
                    MIN(created_at)                                            AS sort_key
                FROM orders
                WHERE status = 'HOAN_THANH'
                  AND created_at >= DATE_SUB(NOW(), INTERVAL 12 WEEK)
                GROUP BY YEAR(created_at), WEEK(created_at, 1)
                ORDER BY sort_key ASC
                LIMIT 12
            """;
            case "month" -> sql = """
                SELECT
                    DATE_FORMAT(created_at, '%m/%Y')     AS label,
                    COALESCE(SUM(total_amount), 0)       AS revenue,
                    COUNT(DISTINCT order_id)              AS order_count,
                    (SELECT COALESCE(SUM(oi2.quantity),0)
                     FROM order_items oi2
                     JOIN orders o2 ON oi2.order_id = o2.order_id
                     WHERE o2.status = 'HOAN_THANH'
                       AND DATE_FORMAT(o2.created_at,'%Y-%m') = DATE_FORMAT(orders.created_at,'%Y-%m')
                    )                                     AS products_sold,
                    MIN(created_at)                       AS sort_key
                FROM orders
                WHERE status = 'HOAN_THANH'
                  AND created_at >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
                GROUP BY DATE_FORMAT(created_at, '%Y-%m')
                ORDER BY sort_key ASC
                LIMIT 12
            """;
            case "year" -> sql = """
                SELECT
                    YEAR(created_at)                     AS label,
                    COALESCE(SUM(total_amount), 0)       AS revenue,
                    COUNT(DISTINCT order_id)              AS order_count,
                    (SELECT COALESCE(SUM(oi2.quantity),0)
                     FROM order_items oi2
                     JOIN orders o2 ON oi2.order_id = o2.order_id
                     WHERE o2.status = 'HOAN_THANH'
                       AND YEAR(o2.created_at) = YEAR(orders.created_at)
                    )                                     AS products_sold,
                    MIN(created_at)                       AS sort_key
                FROM orders
                WHERE status = 'HOAN_THANH'
                  AND created_at >= DATE_SUB(NOW(), INTERVAL 5 YEAR)
                GROUP BY YEAR(created_at)
                ORDER BY sort_key ASC
                LIMIT 5
            """;
            case "custom" -> sql = """
                SELECT
                    DATE_FORMAT(created_at, '%d/%m/%Y')  AS label,
                    COALESCE(SUM(total_amount), 0)       AS revenue,
                    COUNT(DISTINCT order_id)              AS order_count,
                    (SELECT COALESCE(SUM(oi2.quantity),0)
                     FROM order_items oi2
                     JOIN orders o2 ON oi2.order_id = o2.order_id
                     WHERE o2.status = 'HOAN_THANH'
                       AND DATE(o2.created_at) = DATE(orders.created_at)
                    )                                     AS products_sold,
                    MIN(created_at)                       AS sort_key
                FROM orders
                WHERE status = 'HOAN_THANH'
                  AND DATE(created_at) BETWEEN :from AND :to
                GROUP BY DATE(created_at)
                ORDER BY sort_key ASC
            """;
            default -> sql = """
                SELECT
                    DATE_FORMAT(created_at, '%d/%m')     AS label,
                    COALESCE(SUM(total_amount), 0)       AS revenue,
                    COUNT(DISTINCT order_id)              AS order_count,
                    (SELECT COALESCE(SUM(oi2.quantity),0)
                     FROM order_items oi2
                     JOIN orders o2 ON oi2.order_id = o2.order_id
                     WHERE o2.status = 'HOAN_THANH'
                       AND DATE(o2.created_at) = DATE(orders.created_at)
                    )                                     AS products_sold,
                    MIN(created_at)                       AS sort_key
                FROM orders
                WHERE status = 'HOAN_THANH'
                  AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
                GROUP BY DATE(created_at)
                ORDER BY sort_key ASC
                LIMIT 30
            """;
        }

        final String finalSql = sql;
        final String finalFrom = fromDate;
        final String finalTo   = toDate;

        List<Map<String, Object>> rows = get().withHandle(h -> {
            var q = h.createQuery(finalSql);
            if ("custom".equals(mode) && finalFrom != null && finalTo != null) {
                q.bind("from", finalFrom).bind("to", finalTo);
            }
            return q.mapToMap().list();
        });

        List<ChartData> result = new ArrayList<>();
        for (Map<String, Object> row : rows) {
            ChartData cd = new ChartData();
            cd.setDate(String.valueOf(row.get("label")));
            cd.setValue(toDouble(row.get("revenue")));
            cd.setOrderCount(toInt(row.get("order_count")));
            cd.setProductsSold(toInt(row.get("products_sold")));
            result.add(cd);
        }
        return result;
    }

    private double toDouble(Object o) {
        if (o == null) return 0;
        if (o instanceof Number) return ((Number) o).doubleValue();
        try { return Double.parseDouble(o.toString()); } catch (Exception e) { return 0; }
    }

    private int toInt(Object o) {
        if (o == null) return 0;
        if (o instanceof Number) return ((Number) o).intValue();
        try { return Integer.parseInt(o.toString()); } catch (Exception e) { return 0; }
    }
}