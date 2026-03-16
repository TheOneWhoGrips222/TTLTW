package com.webthietbibep.cart;

import com.webthietbibep.model.Product;

import java.io.Serializable;
import java.text.NumberFormat;
import java.util.Locale;

public class CartItem implements Serializable {
    private Product product;
    private int quantity;
    private double price;


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


    public static String Format(double price) {
        NumberFormat vn = NumberFormat.getInstance(new Locale("vi", "VN"));
        return vn.format(price) + " đ";
    }


    public String getFormattedTotal(){
        return Format(this.price * this.quantity);
    }

}
