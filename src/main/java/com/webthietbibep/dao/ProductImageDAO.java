package com.webthietbibep.dao;

import com.webthietbibep.model.ProductImage;

import java.util.List;

public class ProductImageDAO extends BaseDao {

    public List<ProductImage> getByProductId(int productId) {
        String sql = "SELECT * FROM product_images WHERE product_id = :pid ORDER BY sort_order ASC";
        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("pid", productId)
                        .mapToBean(ProductImage.class)
                        .list()
        );
    }

    public void insert(ProductImage img) {
        String sql = "INSERT INTO product_images (product_id, image_url, sort_order) VALUES (:pid, :url, :sort)";
        get().useHandle(h ->
                h.createUpdate(sql)
                        .bind("pid", img.getProduct_id())
                        .bind("url", img.getImage_url())
                        .bind("sort", img.getSort_order())
                        .execute()
        );
    }


    public ProductImage getById(int id) {
        return get().withHandle(h ->
                h.createQuery("SELECT * FROM product_images WHERE image_id = :id")
                        .bind("id", id)
                        .mapToBean(ProductImage.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public void deleteById(int id) {
        get().useHandle(h ->
                h.createUpdate("DELETE FROM product_images WHERE image_id = :id")
                        .bind("id", id)
                        .execute()
        );
    }
}