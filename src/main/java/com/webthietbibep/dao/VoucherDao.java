package com.webthietbibep.dao;

import com.webthietbibep.model.Ecosystems;
import com.webthietbibep.model.Voucher;

import java.util.List;

public class VoucherDao extends BaseDao {
    public List<Voucher> getListVoucher(int lastId, int pageSize) {
        return get().withHandle(h -> {
            return h.createQuery("SELECT id, code, title, description, category_id, discountType, discountValue, minOrderValue, quantity, endDate, status FROM vouchers WHERE id > :lastId AND status = 1 AND endDate >= NOW() ORDER BY id ASC LIMIT :pageSize")
                    .bind("lastId", lastId)
                    .bind("pageSize", pageSize)
                    .mapToBean(Voucher.class)
                    .list();
        });
    }
}
