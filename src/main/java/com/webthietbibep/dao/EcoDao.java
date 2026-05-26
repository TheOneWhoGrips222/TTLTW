package com.webthietbibep.dao;

import com.webthietbibep.model.Combo;
import com.webthietbibep.model.Ecosystems;
import com.webthietbibep.model.Product;

import java.util.List;

public class EcoDao extends BaseDao {
    public List<Ecosystems> getListEco() {
        return get().withHandle(h->{
            return h.createQuery("select * from ecosystems").mapToBean(Ecosystems.class).list();
        });
    }

    public List<Ecosystems> getListEco2(int lastId, int pageSize) {
        return get().withHandle(h -> {
        String sql = "select * from ecosystems where 1=1";
        if(lastId > 0){
            sql += " and id < :lastId";
        }
        sql += " order by id desc limit :limit";
        if(lastId > 0){
            return h.createQuery(sql)
                    .bind("lastId", lastId)
                    .bind("limit", pageSize)
                    .mapToBean(Ecosystems.class)
                    .list();
        } else {
            return h.createQuery(sql)
                    .bind("limit", pageSize)
                    .mapToBean(Ecosystems.class)
                    .list();
        }
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
