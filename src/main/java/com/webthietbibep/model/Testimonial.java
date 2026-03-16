package com.webthietbibep.model;

import java.io.Serializable;

public class Testimonial implements Serializable {
    private int id ;
    private String content;
    private String author_name;
    private String author_location;
    private boolean is_approved;

    public Testimonial() {
    }

    public Testimonial(int id, String content, String author_name, String author_location, boolean is_approved) {
        this.id = id;
        this.content = content;
        this.author_name = author_name;
        this.author_location = author_location;
        this.is_approved = is_approved;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getAuthor_name() {
        return author_name;
    }

    public void setAuthor_name(String author_name) {
        this.author_name = author_name;
    }

    public String getAuthor_location() {
        return author_location;
    }

    public void setAuthor_location(String author_location) {
        this.author_location = author_location;
    }

    public boolean isIs_approved() {
        return is_approved;
    }

    public void setIs_approved(boolean is_approved) {
        this.is_approved = is_approved;
    }
}
