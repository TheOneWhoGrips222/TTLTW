package com.webthietbibep.dao;

import com.webthietbibep.model.ImportHistory;
import com.webthietbibep.model.RestockSuggestion;

import java.time.LocalDateTime;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class RestockDAO extends BaseDao {

    public List<RestockSuggestion> getRestockSuggestions() {
        long pshCount = get().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM product_sold_history")
                        .mapTo(Long.class).one()
        );

        if (pshCount > 0) {
            return getSuggestionsFromHistory();
        } else {
            return getSuggestionsFromOrders();
        }
    }

    private List<RestockSuggestion> getSuggestionsFromHistory() {
        String sql = """
            SELECT
                p.product_id,
                p.product_name,
                p.image,
                p.stock_quantity,
                COALESCE(SUM(CASE WHEN psh.sold_date >= CURDATE() - INTERVAL 30 DAY
                                  THEN psh.quantity_sold ELSE 0 END), 0) AS sold_30,
                COALESCE(SUM(CASE WHEN psh.sold_date >= CURDATE() - INTERVAL 14 DAY
                                  THEN psh.quantity_sold ELSE 0 END), 0) AS sold_14,
                COALESCE(SUM(CASE WHEN psh.sold_date >= CURDATE() - INTERVAL 7 DAY
                                  THEN psh.quantity_sold ELSE 0 END), 0) AS sold_7,
                COALESCE((SELECT SUM(ih.quantity)
                          FROM import_history ih
                          WHERE ih.product_id = p.product_id
                            AND ih.imported_at >= NOW() - INTERVAL 30 DAY), 0) AS imported_30
            FROM products p
            LEFT JOIN product_sold_history psh ON p.product_id = psh.product_id
            GROUP BY p.product_id, p.product_name, p.image, p.stock_quantity
            HAVING sold_30 > 0
            ORDER BY p.product_id
        """;
        return buildSuggestions(sql);
    }

    private List<RestockSuggestion> getSuggestionsFromOrders() {
        String sql = """
            SELECT
                p.product_id,
                p.product_name,
                p.image,
                p.stock_quantity,
                COALESCE(SUM(CASE WHEN o.created_at >= NOW() - INTERVAL 30 DAY
                                  THEN oi.quantity ELSE 0 END), 0) AS sold_30,
                COALESCE(SUM(CASE WHEN o.created_at >= NOW() - INTERVAL 14 DAY
                                  THEN oi.quantity ELSE 0 END), 0) AS sold_14,
                COALESCE(SUM(CASE WHEN o.created_at >= NOW() - INTERVAL 7  DAY
                                  THEN oi.quantity ELSE 0 END), 0) AS sold_7,
                0 AS imported_30
            FROM products p
            LEFT JOIN order_items oi ON p.product_id = oi.product_id
            LEFT JOIN orders o       ON oi.order_id  = o.order_id
                                    AND o.status      = 'HOAN_THANH'
            GROUP BY p.product_id, p.product_name, p.image, p.stock_quantity
            HAVING sold_30 > 0
            ORDER BY p.product_id
        """;
        return buildSuggestions(sql);
    }

    private List<RestockSuggestion> buildSuggestions(String sql) {
        List<Map<String, Object>> rows = get().withHandle(h ->
                h.createQuery(sql).mapToMap().list()
        );

        List<RestockSuggestion> result = new ArrayList<>();

        for (Map<String, Object> row : rows) {
            int    stock      = toInt(row.get("stock_quantity"));
            double sold30     = toDouble(row.get("sold_30"));
            double sold14     = toDouble(row.get("sold_14"));
            double sold7      = toDouble(row.get("sold_7"));
            int    imported30 = toInt(row.get("imported_30"));

            double avgPerDay30 = sold30 / 30.0;
            double avgPerDay14 = sold14 / 14.0;
            double avgPerDay7  = sold7  / 7.0;

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

            int raw = (int) Math.ceil(avgPerDay30 * 30 * 1.5 - stock - imported30);
            int suggested = raw > 0 ? (int) (Math.ceil(raw / 10.0) * 10) : 10;

            int daysLeft = (avgPerDay30 > 0)
                    ? (int) Math.floor(stock / avgPerDay30)
                    : 999;

            RestockSuggestion s = new RestockSuggestion();
            s.setProductId(toInt(row.get("product_id")));
            s.setProductName(toString(row.get("product_name")));
            s.setProductImage(toString(row.get("image")));
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

    public List<ImportHistory> getAllImportHistory(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = """
            SELECT
                ih.import_id,
                ih.product_id,
                p.product_name,
                p.image,
                ih.supplier_id,
                s.company_name  AS supplier_name,
                ih.quantity,
                ih.unit_price,
                ih.total_cost,
                ih.note,
                ih.imported_by,
                u.full_name     AS imported_by_name,
                ih.imported_at
            FROM import_history ih
            JOIN  products  p ON ih.product_id  = p.product_id
            LEFT JOIN suppliers s ON ih.supplier_id = s.supplier_id
            LEFT JOIN users     u ON ih.imported_by  = u.user_id
            ORDER BY ih.imported_at DESC
            LIMIT :limit OFFSET :offset
        """;

        List<Map<String, Object>> rows = get().withHandle(h ->
                h.createQuery(sql)
                        .bind("limit",  pageSize)
                        .bind("offset", offset)
                        .mapToMap().list()
        );

        return mapImportRows(rows);
    }

    public int countImportHistory() {
        return get().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM import_history")
                        .mapTo(Integer.class).one()
        );
    }

    public List<ImportHistory> getImportHistoryByProduct(int productId) {
        String sql = """
            SELECT
                ih.import_id,
                ih.product_id,
                p.product_name,
                p.image,
                ih.supplier_id,
                s.company_name  AS supplier_name,
                ih.quantity,
                ih.unit_price,
                ih.total_cost,
                ih.note,
                ih.imported_by,
                u.full_name     AS imported_by_name,
                ih.imported_at
            FROM import_history ih
            JOIN  products  p ON ih.product_id  = p.product_id
            LEFT JOIN suppliers s ON ih.supplier_id = s.supplier_id
            LEFT JOIN users     u ON ih.imported_by  = u.user_id
            WHERE ih.product_id = :productId
            ORDER BY ih.imported_at DESC
        """;

        List<Map<String, Object>> rows = get().withHandle(h ->
                h.createQuery(sql)
                        .bind("productId", productId)
                        .mapToMap().list()
        );

        return mapImportRows(rows);
    }

    public void recordImport(int productId, Integer supplierId, int quantity,
                             Double unitPrice, String note, Integer importedBy) {
        get().useTransaction(h -> {
            Double totalCost = (unitPrice != null) ? unitPrice * quantity : null;
            h.createUpdate("""
                INSERT INTO import_history
                    (product_id, supplier_id, quantity, unit_price, total_cost, note, imported_by)
                VALUES
                    (:pid, :sid, :qty, :price, :cost, :note, :by)
            """)
                    .bind("cost", totalCost)
                    .bind("pid",   productId)
                    .bind("sid",   supplierId)
                    .bind("qty",   quantity)
                    .bind("price", unitPrice)
                    .bind("note",  note)
                    .bind("by",    importedBy)
                    .execute();

            h.createUpdate("""
                UPDATE products
                SET stock_quantity = stock_quantity + :qty
                WHERE product_id = :pid
            """)
                    .bind("qty", quantity)
                    .bind("pid", productId)
                    .execute();
        });
    }

    public void recordSoldItems(int orderId) {
        String sql = """
            INSERT INTO product_sold_history (product_id, sold_date, quantity_sold, order_id)
            SELECT
                oi.product_id,
                DATE(o.created_at),
                oi.quantity,
                o.order_id
            FROM order_items oi
            JOIN orders o ON oi.order_id = o.order_id
            WHERE oi.order_id = :orderId
            ON DUPLICATE KEY UPDATE quantity_sold = quantity_sold + VALUES(quantity_sold)
        """;

        get().useHandle(h ->
                h.createUpdate(sql).bind("orderId", orderId).execute()
        );
    }

    /**
     * Trừ tồn kho cho tất cả sản phẩm trong đơn hàng (gọi khi đơn được admin xác nhận giao hàng).
     * Đồng thời cộng vào sold_quantity để thống kê. Dùng transaction để đảm bảo toàn vẹn dữ liệu,
     * và chặn tồn kho âm bằng điều kiện stock_quantity >= quantity trong WHERE.
     *
     * @return true nếu tất cả sản phẩm đều đủ hàng và đã trừ thành công; false nếu có sản phẩm
     *         không đủ tồn kho (khi đó không sản phẩm nào trong đơn bị trừ - rollback toàn bộ).
     */
    public boolean deductStockForOrder(int orderId) {
        return get().inTransaction(h -> {

            List<Map<String, Object>> items = h.createQuery("""
                        SELECT product_id, quantity
                        FROM order_items
                        WHERE order_id = :orderId
                    """)
                    .bind("orderId", orderId)
                    .mapToMap()
                    .list();

            for (Map<String, Object> item : items) {
                int productId = toInt(item.get("product_id"));
                int quantity = toInt(item.get("quantity"));

                int updated = h.createUpdate("""
                            UPDATE products
                            SET stock_quantity = stock_quantity - :qty,
                                sold_quantity   = sold_quantity + :qty
                            WHERE product_id = :pid
                              AND stock_quantity >= :qty
                        """)
                        .bind("qty", quantity)
                        .bind("pid", productId)
                        .execute();

                if (updated == 0) {
                    // Không đủ tồn kho cho sản phẩm này -> hủy toàn bộ transaction
                    throw new IllegalStateException(
                            "Khong du ton kho cho product_id=" + productId + " (can " + quantity + ")");
                }
            }

            return true;
        });
    }

    private List<ImportHistory> mapImportRows(List<Map<String, Object>> rows) {
        List<ImportHistory> list = new ArrayList<>();
        for (Map<String, Object> row : rows) {
            ImportHistory ih = new ImportHistory();
            ih.setImportId(toInt(row.get("import_id")));
            ih.setProductId(toInt(row.get("product_id")));
            ih.setProductName(toString(row.get("product_name")));
            ih.setProductImage(toString(row.get("image")));
            Object sid = row.get("supplier_id");
            ih.setSupplierId(sid != null ? toInt(sid) : null);
            ih.setSupplierName(toString(row.get("supplier_name")));
            ih.setQuantity(toInt(row.get("quantity")));
            Object price = row.get("unit_price");
            ih.setUnitPrice(price != null ? toDouble(price) : null);
            Object cost = row.get("total_cost");
            ih.setTotalCost(cost != null ? toDouble(cost) : null);
            ih.setNote(toString(row.get("note")));
            Object by = row.get("imported_by");
            ih.setImportedBy(by != null ? toInt(by) : null);
            ih.setImportedByName(toString(row.get("imported_by_name")));
            Object at = row.get("imported_at");
            if (at instanceof LocalDateTime) {
                ih.setImportedAt((LocalDateTime) at);
            } else if (at instanceof java.sql.Timestamp) {
                ih.setImportedAt(((java.sql.Timestamp) at).toLocalDateTime());
            }
            list.add(ih);
        }
        return list;
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

    private String toString(Object o) {
        if (o == null) return "";
        return o.toString();
    }
}