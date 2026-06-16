package com.webthietbibep.services;

import com.webthietbibep.cart.CartItem;
import com.webthietbibep.cart.CartItemCombo;
import com.webthietbibep.dao.CartDao;

import java.util.List;

public class CartService {
    CartDao cartDao = new CartDao();

    public Integer getCartIdByUserId(int userId) {
        return cartDao.getCartIdByUserId(userId);
    }

    public int createCart(int userId) {
        return cartDao.createCart(userId);
    }



    public int insertProduct(int cartId, int productId, int quantity, long time) {
        return cartDao.insertProduct(cartId, productId, quantity, time);
    }

    public int insertCombo(int cartId, int comboId, int quantity, long time) {
        return cartDao.insertCombo(cartId, comboId, quantity, time);
    }

    public int updateProductQuantity(int cartId, int productId, int quantity, long time) {
        return cartDao.updateProductQuantity(cartId, productId, quantity, time);
    }

    public int updateComboQuantity(int cartId, int comboId, int quantity, long time) {
        return cartDao.updateComboQuantity(cartId, comboId, quantity, time);
    }

    public int deleteProduct(int cartId, int productId) {
        return cartDao.deleteProduct(cartId, productId);
    }

    public int deleteCombo(int cartId, int comboId) {
        return cartDao.deleteCombo(cartId, comboId);
    }

    public int deleteAllProducts(int cartId) {
        return cartDao.deleteAllProducts(cartId);
    }

    public int deleteAllCombos(int cartId) {
        return cartDao.deleteAllCombos(cartId);
    }
    public List<CartItem> getCartItems(int cartId) {
        return cartDao.getCartItems(cartId);
    }

    public List<CartItemCombo> getCartItemCombos(int cartId) {
        return cartDao.getCartItemCombos(cartId);
    }
}