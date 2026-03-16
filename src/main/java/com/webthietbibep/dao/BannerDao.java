package com.webthietbibep.dao;

import com.webthietbibep.model.Banner;

import java.util.List;

public class BannerDao extends BaseDao {

    public List<Banner> getListBanner() {
        return get().withHandle(h -> {
            return h.createQuery("SELECT banner_id as id, title, description, image_url as image, link_url, sort_order, is_active " +
                            "FROM banners WHERE is_active = 1 ORDER BY sort_order")
                    .mapToBean(Banner.class).list();
        });
    }


    public List<Banner> getAllBannersAdmin() {
        return get().withHandle(h -> {
            return h.createQuery("SELECT banner_id as id, title, description, image_url as image, link_url, sort_order, is_active " +
                            "FROM banners ORDER BY sort_order ASC, banner_id DESC")
                    .mapToBean(Banner.class).list();
        });
    }

    public Banner getBannerById(int id) {
        return get().withHandle(h -> {
            return h.createQuery("SELECT banner_id as id, title, description, image_url as image, link_url, sort_order, is_active " +
                            "FROM banners WHERE banner_id = :id")
                    .bind("id", id)
                    .mapToBean(Banner.class)
                    .findOne().orElse(null);
        });
    }

    public int insertBanner(Banner banner) {
        return get().withHandle(h -> {
            return h.createUpdate("INSERT INTO banners (title, description, image_url, link_url, sort_order, is_active) " +
                            "VALUES (:title, :description, :image, :link_url, :sort_order, :is_active)")
                    .bind("title", banner.getTitle())
                    .bind("description", banner.getDescription())
                    .bind("image", banner.getImage()) // Lưu ý: DB là image_url, bind giá trị từ getter
                    .bind("link_url", banner.getLink_url())
                    .bind("sort_order", banner.getSort_order())
                    .bind("is_active", banner.getIsActive())
                    .execute();
        });
    }

    public int updateBanner(Banner banner) {
        return get().withHandle(h -> {
            return h.createUpdate("UPDATE banners SET title = :title, description = :description, " +
                            "image_url = :image, link_url = :link_url, sort_order = :sort_order, is_active = :is_active " +
                            "WHERE banner_id = :id")
                    .bind("id", banner.getId())
                    .bind("title", banner.getTitle())
                    .bind("description", banner.getDescription())
                    .bind("image", banner.getImage())
                    .bind("link_url", banner.getLink_url())
                    .bind("sort_order", banner.getSort_order())
                    .bind("is_active", banner.getIsActive())
                    .execute();
        });
    }

    public int deleteBanner(int id) {
        return get().withHandle(h -> {
            return h.createUpdate("DELETE FROM banners WHERE banner_id = :id")
                    .bind("id", id)
                    .execute();
        });
    }
}