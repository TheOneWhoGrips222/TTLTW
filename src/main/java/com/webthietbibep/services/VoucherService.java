package com.webthietbibep.services;

import com.webthietbibep.dao.VoucherDao;
import com.webthietbibep.model.Voucher;

import java.util.List;

public class VoucherService {
    VoucherDao vd = new VoucherDao();
    public List<Voucher> getListVouchers() {
        return vd.getListVoucher();
    }
}
