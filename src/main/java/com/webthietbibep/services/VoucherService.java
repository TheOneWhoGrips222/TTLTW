package com.webthietbibep.services;

import com.webthietbibep.dao.UserVoucherDao;
import com.webthietbibep.dao.VoucherDao;
import com.webthietbibep.model.Voucher;

import java.util.List;

public class VoucherService {
    VoucherDao vd = new VoucherDao();
    UserVoucherDao uv = new UserVoucherDao();
    public List<Voucher> getListVouchers(int lastId, int pageSize) {
        return vd.getListVoucher(lastId, pageSize);
    }

    public List<Voucher> getUserVouchers(String type, int id) {
        return  uv.getListVoucher(type, id);
    }
    public void getVoucher(int id,int userId) {
        vd.getVoucher(id,userId);
    }
    public boolean checkVoucher(int id,int  userId) {
        return  vd.checkVoucher(id,userId);
    }
}
