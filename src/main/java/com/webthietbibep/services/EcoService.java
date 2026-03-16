package com.webthietbibep.services;

import com.webthietbibep.dao.EcoDao;
import com.webthietbibep.model.Ecosystems;
import com.webthietbibep.model.Product;

import java.util.List;

public class EcoService {
    EcoDao edao =  new EcoDao();
    public List<Ecosystems> getListEco() {
        return edao.getListEco();
    }
    public Ecosystems getEcoById(int id) {
        return edao.getEcoById(id);
    }
     public List<Product> getListProductEco(int id){
        return edao.getListProductEco(id);
     }

}
