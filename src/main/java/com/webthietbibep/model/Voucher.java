package com.webthietbibep.model;

import java.io.Serializable;
import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class Voucher implements Serializable {
    private String id;
    private String title;
    private String description;
    private int category_id;
    private String discountType;
    private double discountValue;
    private double minOrderValue;
    private int quantity;
    private LocalDateTime endDate;
    private int status;

    public Voucher() {
    }

    public Voucher(String id, String title, String description,int category_id, String discountType, double discountValue, double minOrderValue, int quantity, LocalDateTime endDate, int status) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minOrderValue = minOrderValue;
        this.quantity = quantity;
        this.endDate = endDate;
        this.status = status;
        this.category_id = category_id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public double getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(double minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public int getCategory_id() {
        return category_id;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
    public String getDiscountFormat() {
        if ("percentage".equalsIgnoreCase(this.discountType)) {
            return String.format("%.0f", discountValue) + " %";
        } else {
            NumberFormat vn = NumberFormat.getInstance(new Locale("vi", "VN"));
            return vn.format(this.discountValue) + " đ";
        }
    }
    public String getMinvalueFormat() {
        NumberFormat vn = NumberFormat.getInstance(new Locale("vi", "VN"));
        return vn.format(this.minOrderValue) + " đ";
    }
    public boolean isExpired() {
        if (this.endDate == null) {
            return true;
        }
        return LocalDateTime.now().isAfter(this.endDate);
    }
    public String getDateFormat() {
        if (this.endDate == null) {
            return "";
        }
        DateTimeFormatter c = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return this.endDate.format(c);
    }

}
