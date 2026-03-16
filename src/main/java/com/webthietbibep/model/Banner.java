package com.webthietbibep.model;

public class Banner {
    private int id ;
    private String title ;
    private String description;
    private String image ;
    private String link_url;
    private int sort_order;
    public byte is_active;

    public Banner() {
    }

    public Banner(int id, String title, String description, String image, String link_url, int sort_order, byte is_active) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.image = image;
        this.is_active = is_active;
        this.link_url = link_url;
        this.sort_order = sort_order;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public byte getIsActive() {
        return is_active;
    }

    public void setIsActive(byte isActive) {
        this.is_active = isActive;
    }

    public String getLink_url() {
        return link_url;
    }

    public void setLink_url(String link_url) {
        this.link_url = link_url;
    }

    public int getSort_order() {
        return sort_order;
    }

    public void setSort_order(int sort_order) {
        this.sort_order = sort_order;
    }
}
