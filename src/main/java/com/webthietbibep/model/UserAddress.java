package com.webthietbibep.model;

import java.io.Serializable;

public class UserAddress implements Serializable {
    private int address_id;
    private int user_id;

    private String receiver_name;
    private String phone;
    private String address_detail;
    private String ward;
    private String district;
    private String province;

    private boolean is_default;

    public UserAddress() {}

    // getter & setter
    public int getAddress_id() { return address_id; }
    public void setAddress_id(int address_id) { this.address_id = address_id; }

    public int getUser_id() { return user_id; }
    public void setUser_id(int user_id) { this.user_id = user_id; }

    public String getReceiver_name() { return receiver_name; }
    public void setReceiver_name(String receiver_name) { this.receiver_name = receiver_name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress_detail() { return address_detail; }
    public void setAddress_detail(String address_detail) { this.address_detail = address_detail; }

    public String getWard() { return ward; }
    public void setWard(String ward) { this.ward = ward; }

    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }

    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }

    public boolean isIs_default() { return is_default; }
    public void setIs_default(boolean is_default) { this.is_default = is_default; }
}
