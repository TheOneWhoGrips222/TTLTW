package com.webthietbibep.model;

import java.util.List;

public class Ecosystems {
    private int id;
    private String name;
    private String image;
    private List<Product> products;
    public Ecosystems() {
    }

    public Ecosystems(int id, String name, String image) {
        this.id = id;
        this.name = name;
        this.image = image;
    }

    // Getter & Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public List<Product> getProducts() {
        return products;
    }

    public void setProducts(List<Product> products) {
        this.products = products;
    }
}