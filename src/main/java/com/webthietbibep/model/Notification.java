package com.webthietbibep.model;

import java.io.Serializable;
import java.time.LocalDateTime;


public class Notification implements Serializable {

    public enum Type {
        NEW_ORDER,
        LOW_STOCK,
        NEW_USER,
        REVENUE_MILESTONE,
        ORDER_CANCELLED,
        PENDING_PAYMENT
    }

    private String id;
    private Type type;
    private String title;
    private String message;
    private String link;
    private String icon;
    private String colorClass;
    private LocalDateTime createdAt;
    private int refId;
    private boolean isRead;

    public Notification() {}

    public Notification(Type type, String title, String message, String link,
                        String icon, String colorClass, LocalDateTime createdAt, int refId) {
        this.id = type.name() + "_" + refId;
        this.type = type;
        this.title = title;
        this.message = message;
        this.link = link;
        this.icon = icon;
        this.colorClass = colorClass;
        this.createdAt = createdAt;
        this.refId = refId;
        this.isRead = false;
    }


    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public Type getType() { return type; }
    public void setType(Type type) { this.type = type; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public String getColorClass() { return colorClass; }
    public void setColorClass(String colorClass) { this.colorClass = colorClass; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public int getRefId() { return refId; }
    public void setRefId(int refId) { this.refId = refId; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }
}