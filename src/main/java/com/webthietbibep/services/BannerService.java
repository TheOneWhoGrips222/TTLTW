package com.webthietbibep.services;

import com.webthietbibep.dao.BannerDao;
import com.webthietbibep.model.Banner;

import java.util.List;

public class BannerService {
    BannerDao bdao = new BannerDao();

    public List<Banner> getListBanner() {
        return bdao.getListBanner();
    }
    // Cho Admin
    public List<Banner> getAllBannersAdmin() {
        return bdao.getAllBannersAdmin();
    }

    public Banner getBannerById(int id) {
        return bdao.getBannerById(id);
    }

    public boolean insertBanner(Banner banner) {
        return bdao.insertBanner(banner) > 0;
    }

    public boolean updateBanner(Banner banner) {
        return bdao.updateBanner(banner) > 0;
    }

    public boolean deleteBanner(int id) {
        return bdao.deleteBanner(id) > 0;
    }
}
