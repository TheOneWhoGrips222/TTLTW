package com.webthietbibep.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Wishlist implements Serializable {
    private int user_id;
    private int product_id;
    private LocalDateTime created_at;

    public Wishlist() {}

    public Wishlist(int user_id, int product_id, LocalDateTime created_at) {
        this.user_id = user_id;
        this.product_id = product_id;
        this.created_at = created_at;
    }

    public int getUser_id() { return user_id; }
    public void setUser_id(int user_id) { this.user_id = user_id; }

    public int getProduct_id() { return product_id; }
    public void setProduct_id(int product_id) { this.product_id = product_id; }

    public LocalDateTime getCreated_at() { return created_at; }
    public void setCreated_at(LocalDateTime created_at) { this.created_at = created_at; }
}