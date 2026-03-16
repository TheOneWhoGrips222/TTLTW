package com.webthietbibep.model;

public class ChartData {
    private String date;
    private double value;

    public ChartData() {}
    public ChartData(String date, double value) {
        this.date = date;
        this.value = value;
    }
    // Getters Setters
    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }
    public double getValue() { return value; }
    public void setValue(double value) { this.value = value; }
}