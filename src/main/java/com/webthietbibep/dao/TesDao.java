package com.webthietbibep.dao;

import com.webthietbibep.model.Testimonial;

import java.util.List;

public class TesDao extends BaseDao {


    public List<Testimonial> getListes() {
        return get().withHandle(h->{
            return h.createQuery("select testimonial_id as id, content,author_name, author_loc as author_location, is_approved from testimonials ").mapToBean(Testimonial.class).list();
        });
    }


}
