package com.webthietbibep.model;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class ProductComment implements Serializable {
    private int comment_id;
    private int user_id;
    private int product_id;
    private String content;
    private LocalDateTime created_at;
    private String username;

    public ProductComment(int comment_id, LocalDateTime created_at, String content, int product_id, int user_id, String username) {
        this.comment_id = comment_id;
        this.created_at = created_at;
        this.content = content;
        this.product_id = product_id;
        this.user_id = user_id;
        this.username = username;
    }

    public ProductComment() {
    }

    public int getComment_id() {
        return comment_id;
    }

    public void setComment_id(int comment_id) {
        this.comment_id = comment_id;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getCreatedAtFormat() {
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy - HH:mm");
        return created_at.format(fmt);
    }

}
