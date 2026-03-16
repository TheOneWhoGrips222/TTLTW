    package com.webthietbibep.model;

    import java.io.Serializable;

    public class OrderItem implements Serializable {
        private int order_item_id;
        private int order_id;
        private int product_id;
        private int quantity;
        private double price_at_purchase;
        private String productName;
        private String productImage;
        public OrderItem() {
        }

        public OrderItem(int order_item_id,int order_id, double price_at_purchase, int quantity, int product_id) {
            this.order_item_id = order_item_id;
            this.order_id = order_id;
            this.price_at_purchase = price_at_purchase;
            this.quantity = quantity;
            this.product_id = product_id;
        }

        public int getOrder_item_id() {
            return order_item_id;
        }

        public void setOrder_item_id(int order_item_id) {
            this.order_item_id = order_item_id;
        }

        public int getOrder_id() {
            return order_id;
        }

        public void setOrder_id(int order_id) {
            this.order_id = order_id;
        }

        public double getPrice_at_purchase() {
            return price_at_purchase;
        }

        public void setPrice_at_purchase(double price_at_purchase) {
            this.price_at_purchase = price_at_purchase;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public int getProduct_id() {
            return product_id;
        }

        public void setProduct_id(int product_id) {
            this.product_id = product_id;
        }
        public String getProductName() { return productName; }
        public void setProductName(String productName) { this.productName = productName; }

        public String getProductImage() { return productImage; }
        public void setProductImage(String productImage) { this.productImage = productImage; }

        public double getTotalPrice() {
            return this.quantity * this.price_at_purchase;
        }
    }
