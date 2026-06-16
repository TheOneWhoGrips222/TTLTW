package com.webthietbibep.cart;

import com.webthietbibep.model.Product;

import java.io.Serializable;
import java.text.NumberFormat;
import java.util.Locale;

public class CartItem implements Serializable {
    private Product product;
    private int quantity;
    private double price;
    private long time = System.currentTimeMillis();
    private boolean checkBox = true;


    public CartItem() {
    }

    public CartItem(Product product, int quantity, double price) {
        this.product = product;
        this.quantity = quantity;
        this.price = price;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
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

    public void setPrice(double price) {
        this.price = price;
    }

    public void upQuantity(int q){
        this.quantity += q ;
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

    public static String Format(double price) {
        NumberFormat vn = NumberFormat.getInstance(new Locale("vi", "VN"));
        return vn.format(price) + " đ";
    }


    public String getFormattedTotal(){
        return Format(this.price * this.quantity);
    }
    public void setProduct_id(int product_id) {
        if (this.product == null) {
            this.product = new com.webthietbibep.model.Product();
        }
        this.product.setProduct_id(product_id);
    }
}
