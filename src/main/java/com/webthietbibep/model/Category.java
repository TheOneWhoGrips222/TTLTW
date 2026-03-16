package com.webthietbibep.model;

import java.io.Serializable;

public class Category implements Serializable {
    private int category_id;
    private String category_name;
    private String logo; // 1. Thêm thuộc tính logo
    public Category() {
    }
    public Category(int category_id, String category_name, String logo) {
        this.category_id = category_id;
        this.category_name = category_name;
        this.logo = logo;
    }

    public int getCategory_id() { return category_id; }
    public void setCategory_id(int category_id) { this.category_id = category_id; }

    public String getCategory_name() { return category_name; }
    public void setCategory_name(String category_name) { this.category_name = category_name; }

    public String getLogo() { return logo; }
    public void setLogo(String logo) { this.logo = logo; }

    @Override
    public String toString() {
        return "Category{" +
                "id=" + category_id +
                ", name='" + category_name + '\'' +
                ", logo='" + logo + '\'' +
                '}';
    }
}