package com.webthietbibep.dao;

import com.webthietbibep.db.JDBIConnector;
import com.webthietbibep.model.Product;

import java.util.List;

public class WishlistDAO {

    public List<Product> getWishlistByUserId(int userId) {
        String sql = """
            SELECT p.* FROM products p
            JOIN wishlist w ON p.product_id = w.product_id
            WHERE w.user_id = :userId
            ORDER BY w.created_at DESC
        """;

        return JDBIConnector.get().withHandle(h ->
                h.createQuery(sql)
                        .bind("userId", userId)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public boolean insert(int userId, int productId) {
        String sql = "INSERT INTO wishlist (user_id, product_id, created_at) VALUES (:uid, :pid, NOW())";
        try {
            return JDBIConnector.get().withHandle(h ->
                    h.createUpdate(sql)
                            .bind("uid", userId)
                            .bind("pid", productId)
                            .execute() > 0
            );
        } catch (Exception e) {
            return false;
        }
    }

    public boolean delete(int userId, int productId) {
        String sql = "DELETE FROM wishlist WHERE user_id = :uid AND product_id = :pid";
        return JDBIConnector.get().withHandle(h ->
                h.createUpdate(sql)
                        .bind("uid", userId)
                        .bind("pid", productId)
                        .execute() > 0
        );
    }

    public boolean checkExist(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = :uid AND product_id = :pid";

        Integer count = JDBIConnector.get().withHandle(h ->
                h.createQuery(sql)
                        .bind("uid", userId)
                        .bind("pid", productId)
                        .mapTo(Integer.class)
                        .one()
        );
        return count != null && count > 0;
    }
}