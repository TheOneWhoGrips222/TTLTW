package com.webthietbibep.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class Promotion implements Serializable {
    private int id ;
    private String name_promotion;
    private String title ;
    private String content ;
    private String tag;
    private LocalDate endTime;

    public Promotion() {
    }

    public Promotion(int id, String name_promotion, String title, String content, String tag, LocalDate endTime) {
        this.id = id;
        this.name_promotion = name_promotion;
        this.title = title;
        this.content = content;
        this.tag = tag;
        this.endTime = endTime;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName_promotion() {
        return name_promotion;
    }

    public void setName_promotion(String name_promotion) {
        this.name_promotion = name_promotion;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public LocalDate getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDate endTime) {
        this.endTime = endTime;
    }
    public  String formatDate(LocalDate ld){
        DateTimeFormatter dinhDang = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return ld.format(dinhDang);
    }
}
