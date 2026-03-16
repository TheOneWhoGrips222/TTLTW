package com.webthietbibep.model;

import java.io.Serializable;
import java.util.List;

public class Showroom implements Serializable {
    private int id ;
    private String name;
    private String content;
    private String address;
    private String phone;
    private String email;
    private String time ;
    private String map_url;
    private List<ShowroomImage> images;

    public Showroom() {
    }

    public Showroom(int id, String name, String content, String address, String phone, String email, String time, String map_url) {
        this.id = id;
        this.name = name;
        this.content = content;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.time = time;
        this.map_url = map_url;

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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getMap_url() {
        return map_url;
    }

    public void setMap_url(String map_url) {
        this.map_url = map_url;
    }

    public List<ShowroomImage> getImages() {
        return images;
    }

    public void setImages(List<ShowroomImage> images) {
        this.images = images;
    }
}
