package com.webthietbibep.dao;

import com.webthietbibep.model.Voucher;

import java.util.List;

public class VoucherDao extends BaseDao {
    public List<Voucher> getListVoucher() {
        return get().withHandle(h->{
            return h.createQuery("select * from vouchers").mapToBean(Voucher.class).list();
        });
    }
}
