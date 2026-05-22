package com.webthietbibep.cart;

import com.webthietbibep.model.Combo;
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
    Map<Integer,CartItemCombo> data2 = new HashMap<>();

    public Cart() {
    }

    public Cart(Map<Integer, CartItem> data, Map<Integer,CartItemCombo> data2) {
        this.data = data;
        this.data2 = data2;
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
            data.get(product.getProduct_id()).setTime(System.currentTimeMillis());
        }
    }

    public void addItemCombo(Combo combo, int quantity) {
        if(quantity <= 0) {
            quantity = 1;
        }
        if(!data2.containsKey(combo.getId())){
            data2.put(combo.getId(),new CartItemCombo(combo,quantity,combo.getDiscountprice()));
        }
        else {
            data2.get(combo.getId()).upQuantity(quantity);
            data2.get(combo.getId()).setTime(System.currentTimeMillis());
        }
    }



    public void delItem(int id ) {
        data.remove(id);
    }
    public void delItemCombo(int id ) {
        data2.remove(id);
    }

    public List<CartItem>  delAllItems() {
        if(this.data != null ) {
            this.data.clear();
        }
        if(this.data2 != null ) {
            this.data2.clear();
        }
        return new ArrayList<>();
    }


    public List<CartItem> getItems(){
        return new ArrayList<>(data.values());
    }
    public List<CartItemCombo> getItemsCombo(){
        return new ArrayList<>(data2.values());
    }
    public int getTotalQuantity(){
        AtomicInteger total =  new AtomicInteger();
        data.values().forEach(item->total.addAndGet(item.getQuantity()));
        data2.values().forEach(item->total.addAndGet(item.getQuantity()));
        return  total.get();
    }

    public double getTotal(){
        AtomicReference<Double> sum = new AtomicReference<>((double)0);
        data.values().forEach(item->sum.updateAndGet(v -> v + (item.getPrice() * item.getQuantity())));
        data2.values().forEach(item->sum.updateAndGet(v -> v + (item.getPrice() * item.getQuantity())));
        return  sum.get();
    }

    public Map<Integer, CartItem> getData() {
        return data;
    }

    public void setData(Map<Integer, CartItem> data) {
        this.data = data;
    }

    public Map<Integer, CartItemCombo> getData2() {
        return data2;
    }

    public void setData2(Map<Integer, CartItemCombo> data2) {
        this.data2 = data2;
    }

    public String getFormatTotal(){
        return CartItem.Format(getTotal());
    }

    public void removeTimeOut(){
        long currentTime = System.currentTimeMillis();
        long limitTime = 20 * 60 * 1000;
        List<Integer> singelItem = new ArrayList<>();
        for (Map.Entry<Integer, CartItem> entry : data.entrySet()) {
            if (currentTime - entry.getValue().getTime() > limitTime) {
                singelItem.add(entry.getKey());
            }
        }
        for (int i = 0; i < singelItem.size(); i++) {
            data.remove(singelItem.get(i));
        }

        List<Integer> comboItem = new ArrayList<>();
        for (Map.Entry<Integer, CartItemCombo> entry : data2.entrySet()) {
            if (currentTime - entry.getValue().getTime() > limitTime) {
                comboItem.add(entry.getKey());
            }
        }
        for (int i = 0; i < comboItem.size(); i++) {
            data2.remove(comboItem.get(i));
        }
    }
}
