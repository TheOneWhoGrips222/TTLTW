package com.webthietbibep.dao;

import com.webthietbibep.db.JDBIConnector;
import com.webthietbibep.model.Order;
import com.webthietbibep.model.OrderItem;
import com.webthietbibep.model.Voucher;

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
                        .bind("status", o.getStatus())
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
                order_id, user_id, address_id, total_amount,
                status, payment_method, created_at, note, voucher_id
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


    public List<Order> getOrdersFiltered(String keyword, String status, int page, int pageSize) {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus  = status  != null && !status.trim().isEmpty();

        StringBuilder sql = new StringBuilder("""
            SELECT
                o.order_id, o.user_id, o.address_id, o.total_amount,
                o.status, o.payment_method, o.created_at, o.note, o.voucher_id,
                u.full_name AS userName,
                CONCAT_WS(', ', ua.address_detail, ua.ward, ua.district, ua.province) AS addressDetail,
                ua.receiver_name
            FROM orders o
            JOIN users u ON o.user_id = u.user_id
            LEFT JOIN user_addresses ua ON o.address_id = ua.address_id
            WHERE 1=1
        """);

        if (hasKeyword) sql.append(" AND (CAST(o.order_id AS CHAR) LIKE :keyword OR u.full_name LIKE :keyword) ");
        if (hasStatus)  sql.append(" AND o.status = :status ");
        sql.append(" ORDER BY o.created_at DESC LIMIT :limit OFFSET :offset ");

        int offset = (page - 1) * pageSize;
        return JDBIConnector.get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (hasKeyword) query.bind("keyword", "%" + keyword.trim() + "%");
            if (hasStatus)  query.bind("status", status.trim());
            query.bind("limit", pageSize);
            query.bind("offset", offset);
            return query.mapToBean(Order.class).list();
        });
    }

    public int countOrdersFiltered(String keyword, String status) {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus  = status  != null && !status.trim().isEmpty();

        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*)
            FROM orders o
            JOIN users u ON o.user_id = u.user_id
            WHERE 1=1
        """);

        if (hasKeyword) sql.append(" AND (CAST(o.order_id AS CHAR) LIKE :keyword OR u.full_name LIKE :keyword) ");
        if (hasStatus)  sql.append(" AND o.status = :status ");

        return JDBIConnector.get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (hasKeyword) query.bind("keyword", "%" + keyword.trim() + "%");
            if (hasStatus)  query.bind("status", status.trim());
            return query.mapTo(Integer.class).one();
        });
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
                handle.createQuery(sql).mapToBean(Order.class).list()
        );
    }

    public Order getOrderById(int orderId) {

        String sql = """
        SELECT
            o.order_id,
            o.user_id,
            o.address_id,
            o.total_amount,
            o.status,
            o.payment_method,
            o.created_at,
            o.note,
            o.voucher_id,
            o.ghn_order_code,

            o.payment_status,
            o.payment_time,
            o.transaction_no,

            u.full_name AS userName,
            CONCAT_WS(
                ', ',
                ua.address_detail,
                ua.ward,
                ua.district,
                ua.province
            ) AS addressDetail

        FROM orders o
        JOIN users u
            ON o.user_id = u.user_id

        LEFT JOIN user_addresses ua
            ON o.address_id = ua.address_id

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
    
    public boolean hasUserPurchasedProduct(int userId, int productId) {
        String sql = """
            SELECT COUNT(*)
            FROM orders o
            JOIN order_items oi ON o.order_id = oi.order_id
            WHERE o.user_id    = :userId
              AND oi.product_id = :productId
              AND o.status      = 'HOAN_THANH'
        """;
        return JDBIConnector.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId",    userId)
                        .bind("productId", productId)
                        .mapTo(Integer.class)
                        .one()
        ) > 0;
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

    public void saveGhnCode(int orderId,String code){

        String sql="""
        UPDATE orders
        SET ghn_order_code=:code
        WHERE order_id=:id
    """;

        get().useHandle(h->

                h.createUpdate(sql)
                        .bind("code",code)
                        .bind("id",orderId)
                        .execute()

        );
    }
    public Order getByGhnCode(String ghnCode) {

        String sql = """
        SELECT *
        FROM orders
        WHERE ghn_order_code = :code
    """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("code", ghnCode)
                        .mapToBean(Order.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public List<Order> getOrdersNeedSync() {

        String sql = """
        SELECT *
        FROM orders
        WHERE ghn_order_code IS NOT NULL
          AND ghn_order_code <> ''
          AND status NOT IN ('HOAN_THANH', 'DA_HUY')
    """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .mapToBean(Order.class)
                        .list()
        );
    }

    // check nếu thanh toán online thanh cong
    public void updatePaymentSuccess(
            int orderId,
            String transactionNo){

        String sql = """
        UPDATE orders
        SET
            payment_status='PAID',
            payment_time=NOW(),
            transaction_no=:txn,
            status='CHO_XAC_NHAN'
        WHERE order_id=:id
    """;

        get().useHandle(h ->
                h.createUpdate(sql)
                        .bind("txn",transactionNo)
                        .bind("id",orderId)
                        .execute()
        );
    }

    //check nếu thanh toan thất bại
    public void updatePaymentFail(
            int orderId){

        String sql = """
        UPDATE orders
        SET payment_status='FAILED'
        WHERE order_id=:id
    """;

        get().useHandle(h ->
                h.createUpdate(sql)
                        .bind("id",orderId)
                        .execute()
        );
    }


    public void saveOrderVoucher(int orderId, int voucherId) {
        get().useHandle(h -> {
            int newodId = h.createUpdate("INSERT INTO order_voucher (order_id, voucher_id) VALUES (:orderId, :voucherId)")
                    .bind("orderId", orderId).bind("voucherId", voucherId)
                    .executeAndReturnGeneratedKeys("order_voucher_id").mapTo(Integer.class).one();


            h.createUpdate("UPDATE orders SET voucher_id = :generatedId WHERE order_id = :orderId")
                    .bind("generatedId", newodId).bind("orderId", orderId).execute();
        });
    }

    public List<Voucher> getVouchersByOrderId(int orderId) {
        return get().withHandle(h ->
                h.createQuery("  SELECT v.discountType, v.code FROM orders o JOIN order_voucher ov ON o.voucher_id = ov.order_voucher_id JOIN vouchers v ON ov.voucher_id = v.id WHERE o.order_id = :orderId")
                        .bind("orderId", orderId).mapToBean(Voucher.class).list()
        );
    }

}
