package com.webthietbibep.dao;

import com.webthietbibep.model.Voucher;

import java.util.List;

public class UserVoucherDao extends BaseDao{
    public List<Voucher> getListVoucher(String type,int id) {
        return get().withHandle(v-> {
            if (type.equals("unused")) {
                return v.createQuery("select v.id, v.code, v.title, v.description, v.category_id, v.discountType, v.discountValue, v.minOrderValue, v.quantity, v.endDate, u.status from user_vouchers u join vouchers v on u.voucher_id = v.id where u.user_id = :id and u.status = 0 and v.endDate > now()").bind("id", id).mapToBean(Voucher.class).list();
            }
            else if(type.equals("used")) {
                return v.createQuery("select v.id, v.code, v.title, v.description, v.category_id, v.discountType, v.discountValue, v.minOrderValue, v.quantity, v.endDate, u.status from user_vouchers u join vouchers v on u.voucher_id = v.id where u.user_id = :id and u.status = 1").bind("id", id).mapToBean(Voucher.class).list();
            }
            else if(type.equals("expired")) {
                return v.createQuery("select v.id, v.code, v.title, v.description, v.category_id, v.discountType, v.discountValue, v.minOrderValue, v.quantity, v.endDate, u.status from user_vouchers u join vouchers v on u.voucher_id = v.id where u.user_id = :id and u.status = 0 and v.endDate <= now()").bind("id", id).mapToBean(Voucher.class).list();
            }
            else {
                return v.createQuery("select v.id, v.code, v.title, v.description, v.category_id, v.discountType, v.discountValue, v.minOrderValue, v.quantity, v.endDate, u.status from user_vouchers u join vouchers v on u.voucher_id = v.id where u.user_id = :id").bind("id", id).mapToBean(Voucher.class).list();
            }
        });
    }

    public List<Voucher> getUserSelectVoucher(int userID){
        String sql = "select  v.id, v.code, v.title, v.description, v.category_id, v.discountType, v.discountValue, v.minOrderValue,v.endDate from user_vouchers uv  JOIN vouchers v ON uv.voucher_id = v.id where uv.user_id = :userID AND NOW() < v.endDate AND v.status = 1 AND uv.status = 0 ORDER BY endDate ASC ";
        return get().withHandle(v-> {
            return v.createQuery(sql).bind("userID",userID).mapToBean(Voucher.class).list();
        });
    }
}