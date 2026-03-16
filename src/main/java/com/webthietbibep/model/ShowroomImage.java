package com.webthietbibep.model;

import java.io.Serializable;

public class ShowroomImage implements Serializable {
    private String id;
    private String showroom_id;
    private String image;

    public ShowroomImage() {
    }

    public ShowroomImage(String id, String showroom_id, String image) {
        this.id = id;
        this.showroom_id = showroom_id;
        this.image = image;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getShowroom_id() {
        return showroom_id;
    }

    public void setShowroom_id(String showroom_id) {
        this.showroom_id = showroom_id;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
