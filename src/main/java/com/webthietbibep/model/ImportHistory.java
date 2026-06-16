package com.webthietbibep.model;

import java.time.LocalDateTime;

public class ImportHistory {

    private int           importId;
    private int           productId;
    private String        productName;
    private String        productImage;
    private Integer       supplierId;
    private String        supplierName;
    private int           quantity;
    private Double        unitPrice;
    private Double        totalCost;
    private String        note;
    private Integer       importedBy;
    private String        importedByName;
    private LocalDateTime importedAt;

    public ImportHistory() {}

    public int getImportId() { return importId; }
    public void setImportId(int importId) { this.importId = importId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }

    public Integer getSupplierId() { return supplierId; }
    public void setSupplierId(Integer supplierId) { this.supplierId = supplierId; }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(Double unitPrice) { this.unitPrice = unitPrice; }

    public Double getTotalCost() { return totalCost; }
    public void setTotalCost(Double totalCost) { this.totalCost = totalCost; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Integer getImportedBy() { return importedBy; }
    public void setImportedBy(Integer importedBy) { this.importedBy = importedBy; }

    public String getImportedByName() { return importedByName; }
    public void setImportedByName(String importedByName) { this.importedByName = importedByName; }

    public LocalDateTime getImportedAt() { return importedAt; }
    public void setImportedAt(LocalDateTime importedAt) { this.importedAt = importedAt; }
}
