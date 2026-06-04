package com.webthietbibep.dao;

import com.webthietbibep.model.Article;
import com.webthietbibep.model.Ecosystems;
import com.webthietbibep.model.Voucher;

import java.util.List;

public class VoucherDao extends BaseDao {
    public List<Voucher> getListVoucher(int lastId, int pageSize) {
        return get().withHandle(h -> {
            return h.createQuery("SELECT id, code, title, description, category_id, discountType, discountValue, minOrderValue, quantity, endDate, status FROM vouchers WHERE id > :lastId AND status = 1 AND quantity > 0 AND endDate >= NOW() ORDER BY id ASC LIMIT :pageSize")
                    .bind("lastId", lastId)
                    .bind("pageSize", pageSize)
                    .mapToBean(Voucher.class)
                    .list();
        });
    }

    public boolean checkVoucher(int id, int userId) {
        String sql = "select exists(select 1 from user_vouchers where voucher_id = :id and  user_id = :userid)";
        return get().withHandle(v -> {
            return v.createQuery(sql).bind("id", id).bind("userid", userId).mapTo(boolean.class).one();
        });
    }

    public void getVoucher(int id, int userId) {
        boolean check = checkVoucher(id, userId);
        if (check == true) {
            return;
        } else {
            String sql = "insert into user_vouchers (user_id, voucher_id,status) values  (:user_id, :voucher_id,0) ";
            get().useHandle(v -> {
                v.createUpdate(sql).bind("voucher_id", id).bind("user_id", userId).execute();
            });
        }
    }

    public List<Voucher> getFilterVoucherAdmin(String filter, String search, int page, int pageSize) {
        return get().withHandle(h -> {
            StringBuilder query = new StringBuilder("SELECT id, code, title, discountType, quantity, endDate, status FROM vouchers WHERE 1=1");
            String searchParam = (search == null) ? "" : search;

            if ("act".equals(filter)) {
                query.append(" AND code LIKE :search AND status = 1");
            } else if ("stop".equals(filter)) {
                query.append(" AND code LIKE :search AND status = 0");
            } else if ("expire".equals(filter)) {
                query.append(" AND code LIKE :search AND endDate < NOW()");
            } else {
                query.append(" AND code LIKE :search");
            }

            query.append(" ORDER BY id DESC LIMIT :limit OFFSET :offset");
            int offset = (page - 1) * pageSize;

            return h.createQuery(query.toString())
                    .bind("search", "%" + searchParam + "%")
                    .bind("limit", pageSize)
                    .bind("offset", offset)
                    .mapToBean(Voucher.class)
                    .list();
        });
    }

    public int getTotalVoucher(String filter, String search) {
        return get().withHandle(h -> {
            StringBuilder query = new StringBuilder("SELECT COUNT(*) FROM vouchers WHERE 1=1");
            String searchParam = (search == null) ? "" : search;

            if ("act".equals(filter)) {
                query.append(" AND code LIKE :search AND status = 1");
            } else if ("stop".equals(filter)) {
                query.append(" AND code LIKE :search AND status = 0");
            } else if ("expire".equals(filter)) {
                query.append(" AND code LIKE :search AND endDate < NOW()");
            } else {
                query.append(" AND code LIKE :search");
            }

            return h.createQuery(query.toString())
                    .bind("search", "%" + searchParam + "%")
                    .mapTo(Integer.class)
                    .one();
        });
    }

    public boolean deleteVoucher(int id) {
        String sql = "DELETE FROM vouchers WHERE id = :id";
        return get().withHandle(h -> {
            return h.createUpdate(sql).bind("id", id).execute() > 0;
        });
    }
    public boolean updateVoucher(Voucher voucher) {
        String sql = "UPDATE vouchers Set code = UPPER(:code) , title = :title, description = :description,category_id = :category_id,discountType = :discountType,discountValue = :discountValue , minOrderValue = :minOrderValue,quantity = :quantity, endDate = :endDate, status = :status  WHERE id = :id ";
        return get().withHandle(h -> {
            return h.createUpdate(sql)
                    .bindBean(voucher)
                    .execute() > 0;
        });
    }

    public boolean addVoucher(Voucher voucher) {
        String sql = "INSERT INTO vouchers (code, title, description, category_id, discountType, discountValue, minOrderValue, quantity, endDate, status) VALUES (UPPER(:code), :title, :description, :category_id, :discountType, :discountValue, :minOrderValue, :quantity, :endDate, :status)";
        return get().withHandle(h -> {
            return h.createUpdate(sql)
                    .bindBean(voucher)
                    .execute() > 0;
        });
    }
    public Voucher getVoucherById(int id){
        String sql = "SELECT * FROM vouchers WHERE id = :id";
        return get().withHandle(h->{
            return h.createQuery(sql).bind("id", id).mapToBean(Voucher.class).stream().findFirst().orElse(null);
        });
    }

}