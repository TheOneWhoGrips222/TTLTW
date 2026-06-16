package com.webthietbibep.dao;

import com.webthietbibep.cart.CartItem;
import com.webthietbibep.cart.CartItemCombo;

import java.util.List;

public class CartDao extends BaseDao{
    public Integer getCartIdByUserId(int userId) {
        return get().withHandle(h -> {
            return h.createQuery("SELECT id FROM carts WHERE user_id = :userId")
                    .bind("userId", userId)
                    .mapTo(Integer.class)
                    .findOne().orElse(null);
        });
    }

    public int createCart(int userId) {
        return get().withHandle(h -> {
            return h.createUpdate("INSERT INTO carts (user_id) VALUES (:userId)")
                    .bind("userId", userId)
                    .executeAndReturnGeneratedKeys()
                    .mapTo(Integer.class)
                    .one();
        });
    }

    public List<CartItem> getCartItems(int cartId) {
        return get().withHandle(h -> {
            return h.createQuery("SELECT product_id, quantity FROM cart_items WHERE cart_id = :cartId")
                    .bind("cartId", cartId)
                    .mapToBean(CartItem.class)
                    .list();
        });
    }

    public List<CartItemCombo> getCartItemCombos(int cartId) {
        return get().withHandle(h -> {
            return h.createQuery("SELECT combo_id, quantity FROM cart_item_combos WHERE cart_id = :cartId")
                    .bind("cartId", cartId)
                    .mapToBean(CartItemCombo.class)
                    .list();
        });
    }

    public int insertProduct(int cartId, int productId, int quantity) {
        return get().withHandle(h -> {
            return h.createUpdate("INSERT INTO cart_items (cart_id, product_id, quantity) VALUES (:cartId, :productId, :quantity)")
                    .bind("cartId", cartId)
                    .bind("productId", productId)
                    .bind("quantity", quantity)
                    .execute();
        });
    }

    public int insertCombo(int cartId, int comboId, int quantity) {
        return get().withHandle(h -> {
            return h.createUpdate("INSERT INTO cart_item_combos (cart_id, combo_id, quantity) VALUES (:cartId, :comboId, :quantity)")
                    .bind("cartId", cartId)
                    .bind("comboId", comboId)
                    .bind("quantity", quantity)
                    .execute();
        });
    }

    public int updateProductQuantity(int cartId, int productId, int quantity) {
        return get().withHandle(h -> {
            return h.createUpdate("UPDATE cart_items SET quantity = :quantity WHERE cart_id = :cartId AND product_id = :productId")
                    .bind("quantity", quantity)
                    .bind("cartId", cartId)
                    .bind("productId", productId)
                    .execute();
        });
    }

    public int updateComboQuantity(int cartId, int comboId, int quantity) {
        return get().withHandle(h -> {
            return h.createUpdate("UPDATE cart_item_combos SET quantity = :quantity WHERE cart_id = :cartId AND combo_id = :comboId")
                    .bind("quantity", quantity)
                    .bind("cartId", cartId)
                    .bind("comboId", comboId)
                    .execute();
        });
    }

    public int deleteProduct(int cartId, int productId) {
        return get().withHandle(h -> {
            return h.createUpdate("DELETE FROM cart_items WHERE cart_id = :cartId AND product_id = :productId")
                    .bind("cartId", cartId)
                    .bind("productId", productId)
                    .execute();
        });
    }

    public int deleteCombo(int cartId, int comboId) {
        return get().withHandle(h -> {
            return h.createUpdate("DELETE FROM cart_item_combos WHERE cart_id = :cartId AND combo_id = :comboId")
                    .bind("cartId", cartId)
                    .bind("comboId", comboId)
                    .execute();
        });
    }

    public int deleteAllProducts(int cartId) {
        return get().withHandle(h -> {
            return h.createUpdate("DELETE FROM cart_items WHERE cart_id = :cartId")
                    .bind("cartId", cartId)
                    .execute();
        });
    }

    public int deleteAllCombos(int cartId) {
        return get().withHandle(h -> {
            return h.createUpdate("DELETE FROM cart_item_combos WHERE cart_id = :cartId")
                    .bind("cartId", cartId)
                    .execute();
        });
    }
    public Integer checkProductCart(int cartId, int productId) {
        return get().withHandle(h -> {
            return h.createQuery("SELECT quantity FROM cart_items WHERE cart_id = :cartId AND product_id = :productId")
                    .bind("cartId", cartId)
                    .bind("productId", productId)
                    .mapTo(Integer.class)
                    .findOne().orElse(null);
        });
    }

    public Integer checkComboCart(int cartId, int comboId) {
        return get().withHandle(h -> {
            return h.createQuery("SELECT quantity FROM cart_item_combos WHERE cart_id = :cartId AND combo_id = :comboId")
                    .bind("cartId", cartId)
                    .bind("comboId", comboId)
                    .mapTo(Integer.class)
                    .findOne().orElse(null);
        });
    }
}