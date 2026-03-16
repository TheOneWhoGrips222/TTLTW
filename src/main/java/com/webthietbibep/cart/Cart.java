package com.webthietbibep.cart;

import com.webthietbibep.model.Product;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

public class Cart implements Serializable {
    Map<Integer, CartItem> data = new HashMap<Integer, CartItem>();

    public Cart() {
    }

    public Cart(Map<Integer, CartItem> data) {
        this.data = data;
    }

    public void addItem(Product product, int quantity) {
        if(quantity <= 0) {
            quantity = 1;
        }
        if(!data.containsKey(product.getProduct_id())){
            data.put(product.getProduct_id(),new CartItem(product,quantity,product.getPrice() ));
        }
        else {
            data.get(product.getProduct_id()).upQuantity(quantity);
        }
    }

    public void delItem(int id ) {
        data.remove(id);
    }
    public List<CartItem>  delAllItems() {
        if(this.data != null ) {
            this.data.clear();
        }
        return new ArrayList<>();
    }
    public List<CartItem> getItems(){
        return new ArrayList<>(data.values());
    }
    public int getTotalQuantity(){
        AtomicInteger total =  new AtomicInteger();
        data.values().forEach(item->total.addAndGet(item.getQuantity()));
        return  total.get();
    }

    public double getTotal(){
        AtomicReference<Double> sum = new AtomicReference<>((double)0);
        data.values().forEach(item->sum.updateAndGet(v -> v + (item.getPrice() * item.getQuantity())));
        return  sum.get();
    }

    public Map<Integer, CartItem> getData() {
        return data;
    }

    public void setData(Map<Integer, CartItem> data) {
        this.data = data;
    }

    public String getFormatTotal(){
        return CartItem.Format(getTotal());
    }
}
