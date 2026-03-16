package com.webthietbibep.services;

import com.webthietbibep.dao.PromotionDao;
import com.webthietbibep.model.Promotion;

import java.util.List;

public class PromotionService {
    PromotionDao pdao = new PromotionDao();
    public List<Promotion> getListPromotion(){
        return pdao.getListPromotion();
    }
}
