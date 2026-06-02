package com.webthietbibep.model;

public class ChartData {
    private String date;
    private double value;
    private int    orderCount;
    private int    productsSold;

    public ChartData() {}

    public ChartData(String date, double value) {
        this.date  = date;
        this.value = value;
    }

    public String getDate()          { return date; }
    public void   setDate(String d)  { this.date = d; }

    public double getValue()           { return value; }
    public void   setValue(double v)   { this.value = v; }

    public int  getOrderCount()        { return orderCount; }
    public void setOrderCount(int c)   { this.orderCount = c; }

    public int  getProductsSold()      { return productsSold; }
    public void setProductsSold(int p) { this.productsSold = p; }
}