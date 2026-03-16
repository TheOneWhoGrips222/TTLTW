package com.webthietbibep.dao;


import com.webthietbibep.model.OrderItem;

import java.util.List;

public class OrderItemDAO extends BaseDao {
    public void insert(OrderItem i) {
        get().useHandle(h ->
                h.createUpdate("""
            INSERT INTO order_items
            (order_id, product_id, quantity, price_at_purchase)
            VALUES (:oid, :pid, :qty, :price)
        """)
                        .bind("oid", i.getOrder_id())
                        .bind("pid", i.getProduct_id())
                        .bind("qty", i.getQuantity())
                        .bind("price", i.getPrice_at_purchase())
                        .execute()
        );
    }


    public List<OrderItem> getByOrder(int orderId) {
        return get().withHandle(h ->
                h.createQuery("""
                SELECT order_id,
                       product_id,
                       quantity,
                       price_at_purchase
                FROM order_items
                WHERE order_id = :id
            """)
                        .bind("id", orderId)
                        .mapToBean(OrderItem.class)
                        .list()
        );
    }
}

