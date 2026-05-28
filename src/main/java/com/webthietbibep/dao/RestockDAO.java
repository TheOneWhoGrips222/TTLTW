package com.webthietbibep.dao;

import com.webthietbibep.model.RestockSuggestion;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class RestockDAO extends BaseDao {

    public List<RestockSuggestion> getRestockSuggestions() {
        String sql = """
            SELECT
                p.product_id AS productId,
                p.product_name AS productName,
                p.image AS productImage,
                p.stock_quantity AS stockQuantity,
                COALESCE(SUM(CASE
                    WHEN o.created_at >= NOW() - INTERVAL 30 DAY
                    THEN oi.quantity ELSE 0 END), 0) AS sold30,
                COALESCE(SUM(CASE
                    WHEN o.created_at >= NOW() - INTERVAL 14 DAY
                    THEN oi.quantity ELSE 0 END), 0) AS sold14,
                COALESCE(SUM(CASE
                    WHEN o.created_at >= NOW() - INTERVAL 7 DAY
                    THEN oi.quantity ELSE 0 END), 0) AS sold7
            FROM products p
            LEFT JOIN order_items oi ON p.product_id = oi.product_id
            LEFT JOIN orders o ON oi.order_id  = o.order_id
            AND o.status     = 'HOAN_THANH'
            GROUP BY p.product_id, p.product_name, p.image, p.stock_quantity
            HAVING sold30 > 0
            ORDER BY p.product_id
        """;

        List<Map<String, Object>> rows = get().withHandle(h ->
                h.createQuery(sql)
                        .mapToMap()
                        .list()
        );

        List<RestockSuggestion> result = new ArrayList<>();

        for (Map<String, Object> row : rows) {
            int    stock  = toInt(row.get("stockQuantity"));
            double sold30 = toDouble(row.get("sold30"));
            double sold14 = toDouble(row.get("sold14"));
            double sold7  = toDouble(row.get("sold7"));

            double avgPerDay30 = sold30 / 30.0;
            double avgPerDay7  = sold7  / 7.0;
            double avgPerDay14 = sold14 / 14.0;

            double threshold7Day  = avgPerDay7  * 7  * 2;
            double threshold14Day = avgPerDay14 * 14 * 2;

            String urgency;
            if (stock <= threshold7Day) {
                urgency = "URGENT";
            } else if (stock <= threshold14Day) {
                urgency = "WARNING";
            } else {
                continue;
            }

            int raw       = (int) Math.ceil(avgPerDay30 * 30 * 1.5 - stock);
            int suggested = raw > 0 ? (int) (Math.ceil(raw / 10.0) * 10) : 10;

            int daysLeft = (avgPerDay30 > 0)
                    ? (int) Math.floor(stock / avgPerDay30)
                    : 999;

            RestockSuggestion s = new RestockSuggestion();
            s.setProductId(toInt(row.get("productId")));
            s.setProductName(String.valueOf(row.get("productName")));
            s.setProductImage(String.valueOf(row.get("productImage")));
            s.setStockQuantity(stock);
            s.setAvgSoldPerDay(Math.round(avgPerDay30 * 10.0) / 10.0);
            s.setDaysUntilEmpty(daysLeft);
            s.setSuggestedQuantity(suggested);
            s.setUrgencyLevel(urgency);
            result.add(s);
        }

        result.sort((a, b) -> {
            if (!a.getUrgencyLevel().equals(b.getUrgencyLevel())) {
                return "URGENT".equals(a.getUrgencyLevel()) ? -1 : 1;
            }
            return Integer.compare(a.getStockQuantity(), b.getStockQuantity());
        });

        return result;
    }

    private int toInt(Object o) {
        if (o == null) return 0;
        if (o instanceof Number) return ((Number) o).intValue();
        try { return Integer.parseInt(o.toString()); } catch (Exception e) { return 0; }
    }

    private double toDouble(Object o) {
        if (o == null) return 0;
        if (o instanceof Number) return ((Number) o).doubleValue();
        try { return Double.parseDouble(o.toString()); } catch (Exception e) { return 0; }
    }
}