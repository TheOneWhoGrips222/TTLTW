package com.webthietbibep.dao;

import com.webthietbibep.db.JDBIConnector;
import com.webthietbibep.model.Order;
import com.webthietbibep.model.OrderItem;

import java.util.List;

public class OrdersDAO extends BaseDao {
    public int insert(Order o) {
        String sql = """
        INSERT INTO orders
        (user_id, address_id, total_amount, status, payment_method, note)
        VALUES (:uid, :aid, :total, :status, :pm, :note)
    """;

        return get().withHandle(h ->
                h.createUpdate(sql)
                        .bind("uid", o.getUser_id())
                        .bind("aid", o.getAddress_id())
                        .bind("total", o.getTotal_amount())
                        .bind("status",o.getStatus())
                        .bind("pm", o.getPayment_method())
                        .bind("note", o.getNote())
                        .executeAndReturnGeneratedKeys("order_id")
                        .mapTo(int.class)
                        .one()
        );
    }

    public void cancelExpiredOrders() {
        get().useHandle(h ->
                h.createUpdate("""
            UPDATE orders
            SET status = 'DA_HUY'
            WHERE status = 'CHO_THANH_TOAN'
              AND created_at < NOW() - INTERVAL 30 MINUTE
        """).execute()
        );
    }



    public List<Order> getOrdersByUser(int userId) {
        String sql = """
            SELECT 
                order_id,
                user_id,
                address_id,
                total_amount,
                status,
                payment_method,
                created_at,
                note,
                voucher_id
            FROM orders
            WHERE user_id = :uid
            ORDER BY created_at DESC
        """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("uid", userId)
                        .mapToBean(Order.class)
                        .list()
        );
    }
    public void cancelOrder(int orderId, int userId) {
        get().useHandle(h ->
                h.createUpdate("""
            UPDATE orders
            SET status = 'DA_HUY'
            WHERE order_id = :oid
              AND user_id = :uid
              AND status = 'CHO_XAC_NHAN'
        """)
                        .bind("oid", orderId)
                        .bind("uid", userId)
                        .execute()
        );
    }
    public List<Order> getOrdersByUserAndStatus(int userId, String status) {
        String sql = """
        SELECT *
        FROM orders
        WHERE user_id = :uid
          AND status = :status
        ORDER BY created_at DESC
    """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("uid", userId)
                        .bind("status", status)
                        .mapToBean(Order.class)
                        .list()
        );
    }
    public List<Order> getAllOrders() {
        String sql = """
            SELECT 
                o.order_id, o.user_id, o.address_id, o.total_amount, 
                o.status, o.payment_method, o.created_at, o.note, o.voucher_id,
                u.full_name AS userName,                                     
                CONCAT_WS(', ', ua.address_detail, ua.ward, ua.district, ua.province) AS addressDetail,                           
                ua.receiver_name               
            FROM orders o
            JOIN users u ON o.user_id = u.user_id
            LEFT JOIN user_addresses ua ON o.address_id = ua.address_id
            ORDER BY o.created_at DESC
        """;

        return JDBIConnector.get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Order.class)
                        .list()
        );
    }

    public Order getOrderById(int orderId) {
        String sql = """
            SELECT 
                o.order_id, o.user_id, o.address_id, o.total_amount, 
                o.status, o.payment_method, o.created_at, o.note, o.voucher_id,
                u.full_name AS userName,       
                CONCAT_WS(', ', ua.address_detail, ua.ward, ua.district, ua.province) AS addressDetail
            FROM orders o
            JOIN users u ON o.user_id = u.user_id
            LEFT JOIN user_addresses ua ON o.address_id = ua.address_id
            WHERE o.order_id = :id
        """;

        return JDBIConnector.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", orderId)
                        .mapToBean(Order.class)
                        .findOne()
                        .orElse(null)
        );
    }


    public List<OrderItem> getOrderItems(int orderId) {
        String sql = """
            SELECT 
                oi.order_item_id, oi.order_id, oi.product_id, 
                oi.quantity, oi.price_at_purchase,
                p.product_name AS productName,  
                p.image AS productImage
            FROM order_items oi
            JOIN products p ON oi.product_id = p.product_id
            WHERE oi.order_id = :orderId
        """;

        return JDBIConnector.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("orderId", orderId)
                        .mapToBean(OrderItem.class)
                        .list()
        );
    }


    public int updateStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET status = :status WHERE order_id = :id";

        return JDBIConnector.get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("status", newStatus)
                        .bind("id", orderId)
                        .execute()
        );
    }
}
