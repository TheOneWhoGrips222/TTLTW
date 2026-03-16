package com.webthietbibep.dao;

import com.webthietbibep.model.ProductComment;

import java.util.List;

public class ProductCommentDAO extends BaseDao {

    public List<ProductComment> getByProductId(int productId) {
        String sql = """
            SELECT c.*, u.username
            FROM product_comments c
            JOIN users u ON c.user_id = u.user_id
            WHERE c.product_id = :pid
            ORDER BY c.created_at DESC
        """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("pid", productId)
                        .mapToBean(ProductComment.class)
                        .list()
        );
    }

    public void insert(ProductComment comment) {
        String sql = """
            INSERT INTO product_comments (product_id, user_id, content)
            VALUES (:productId, :userId, :content)
        """;

        get().useHandle(h ->
                h.createUpdate(sql)
                        .bind("productId", comment.getProduct_id())
                        .bind("userId", comment.getUser_id())
                        .bind("content", comment.getContent())
                        .execute()
        );
    }
    public List<ProductComment> getLatestForHome(int limit) {
        String sql = """
        SELECT c.content, c.created_at, u.username
        FROM product_comments c
        JOIN users u ON c.user_id = u.user_id
        ORDER BY c.created_at DESC
        LIMIT :limit
    """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("limit", limit)
                        .mapToBean(ProductComment.class)
                        .list()
        );
    }

}
