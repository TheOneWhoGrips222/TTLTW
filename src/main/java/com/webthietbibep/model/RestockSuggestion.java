package com.webthietbibep.model;

public class RestockSuggestion {

    private int    productId;
    private String productName;
    private String productImage;
    private int    stockQuantity;
    private double avgSoldPerDay;
    private int    daysUntilEmpty;
    private int    suggestedQuantity;
    private String urgencyLevel;

    public RestockSuggestion() {}

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public double getAvgSoldPerDay() { return avgSoldPerDay; }
    public void setAvgSoldPerDay(double avgSoldPerDay) { this.avgSoldPerDay = avgSoldPerDay; }

    public int getDaysUntilEmpty() { return daysUntilEmpty; }
    public void setDaysUntilEmpty(int daysUntilEmpty) { this.daysUntilEmpty = daysUntilEmpty; }

    public int getSuggestedQuantity() { return suggestedQuantity; }
    public void setSuggestedQuantity(int suggestedQuantity) { this.suggestedQuantity = suggestedQuantity; }

    public String getUrgencyLevel() { return urgencyLevel; }
    public void setUrgencyLevel(String urgencyLevel) { this.urgencyLevel = urgencyLevel; }
}