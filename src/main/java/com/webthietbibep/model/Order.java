package com.webthietbibep.model;

import com.webthietbibep.cart.CartItem;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Order implements Serializable {
    private int order_id;
    private int user_id;
    private int address_id;
    private double total_amount;
    private String status;
    private String payment_method;
    private LocalDateTime created_at;
    private String note;
    private int voucher_id;
    private String userName;
    private String addressDetail;
    public Order() {
    }

    public Order(int order_id, int address_id, int user_id, double total_amount, String status, String payment_method, LocalDateTime created_at, String note, int voucher_id) {
        this.order_id = order_id;
        this.address_id = address_id;
        this.user_id = user_id;
        this.total_amount = total_amount;
        this.status = status;
        this.payment_method = payment_method;
        this.created_at = created_at;
        this.note = note;
        this.voucher_id = voucher_id;
    }

    public int getOrder_id() {
        return order_id;
    }

    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }

    public int getVoucher_id() {
        return voucher_id;
    }

    public void setVoucher_id(int voucher_id) {
        this.voucher_id = voucher_id;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }

    public String getPayment_method() {
        return payment_method;
    }

    public void setPayment_method(String payment_method) {
        this.payment_method = payment_method;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(double total_amount) {
        this.total_amount = total_amount;
    }

    public int getAddress_id() {
        return address_id;
    }

    public void setAddress_id(int address_id) {
        this.address_id = address_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }
    public String getStatusText() {
        return switch (status) {
            case "CHO_THANH_TOAN" -> "Chờ thanh toán";
            case "CHO_XAC_NHAN" -> "Chờ xác nhận";
            case "VAN_CHUYEN" -> "Vận chuyển";
            case "CHO_GIAO_HANG" -> "Chờ giao hàng";
            case "HOAN_THANH" -> "Hoàn thành";
            case "DA_HUY" -> "Đã huỷ";
            default -> status;
        };
    }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getAddressDetail() { return addressDetail; }
    public void setAddressDetail(String addressDetail) { this.addressDetail = addressDetail; }

    public String getFormattedTotal() {
        return CartItem.Format(total_amount);
    }

}
