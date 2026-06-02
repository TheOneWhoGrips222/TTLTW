package com.webthietbibep.dao;

import com.webthietbibep.model.ChartData;
import com.webthietbibep.model.TopProduct;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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
            JOIN orders o   ON oi.order_id  = o.order_id
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
        String groupBy, labelExpr, dateFilter;

        switch (mode == null ? "day" : mode) {
            case "week" -> {
                labelExpr  = "CONCAT('T', LPAD(WEEK(o.created_at,1),2,'0'), '/', YEAR(o.created_at))";
                groupBy    = "YEAR(o.created_at), WEEK(o.created_at,1)";
                dateFilter = "o.created_at >= DATE_SUB(NOW(), INTERVAL 12 WEEK)";
            }
            case "month" -> {
                labelExpr  = "DATE_FORMAT(o.created_at, '%m/%Y')";
                groupBy    = "DATE_FORMAT(o.created_at, '%Y-%m')";
                dateFilter = "o.created_at >= DATE_SUB(NOW(), INTERVAL 12 MONTH)";
            }
            case "year" -> {
                labelExpr  = "CAST(YEAR(o.created_at) AS CHAR)";
                groupBy    = "YEAR(o.created_at)";
                dateFilter = "o.created_at >= DATE_SUB(NOW(), INTERVAL 5 YEAR)";
            }
            case "custom" -> {
                labelExpr  = "DATE_FORMAT(o.created_at, '%d/%m/%Y')";
                groupBy    = "DATE(o.created_at)";
                dateFilter = "DATE(o.created_at) BETWEEN :from AND :to";
            }
            default -> {
                labelExpr  = "DATE_FORMAT(o.created_at, '%d/%m')";
                groupBy    = "DATE(o.created_at)";
                dateFilter = "o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
            }
        }

        String sql = "SELECT " +
                "    " + labelExpr + "              AS label, " +
                "    COALESCE(SUM(o.total_amount),0) AS revenue, " +
                "    COUNT(DISTINCT o.order_id)       AS order_count, " +
                "    COALESCE(SUM(oi.quantity),0)     AS products_sold " +
                "FROM orders o " +
                "LEFT JOIN order_items oi ON o.order_id = oi.order_id " +
                "WHERE o.status = 'HOAN_THANH' AND " + dateFilter + " " +
                "GROUP BY " + groupBy + " " +
                "ORDER BY MIN(o.created_at) ASC";

        final String finalFrom = fromDate;
        final String finalTo   = toDate;

        List<Map<String, Object>> rows = get().withHandle(h -> {
            var q = h.createQuery(sql);
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