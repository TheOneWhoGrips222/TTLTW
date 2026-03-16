package com.webthietbibep.dao;

import com.webthietbibep.model.Brand;

import java.util.List;

public class BrandDAO extends BaseDao {

    public List<Brand> getAll() {
        String sql = "SELECT * FROM brands ORDER BY brand_id DESC";
        return get().withHandle(h ->
                h.createQuery(sql)
                        .mapToBean(Brand.class)
                        .list()
        );
    }

    public List<Brand> getTopBrands() {
        String sql = """
        SELECT b.brand_id, b.brand_name, b.logo_url, SUM(o.quantity) total_sold
        FROM order_items o
        JOIN products p ON p.product_id = o.product_id
        JOIN brands b ON b.brand_id = p.brand_id
        GROUP BY b.brand_id
        ORDER BY total_sold DESC
        LIMIT 4
    """;

        return get().withHandle(h ->
                h.createQuery(sql).mapToBean(Brand.class).list()
        );
    }

    public Brand getById(int id) {
        String sql = "SELECT * FROM brands WHERE brand_id = :id";
        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(Brand.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public void insert(Brand brand) {
        String sql = "INSERT INTO brands (brand_name, logo_url,slogan,description) VALUES (:brand_name, :logo_url, :slogan, :description)";
        get().useHandle(h ->
                h.createUpdate(sql)
                        .bind("brand_name", brand.getBrand_name())
                        .bind("logo_url", brand.getLogo_url())
                        .bind("slogan", brand.getSlogan())
                        .bind("description",brand.getDescription())
                        .execute()
        );
    }

    public void update(Brand brand) {
        String sql = "UPDATE brands SET brand_name = :brand_name, logo_url = :logo_url, slogan =:slogan,description =:description WHERE brand_id = :brand_id";
        get().useHandle(h ->
                h.createUpdate(sql)
                        .bind("brand_name", brand.getBrand_name())
                        .bind("logo_url", brand.getLogo_url())
                        .bind("brand_id", brand.getBrand_id())
                        .bind("slogan", brand.getSlogan())
                        .bind("description",brand.getDescription())
                        .execute()
        );
    }

    public void delete(int id) {
        String sql = "DELETE FROM brands WHERE brand_id = :id";
        get().useHandle(h ->
                h.createUpdate(sql)
                        .bind("id", id)
                        .execute()
        );
    }
}