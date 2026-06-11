package com.webthietbibep.dao;

import com.webthietbibep.model.Notification;
import com.webthietbibep.model.Notification.Type;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class NotificationDAO extends BaseDao {

    private static final int LOW_STOCK_THRESHOLD = 5;


    public List<Notification> getAll(String contextPath, int limit) {
        List<Notification> list = new ArrayList<>();

        list.addAll(getNewOrders(contextPath));
        list.addAll(getLowStockProducts(contextPath));
        list.addAll(getNewUsersToday(contextPath));
        list.addAll(getCancelledOrders(contextPath));
        list.addAll(getPendingPaymentOrders(contextPath));
        list.addAll(getRevenueMilestones(contextPath));

        list.sort((a, b) -> {
            if (a.getCreatedAt() == null && b.getCreatedAt() == null) return 0;
            if (a.getCreatedAt() == null) return 1;
            if (b.getCreatedAt() == null) return -1;
            return b.getCreatedAt().compareTo(a.getCreatedAt());
        });

        return list.size() > limit ? list.subList(0, limit) : list;
    }
    public int countUnread(String contextPath) {
        return getAll(contextPath, 50).size();
    }

    private List<Notification> getNewOrders(String contextPath) {
        String sql = """
            SELECT order_id, total_amount, created_at, u.full_name AS userName
            FROM orders o
            JOIN users u ON o.user_id = u.user_id
            WHERE o.status = 'CHO_XAC_NHAN'
              AND o.created_at >= NOW() - INTERVAL 24 HOUR
            ORDER BY o.created_at DESC
            LIMIT 10
        """;

        List<Map<String, Object>> rows = get().withHandle(h ->
                h.createQuery(sql).mapToMap().list()
        );

        List<Notification> result = new ArrayList<>();
        for (Map<String, Object> r : rows) {
            int orderId = toInt(r.get("order_id"));
            double total = toDouble(r.get("total_amount"));
            String name = str(r.get("userName"));
            LocalDateTime createdAt = toDateTime(r.get("created_at"));

            String msg = String.format("Khách hàng %s đặt đơn #%d - %s₫",
                    name, orderId, formatMoney(total));

            result.add(new Notification(
                    Type.NEW_ORDER,
                    "Đơn hàng mới",
                    msg,
                    contextPath + "/admin/order?id=" + orderId,
                    "fa-solid fa-cart-shopping",
                    "notif-green",
                    createdAt,
                    orderId
            ));
        }
        return result;
    }

    private List<Notification> getLowStockProducts(String contextPath) {
        String sql = """
            SELECT product_id, product_name, stock_quantity
            FROM products
            WHERE stock_quantity <= :threshold AND stock_quantity >= 0
            ORDER BY stock_quantity ASC
            LIMIT 10
        """;

        List<Map<String, Object>> rows = get().withHandle(h ->
                h.createQuery(sql)
                        .bind("threshold", LOW_STOCK_THRESHOLD)
                        .mapToMap().list()
        );

        List<Notification> result = new ArrayList<>();
        for (Map<String, Object> r : rows) {
            int productId = toInt(r.get("product_id"));
            String name = str(r.get("product_name"));
            int qty = toInt(r.get("stock_quantity"));

            String msg = qty == 0
                    ? "\"" + name + "\" đã hết hàng!"
                    : "\"" + name + "\" chỉ còn " + qty + " sản phẩm";

            result.add(new Notification(
                    Type.LOW_STOCK,
                    qty == 0 ? "Hết hàng" : "Sắp hết hàng",
                    msg,
                    contextPath + "/admin/restock",
                    qty == 0 ? "fa-solid fa-circle-exclamation" : "fa-solid fa-triangle-exclamation",
                    qty == 0 ? "notif-red" : "notif-orange",
                    LocalDateTime.now(),
                    productId
            ));
        }
        return result;
    }

    private List<Notification> getNewUsersToday(String contextPath) {
        String sql = """
            SELECT user_id, full_name, email, create_at
            FROM users
            WHERE DATE(create_at) = CURDATE()
              AND role = 'USER'
            ORDER BY create_at DESC
            LIMIT 5
        """;

        List<Map<String, Object>> rows = get().withHandle(h ->
                h.createQuery(sql).mapToMap().list()
        );

        List<Notification> result = new ArrayList<>();
        for (Map<String, Object> r : rows) {
            int userId = toInt(r.get("user_id"));
            String name = str(r.get("full_name"));
            String email = str(r.get("email"));
            LocalDateTime createdAt = toDateTime(r.get("create_at"));

            result.add(new Notification(
                    Type.NEW_USER,
                    "Người dùng mới",
                    name + " (" + email + ") vừa đăng ký",
                    contextPath + "/admin/users",
                    "fa-solid fa-user-plus",
                    "notif-blue",
                    createdAt,
                    userId
            ));
        }
        return result;
    }

    private List<Notification> getCancelledOrders(String contextPath) {
        String sql = """
            SELECT o.order_id, o.total_amount, o.created_at, u.full_name AS userName
            FROM orders o
            JOIN users u ON o.user_id = u.user_id
            WHERE o.status = 'DA_HUY'
              AND o.created_at >= NOW() - INTERVAL 24 HOUR
            ORDER BY o.created_at DESC
            LIMIT 5
        """;

        List<Map<String, Object>> rows = get().withHandle(h ->
                h.createQuery(sql).mapToMap().list()
        );

        List<Notification> result = new ArrayList<>();
        for (Map<String, Object> r : rows) {
            int orderId = toInt(r.get("order_id"));
            double total = toDouble(r.get("total_amount"));
            String name = str(r.get("userName"));
            LocalDateTime createdAt = toDateTime(r.get("created_at"));

            result.add(new Notification(
                    Type.ORDER_CANCELLED,
                    "Đơn hàng bị hủy",
                    "Đơn #" + orderId + " của " + name + " (" + formatMoney(total) + "₫) đã hủy",
                    contextPath + "/admin/order?id=" + orderId,
                    "fa-solid fa-ban",
                    "notif-red",
                    createdAt,
                    orderId
            ));
        }
        return result;
    }

    private List<Notification> getPendingPaymentOrders(String contextPath) {
        String sql = """
            SELECT o.order_id, o.total_amount, o.created_at, u.full_name AS userName
            FROM orders o
            JOIN users u ON o.user_id = u.user_id
            WHERE o.status = 'CHO_THANH_TOAN'
              AND o.created_at < NOW() - INTERVAL 15 MINUTE
              AND o.created_at >= NOW() - INTERVAL 30 MINUTE
            ORDER BY o.created_at ASC
            LIMIT 5
        """;

        List<Map<String, Object>> rows = get().withHandle(h ->
                h.createQuery(sql).mapToMap().list()
        );

        List<Notification> result = new ArrayList<>();
        for (Map<String, Object> r : rows) {
            int orderId = toInt(r.get("order_id"));
            double total = toDouble(r.get("total_amount"));
            String name = str(r.get("userName"));
            LocalDateTime createdAt = toDateTime(r.get("created_at"));

            result.add(new Notification(
                    Type.PENDING_PAYMENT,
                    "Chờ thanh toán",
                    "Đơn #" + orderId + " của " + name + " chưa thanh toán (" + formatMoney(total) + "₫)",
                    contextPath + "/admin/order?id=" + orderId,
                    "fa-solid fa-clock",
                    "notif-orange",
                    createdAt,
                    orderId
            ));
        }
        return result;
    }

    private List<Notification> getRevenueMilestones(String contextPath) {
        String sql = """
            SELECT COALESCE(SUM(total_amount), 0) AS today_revenue
            FROM orders
            WHERE status = 'HOAN_THANH'
              AND DATE(created_at) = CURDATE()
        """;

        double todayRevenue = get().withHandle(h ->
                h.createQuery(sql).mapTo(Double.class).one()
        );

        List<Notification> result = new ArrayList<>();

        long[] milestones = {5_000_000L, 10_000_000L, 20_000_000L, 50_000_000L, 100_000_000L};
        for (long milestone : milestones) {
            if (todayRevenue >= milestone) {
                result.add(new Notification(
                        Type.REVENUE_MILESTONE,
                        "Mốc doanh thu",
                        "Doanh thu hôm nay đã đạt " + formatMoney(milestone) + "₫! 🎉",
                        contextPath + "/admin/dashboard",
                        "fa-solid fa-chart-line",
                        "notif-purple",
                        LocalDateTime.now().withHour(0).withMinute(0),
                        (int)(milestone / 1_000_000)
                ));
                break;
            }
        }
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

    private String str(Object o) {
        return o == null ? "" : o.toString();
    }

    private LocalDateTime toDateTime(Object o) {
        if (o == null) return LocalDateTime.now();
        if (o instanceof LocalDateTime) return (LocalDateTime) o;
        if (o instanceof java.sql.Timestamp) return ((java.sql.Timestamp) o).toLocalDateTime();
        return LocalDateTime.now();
    }

    private String formatMoney(double amount) {
        return String.format("%,.0f", amount).replace(",", ".");
    }
}