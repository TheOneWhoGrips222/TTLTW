package com.webthietbibep.dao;

import com.webthietbibep.model.Showroom;
import com.webthietbibep.model.ShowroomImage;

import java.util.List;

public class ShowroomDao extends BaseDao {
    public List<Showroom> getListShowroom(){
        return  get().withHandle(h ->{
            return h.createQuery("SELECT * FROM showrooms ;").mapToBean(Showroom.class).list();
        });
    }

    public List<ShowroomImage>  getListShowroomImage(int id){
        return  get().withHandle(h ->{
            return h.createQuery("SELECT * FROM showroomimages where showroom_id = :id and is_active = 1 ;").bind("id",id).mapToBean(ShowroomImage.class).list();
        });
    }

}
