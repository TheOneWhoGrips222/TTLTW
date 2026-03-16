package com.webthietbibep.model;

import java.io.Serializable;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

public class Combo implements Serializable {
    private int id ;
    private String name;
    private String tag;
    private String content;
    private double baseprice;
    private double discountprice;
    private String image;
    List<ComboAdvance> listadvance;
    private String gift;
    private byte is_active;
    private int stock_quantity;
    private List<Product> products;

    public Combo() {
    }

    public Combo(int id, String name, String tag, String content, double baseprice, double discountprice, String image,  String gift, byte is_active, int stock_quantity) {
        this.id = id;
        this.name = name;
        this.tag = tag;
        this.content = content;
        this.baseprice = baseprice;
        this.discountprice = discountprice;
        this.image = image;

        this.gift = gift;
        this.is_active = is_active;
        this.stock_quantity = stock_quantity;

    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public double getBaseprice() {
        return baseprice;
    }

    public void setBaseprice(double baseprice) {
        this.baseprice = baseprice;
    }

    public double getDiscountprice() {
        return discountprice;
    }

    public void setDiscountprice(double discountprice) {
        this.discountprice = discountprice;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public List<ComboAdvance> getListadvance() {
        return listadvance;
    }

    public void setListadvance(List<ComboAdvance> listadvance) {
        this.listadvance = listadvance;
    }

    public String getGift() {
        return gift;
    }

    public int getStock_quantity() {
        return stock_quantity;
    }

    public void setStock_quantity(int stock_quantity) {
        this.stock_quantity = stock_quantity;
    }

    public void setGift(String gift) {
        this.gift = gift;
    }
    public  String getPriceFormat(double price) {
        NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        return nf.format(price);
    }

    public List<Product> getProducts() {
        return products;
    }

    public void setProducts(List<Product> products) {
        this.products = products;
    }

    public byte getIs_active() {
        return is_active;
    }

    public void setIs_active(byte is_active) {
        this.is_active = is_active;
    }
    public static  int getPercent(double base , double discount){
        if (base <= 0) return 0;
        double result = ((base - discount) / base) * 100;
        return (int) Math.round(result);
    }


}
