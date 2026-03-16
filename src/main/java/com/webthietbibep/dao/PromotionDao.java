package com.webthietbibep.dao;

import com.webthietbibep.model.Promotion;

import java.util.List;

public class PromotionDao extends BaseDao    {

    public List<Promotion> getListPromotion(){
        return get().withHandle(h -> {
            return h.createQuery("select * from promotions where is_active = 1").mapToBean(Promotion.class).list();
        });
    }
}
