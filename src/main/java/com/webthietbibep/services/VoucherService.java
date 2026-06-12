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
        return uv.getListVoucher(type, id);
    }

    public void getVoucher(int id, int userId) {
        vd.getVoucher(id, userId);
    }

    public boolean checkVoucher(int id, int userId) {
        return vd.checkVoucher(id, userId);
    }

    public List<Voucher> getAdminListVouchers(String filter, String search, int page, int pageSize) {
        return vd.getFilterVoucherAdmin(filter, search, page, pageSize);
    }

    public int getTotalVouchers(String filter, String search) {
        return vd.getTotalVoucher(filter, search);
    }

    public boolean DeleteVoucher(int id) {
        return vd.deleteVoucher(id);
    }

    public Voucher getVoucherByID(int id) {
        return vd.getVoucherById(id);
    }

    public boolean AddVoucher(Voucher voucher) {
        return vd.addVoucher(voucher);
    }
    public boolean updateVoucher(Voucher voucher) {
        return vd.updateVoucher(voucher);
    }
public boolean removeUserVoucher(int userId, int voucherId) {
       return vd.removeVoucherFromUser(userId, voucherId);
}
    public boolean returnUserVoucher(int userId, int voucherId) {
        return vd.returnUserVoucher(userId, voucherId);
    }
    public List<Voucher> getUserSelectVoucher(int userID) {
        return uv.getUserSelectVoucher(userID);
    }
    public boolean subVoucherQuantity(int voucherId) {
        return vd.subVoucherQuantity(voucherId);
    }
    }