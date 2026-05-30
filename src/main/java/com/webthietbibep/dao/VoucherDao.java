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
    public boolean checkVoucher(int id, int userId) {
        String sql = "select exists(select 1 from user_vouchers where voucher_id = :id and  user_id = :userid)";
        return get().withHandle(v->{
            return v.createQuery(sql).bind("id", id).bind("userid",userId).mapTo(boolean.class).one();
        });
    }
    public void getVoucher (int id , int userId){
        boolean check = checkVoucher(id,userId);
        if(check == true){
            return;
        }
        else{
            String sql = "insert into user_vouchers (user_id, voucher_id,status) values  (:user_id, :voucher_id,0) ";
            get().useHandle(v -> {
                v.createUpdate(sql).bind("voucher_id",id).bind("user_id",userId).execute();
            });
        }
    }
}
