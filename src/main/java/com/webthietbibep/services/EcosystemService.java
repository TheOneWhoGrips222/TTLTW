package com.webthietbibep.services;

import com.webthietbibep.db.JDBIConnector;
import com.webthietbibep.model.Ecosystems;
import com.webthietbibep.model.Product;

import java.util.List;

public class EcosystemService {


    public List<Ecosystems> getAll() {
        return JDBIConnector.get().withHandle(handle ->
                handle.createQuery("SELECT id, name, image FROM ecosystems")
                        .mapToBean(Ecosystems.class)
                        .list()
        );
    }

    public Ecosystems getEcosystemById(int id) {
        return JDBIConnector.get().withHandle(handle ->
                handle.createQuery("SELECT id, name, image FROM ecosystems WHERE id = ?")
                        .bind(0, id)
                        .mapToBean(Ecosystems.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public void insert(Ecosystems eco) {
        JDBIConnector.get().useHandle(handle ->
                handle.createUpdate("INSERT INTO ecosystems (name, image) VALUES (?, ?)")
                        .bind(0, eco.getName())
                        .bind(1, eco.getImage())
                        .execute()
        );
    }

    public void update(Ecosystems eco) {
        JDBIConnector.get().useHandle(handle ->
                handle.createUpdate("UPDATE ecosystems SET name = ?, image = ? WHERE id = ?")
                        .bind(0, eco.getName())
                        .bind(1, eco.getImage())
                        .bind(2, eco.getId())
                        .execute()
        );
    }

    public void delete(int id) {
        JDBIConnector.get().useHandle(handle -> {
            handle.createUpdate("DELETE FROM product_ecosystems WHERE id = ?").bind(0, id).execute();
            handle.createUpdate("DELETE FROM ecosystems WHERE id = ?").bind(0, id).execute();
        });
    }

    public List<Product> getProductsByEcosystemId(int ecoId) {
        String sql = "SELECT p.* FROM products p " +
                "JOIN product_ecosystems pe ON p.product_id = pe.product_id " +
                "WHERE pe.ecosystem_id = ?";

        return JDBIConnector.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, ecoId)
                        .mapToBean(Product.class)
                        .list()
        );
    }


    public List<Product> searchProductsByName(String keyword) {
        String sql = "SELECT * FROM products WHERE product_name LIKE ? LIMIT 10";

        return JDBIConnector.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, "%" + keyword + "%")
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public void addProductToEcosystem(int ecoId, int prodId) {
        String sql = "INSERT INTO product_ecosystems (id, product_id) VALUES (?, ?)";

        JDBIConnector.get().useHandle(handle -> {
            try {
                handle.createUpdate(sql).bind(0, ecoId).bind(1, prodId).execute();
                System.out.println("DEBUG: Đã insert thành công EcoID=" + ecoId + ", ProdID=" + prodId);
            } catch (Exception e) {
                System.err.println("DEBUG: Lỗi insert product_ecosystems: " + e.getMessage());
            }
        });
    }
    public void removeProductFromEcosystem(int ecoId, int prodId) {
        String sql = "DELETE FROM product_ecosystems WHERE id = ? AND product_id = ?";
        JDBIConnector.get().useHandle(handle ->
                handle.createUpdate(sql).bind(0, ecoId).bind(1, prodId).execute()
        );
    }
}