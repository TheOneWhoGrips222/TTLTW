package com.webthietbibep.dao;

import com.webthietbibep.model.Ecosystems;
import com.webthietbibep.model.Product;

import java.util.List;

public class EcoDao extends BaseDao {


    public List<Ecosystems> getListEco() {
        return get().withHandle(h->{
            return h.createQuery("select * from ecosystems").mapToBean(Ecosystems.class).list();
        });
    }
    public Ecosystems getEcoById(int id) {
        return get().withHandle(h->{
            return h.createQuery("select * from ecosystems where id = :id").bind("id", id).mapToBean(Ecosystems.class).stream().findFirst().orElse(null);
        });
    }
    public List<Product> getListProductEco(int id){
        return get().withHandle(h->{
            return h.createQuery("select p.* from product_ecosystems e join products p  on e.product_id = p.product_id  where e.ecosystem_id = :id ").bind("id", id).mapToBean(Product.class).list();
        });
    }





}
