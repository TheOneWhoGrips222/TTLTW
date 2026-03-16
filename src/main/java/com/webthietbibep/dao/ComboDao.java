package com.webthietbibep.dao;

import com.webthietbibep.model.Combo;
import com.webthietbibep.model.ComboAdvance;
import com.webthietbibep.model.Product;
import org.jdbi.v3.core.statement.PreparedBatch;

import java.util.List;

public class ComboDao extends BaseDao {

    public List<Combo> getListCombo() {
        return get().withHandle(h -> {
            return h.createQuery("select * from combos where is_active = 1").mapToBean(Combo.class).list();
        });
    }

    public List<Combo> getAllCombosForAdmin() {
        return get().withHandle(h -> {
            return h.createQuery("select * from combos").mapToBean(Combo.class).list();
        });
    }

    public Combo getCombo(int id) {
        return (Combo) get().withHandle(h -> {
            return h.createQuery("select * from combos where id = :id").bind("id", id).mapToBean(Combo.class).stream().findFirst().orElse(null);
        });
    }

    public List<ComboAdvance> getAdvanceCombo(int id) {
        return get().withHandle(h -> {
            return h.createQuery("select * from combo_advances where combo_id= :id").bind("id", id).mapToBean(ComboAdvance.class).list();
        });
    }

    public List<Product> getListComboProduct(int id) {
        return get().withHandle(h -> {
            return h.createQuery("select p.product_id, p.category_id, p.product_name as product_name, p.description, p.price, p.stock_quantity, p.brand_id, p.image, p.created_at from products p join comboitems c on p.product_id = c.product_id where c.combo_id = :id").bind("id", id).mapToBean(Product.class).list();
        });
    }

    public List<Combo> getListBaseCombo() {
        return get().withHandle(h -> {
            return h.createQuery("select * from combos where is_active = 1 order by  discountprice asc limit 2").mapToBean(Combo.class).list();
        });
    }

    // ham de xu ly trong trang admin

    public List<Integer> getProductIdsByComboId(int comboId) {
        return get().withHandle(h ->
                h.createQuery("SELECT product_id FROM comboitems WHERE combo_id = :id")
                        .bind("id", comboId)
                        .mapTo(Integer.class)
                        .list()
        );
    }

    // 2. Thêm mới Combo
    public int insert(Combo combo, String[] productIds) {
        return get().inTransaction(handle -> {
            // Bước 1: Insert bảng Combos và lấy ID tự sinh
            int comboId = handle.createUpdate("INSERT INTO combos (name, tag, content, baseprice, discountprice, image, gift, is_active, stock_quantity) " +
                            "VALUES (:name, :tag, :content, :baseprice, :discountprice, :image, :gift, :is_active, :stock_quantity)")
                    .bindBean(combo)
                    .executeAndReturnGeneratedKeys("id") // Cột khóa chính là 'id'
                    .mapTo(int.class)
                    .one();

            // Insert bảng ComboItems
            if (productIds != null && productIds.length > 0) {
                PreparedBatch batch = handle.prepareBatch("INSERT INTO comboitems (combo_id, product_id) VALUES (:comboId, :productId)");
                for (String pid : productIds) {
                    batch.bind("comboId", comboId)
                            .bind("productId", Integer.parseInt(pid))
                            .add();
                }
                batch.execute();
            }

            return comboId;
        });
    }

    // 3. Cập nhật Combo
    public void update(Combo combo, String[] productIds) {
        get().useTransaction(handle -> {
            // Bước 1: Update bảng Combos
            handle.createUpdate("UPDATE combos SET name=:name, tag=:tag, content=:content, baseprice=:baseprice, " +
                            "discountprice=:discountprice, image=:image, gift=:gift, is_active=:is_active, stock_quantity=:stock_quantity " +
                            "WHERE id=:id")
                    .bindBean(combo)
                    .execute();

            // Bước 2: Xử lý bảng trung gian
            handle.createUpdate("DELETE FROM comboitems WHERE combo_id = :id")
                    .bind("id", combo.getId())
                    .execute();

            if (productIds != null && productIds.length > 0) {
                PreparedBatch batch = handle.prepareBatch("INSERT INTO comboitems (combo_id, product_id) VALUES (:comboId, :productId)");
                for (String pid : productIds) {
                    batch.bind("comboId", combo.getId())
                            .bind("productId", Integer.parseInt(pid))
                            .add();
                }
                batch.execute();
            }
        });
    }
}