package com.webthietbibep.dao;

import com.webthietbibep.model.Supplier;

import java.util.List;

public class SupplierDAO extends BaseDao {

    public List<Supplier> getAll() {
        String sql = "SELECT * FROM suppliers ORDER BY supplier_id DESC";
        return get().withHandle(h ->
                h.createQuery(sql).mapToBean(Supplier.class).list()
        );
    }

    public Supplier getById(int id) {
        String sql = "SELECT * FROM suppliers WHERE supplier_id = :id";
        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(Supplier.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public void insert(Supplier s) {
        String sql = """
            INSERT INTO suppliers (company_name, contact_name, phone, email, address, website, note)
            VALUES (:company_name, :contact_name, :phone, :email, :address, :website, :note)
        """;
        get().useHandle(h ->
                h.createUpdate(sql)
                        .bind("company_name", s.getCompany_name())
                        .bind("contact_name", s.getContact_name())
                        .bind("phone",        s.getPhone())
                        .bind("email",        s.getEmail())
                        .bind("address",      s.getAddress())
                        .bind("website",      s.getWebsite())
                        .bind("note",         s.getNote())
                        .execute()
        );
    }

    public void update(Supplier s) {
        String sql = """
            UPDATE suppliers
            SET company_name = :company_name,
                contact_name = :contact_name,
                phone        = :phone,
                email        = :email,
                address      = :address,
                website      = :website,
                note         = :note
            WHERE supplier_id = :supplier_id
        """;
        get().useHandle(h ->
                h.createUpdate(sql)
                        .bind("company_name", s.getCompany_name())
                        .bind("contact_name", s.getContact_name())
                        .bind("phone",        s.getPhone())
                        .bind("email",        s.getEmail())
                        .bind("address",      s.getAddress())
                        .bind("website",      s.getWebsite())
                        .bind("note",         s.getNote())
                        .bind("supplier_id",  s.getSupplier_id())
                        .execute()
        );
    }

    public void delete(int id) {
        get().useHandle(h ->
                h.createUpdate("DELETE FROM suppliers WHERE supplier_id = :id")
                        .bind("id", id)
                        .execute()
        );
    }
}