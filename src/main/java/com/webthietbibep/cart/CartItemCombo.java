package com.webthietbibep.cart;

import com.webthietbibep.model.Combo;

import java.io.Serializable;
import java.text.NumberFormat;
import java.util.Locale;

public class CartItemCombo implements Serializable {
    private Combo combo;
    private int quantity;
    private double price;
    private long time = System.currentTimeMillis();
    private boolean checkBox = true;
    public CartItemCombo() {
    }

    public CartItemCombo(Combo combo, int quantity, double price) {
        this.combo = combo;
        this.quantity = quantity;
        this.price = price;
    }

    public Combo getCombo() {
        return combo;
    }

    public void setCombo(Combo combo) {
        this.combo = combo;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public boolean isCheckBox() {
        return checkBox;
    }

    public void setCheckBox(boolean checkBox) {
        this.checkBox = checkBox;
    }

    public long getTime() {
        return time;
    }

    public void setTime(long time) {
        this.time = time;
    }

    public void setPrice(double price) {
        this.price = price;
    }
    public static String Format(double price) {
        NumberFormat vn = NumberFormat.getInstance(new Locale("vi", "VN"));
        return vn.format(price) + " đ";
    }
    public void upQuantity(int q){
        this.quantity += q ;
    }
}
