package com.webthietbibep.model;

import java.io.Serializable;

public class ProductFeature implements Serializable {
    private int featureId;
    private int productId;
    private String featureText;

    public ProductFeature(String featureText, int productId, int featureId) {
        this.featureText = featureText;
        this.productId = productId;
        this.featureId = featureId;
    }

    public ProductFeature() {
    }

    public int getFeatureId() {
        return featureId;
    }

    public void setFeatureId(int featureId) {
        this.featureId = featureId;
    }

    public String getFeatureText() {
        return featureText;
    }

    public void setFeatureText(String featureText) {
        this.featureText = featureText;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }
}
