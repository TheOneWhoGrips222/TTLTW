package com.webthietbibep.services;

import com.webthietbibep.dao.ShowroomDao;
import com.webthietbibep.model.Showroom;
import com.webthietbibep.model.ShowroomImage;

import java.util.List;

public class ShowroomService {
    ShowroomDao sdao  = new ShowroomDao();

    public List<Showroom> getListShowroom() {
        return  sdao.getListShowroom();
    }
    public List<ShowroomImage> getListShowroomImage(int id) {
        return sdao.getListShowroomImage(id);
    }
}
