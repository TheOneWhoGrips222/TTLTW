package com.webthietbibep.services;

import com.webthietbibep.dao.BrandDAO;
import com.webthietbibep.model.Brand;

import java.util.List;

public class BrandService {
    BrandDAO bdao = new BrandDAO();

    public List<Brand> getListBrand() {
        return bdao.getAll();
    }
    public  Brand getBrandById(int id) {
        return bdao.getById(id);
    }
    public List<Brand> getTopBrands() {
        return bdao.getTopBrands();
    }
}
