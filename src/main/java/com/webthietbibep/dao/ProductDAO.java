package com.webthietbibep.dao;

import com.webthietbibep.db.JDBIConnector;
import com.webthietbibep.model.Product;
import org.jdbi.v3.core.statement.PreparedBatch;

import java.util.List;

public class ProductDAO extends BaseDao {

    public List<Product> getBestSellers() {
        return get().withHandle(h -> {

            String sql = """
                SELECT p.*, SUM(o.quantity) AS TongSoLuongDaBan
                FROM order_items o 
                JOIN products p ON p.product_id = o.product_id
                GROUP BY p.product_id, p.product_name, p.description, p.price, p.image, 
                         p.category_id, p.brand_id, p.stock_quantity, p.created_at
                ORDER BY SUM(o.quantity) DESC
                LIMIT 2
            """;
            return h.createQuery(sql).mapToBean(Product.class).list();
        });
    }


    public void inserts(List<Product> products) {
        String sql = """
            INSERT INTO products (category_id, product_name, description, price, stock_quantity, image, brand_id, created_at)
            VALUES (:category_id, :product_name, :description, :price, :stock_quantity, :image, :brand_id, NOW())
        """;

        get().useHandle(h -> {
            PreparedBatch batch = h.prepareBatch(sql);
            for (Product p : products) {
                batch.bindBean(p).add();
            }
            batch.execute();
        });
    }

    public List<Product> getListProduct() {
        return get().withHandle(h ->
                h.createQuery("SELECT * FROM products ORDER BY product_id DESC")
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public Product getProduct(int id){
        return get().withHandle(h ->
                h.createQuery("SELECT * FROM products WHERE product_id = :id")
                        .bind("id",id)
                        .mapToBean(Product.class)
                        .stream().findFirst().orElse(null)
        );
    }

    public int insert(Product product) {
        String sql = """
            INSERT INTO products (category_id, product_name, description, price, stock_quantity, brand_id, image, created_at)
            VALUES (:category_id, :product_name, :description, :price, :stock_quantity, :brand_id, :image, NOW())
        """;

        return get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(product)
                        .execute()
        );
    }

    public int update(Product product) {
        String sql = """
            UPDATE products 
            SET category_id = :category_id,
                product_name = :product_name,
                description = :description,
                price = :price,
                stock_quantity = :stock_quantity,
                brand_id = :brand_id,
                image = :image
            WHERE product_id = :product_id
        """;

        return get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(product)
                        .execute()
        );
    }

    public void delete(int id) {
        get().useHandle(handle ->
                handle.createUpdate("DELETE FROM products WHERE product_id = :id")
                        .bind("id", id)
                        .execute()
        );
    }

    public List<Product> getProductsFilter(
            String priceRange,
            String sort,
            String[] brands,
            Integer categoryId,
            int page,
            int pageSize
    ) {
        StringBuilder sql = new StringBuilder("""
            SELECT
                p.product_id,
                p.category_id,
                p.product_name,
                p.description,
                p.price,
                p.stock_quantity,
                p.brand_id,
                p.image,
                p.created_at
            FROM products p
            WHERE 1=1
        """);

        if (categoryId != null) {
            sql.append(" AND p.category_id = :categoryId");
        }

        if (priceRange != null) {
            switch (priceRange) {
                case "1" -> sql.append(" AND p.price < 5000000");
                case "2" -> sql.append(" AND p.price BETWEEN 5000000 AND 10000000");
                case "3" -> sql.append(" AND p.price BETWEEN 10000000 AND 20000000");
                case "4" -> sql.append(" AND p.price > 20000000");
            }
        }


        if (brands != null && brands.length > 0 && !brands[0].isBlank() ) {
            sql.append(" AND p.brand_id IN (<brands>)");
        }

        if ("price_asc".equals(sort)) {
            sql.append(" ORDER BY p.price ASC");
        } else if ("price_desc".equals(sort)) {
            sql.append(" ORDER BY p.price DESC");
        } else {
            sql.append(" ORDER BY p.created_at DESC");
        }
        sql.append(" LIMIT :limit OFFSET :offset");

        int offset = (page - 1) * pageSize;

        return get().withHandle(h -> {
            var query = h.createQuery(sql.toString())
                    .bind("limit", pageSize)
                    .bind("offset", offset);

            if (categoryId != null) {
                query.bind("categoryId", categoryId);
            }
            if (brands != null && brands.length > 0 && !brands[0].isBlank()) {
                query.bindList("brands", brands);
            }

            return query.mapToBean(Product.class).list();
        });
    }

    public int countProducts(
            String priceRange,
            String[] brands,
            Integer categoryId
    ) {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) FROM products p WHERE 1=1
        """);

        if (categoryId != null) {
            sql.append(" AND p.category_id = :categoryId");
        }

        if (priceRange != null) {
            switch (priceRange) {
                case "1" -> sql.append(" AND p.price < 5000000");
                case "2" -> sql.append(" AND p.price BETWEEN 5000000 AND 10000000");
                case "3" -> sql.append(" AND p.price BETWEEN 10000000 AND 20000000");
                case "4" -> sql.append(" AND p.price > 20000000");
            }
        }

        if (brands != null && brands.length > 0 && !brands[0].isBlank()) {
            sql.append(" AND p.brand_id IN (<brands>)");
        }

        return get().withHandle(h -> {
            var query = h.createQuery(sql.toString());

            if (categoryId != null) {
                query.bind("categoryId", categoryId);
            }
            if (brands != null && brands.length > 0 && !brands[0].isBlank()) {
                query.bindList("brands", brands);
            }

            return query.mapTo(Integer.class).one();
        });
    }

    public List<Product> getRelatedProducts(int categoryId, int excludeId) {
        return JDBIConnector.get().withHandle(handle ->
                handle.createQuery("""
                    SELECT * FROM products
                    WHERE category_id = :cid
                      AND product_id != :pid
                    LIMIT 6
                """)
                        .bind("cid", categoryId)
                        .bind("pid", excludeId)
                        .mapToBean(Product.class)
                        .list()
        );
    }
        public Product getById(int id) {
            String sql = """
            SELECT 
                product_id,
                product_name,
                image,
                price
            FROM products
            WHERE product_id = :id
        """;

            return get().withHandle(h ->
                    h.createQuery(sql)
                            .bind("id", id)
                            .mapToBean(Product.class)
                            .findOne()
                            .orElse(null)
            );
        }

    public List<Product> getByBrandId(int brandId) {
        String sql = "SELECT * FROM products WHERE brand_id = :brandId";
        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("brandId", brandId)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public int countAll() {
        return get().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM products")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public List<Product> findAll(int limit, int offset) {
        String sql = """
        SELECT * FROM products
        ORDER BY product_id DESC
        LIMIT :limit OFFSET :offset
    """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("limit", limit)
                        .bind("offset", offset)
                        .mapToBean(Product.class)
                        .list()
        );
    }
    // Thêm đoạn code này vào trong class ProductDAO
    public List<Product> searchByNameLimit(String keyword, int limit) {
        String sql = """
        SELECT * FROM products 
        WHERE product_name LIKE :keyword 
        ORDER BY product_id DESC 
        LIMIT :limit
    """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("keyword", "%" + keyword + "%") // Tìm kiếm chứa từ khóa
                        .bind("limit", limit)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> searchByName(String keyword) {
        String sql = "SELECT * FROM products WHERE product_name LIKE :keyword";
        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("keyword", "%" + keyword + "%")
                        .mapToBean(Product.class)
                        .list()
        );
    }
}

