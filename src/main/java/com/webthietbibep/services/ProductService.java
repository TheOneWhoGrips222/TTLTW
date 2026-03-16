package com.webthietbibep.services;

import com.webthietbibep.dao.ProductDAO;
import com.webthietbibep.model.Product;

import java.util.List;

public class ProductService {
    ProductDAO pdao = new ProductDAO();


    public List<Product> getBestSeller() {
        return pdao.getBestSellers();
    }

    public List<Product> getListProduct() {
        return pdao.getListProduct();
    }
    public Product getProduct(int id) {
        return pdao.getProduct(id);
    }
}
