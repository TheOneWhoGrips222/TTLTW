package com.webthietbibep.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Supplier implements Serializable {

    private int supplier_id;
    private String company_name;
    private String contact_name;
    private String phone;
    private String email;
    private String address;
    private String website;
    private String note;
    private LocalDateTime created_at;

    public Supplier() {}

    public int getSupplier_id() { return supplier_id; }
    public void setSupplier_id(int supplier_id) { this.supplier_id = supplier_id; }

    public String getCompany_name() { return company_name; }
    public void setCompany_name(String company_name) { this.company_name = company_name; }

    public String getContact_name() { return contact_name; }
    public void setContact_name(String contact_name) { this.contact_name = contact_name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getWebsite() { return website; }
    public void setWebsite(String website) { this.website = website; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public LocalDateTime getCreated_at() { return created_at; }
    public void setCreated_at(LocalDateTime created_at) { this.created_at = created_at; }
}