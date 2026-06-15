package com.webthietbibep.dao;

import com.webthietbibep.model.Review;

import java.util.List;

public class ReviewDao extends BaseDao {

    public void insert(Review r) {

        String sql = """
            INSERT INTO reviews
            (user_id, product_id, order_id, rating, comment)
            VALUES
            (:uid,:pid,:oid,:rating,:comment)
        """;

        get().useHandle(h ->
                h.createUpdate(sql)
                        .bind("uid", r.getUser_id())
                        .bind("pid", r.getProduct_id())
                        .bind("oid", r.getOrder_id())
                        .bind("rating", r.getRating())
                        .bind("comment", r.getComment())
                        .execute()
        );
    }

    public boolean hasReviewed(
            int userId,
            int productId,
            int orderId
    ) {

        String sql = """
            SELECT COUNT(*)
            FROM reviews
            WHERE user_id = :uid
            AND product_id = :pid
            AND order_id = :oid
        """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("uid", userId)
                        .bind("pid", productId)
                        .bind("oid", orderId)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }
}