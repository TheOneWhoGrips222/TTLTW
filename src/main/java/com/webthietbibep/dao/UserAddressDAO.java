package com.webthietbibep.dao;

import com.webthietbibep.model.UserAddress;

import java.util.List;

public class UserAddressDAO extends BaseDao {

    public List<UserAddress> findByUserId(int userId) {
        return get().withHandle(h ->
                h.createQuery("""
                SELECT * FROM user_addresses
                WHERE user_id = :uid
                ORDER BY is_default DESC, created_at DESC
            """)
                        .bind("uid", userId)
                        .mapToBean(UserAddress.class)
                        .list()
        );
    }

    public void insert(UserAddress a) {
        get().useHandle(h -> {
            if (a.isIs_default()) {
                h.createUpdate("""
                    UPDATE user_addresses
                    SET is_default = false
                    WHERE user_id = :uid
                """).bind("uid", a.getUser_id()).execute();
            }

            h.createUpdate("""
                INSERT INTO user_addresses
                (user_id, receiver_name, phone, address_detail, ward, district, province, is_default)
                VALUES (:uid, :name, :phone, :detail, :ward, :district, :province, :def)
            """)
                    .bind("uid", a.getUser_id())
                    .bind("name", a.getReceiver_name())
                    .bind("phone", a.getPhone())
                    .bind("detail", a.getAddress_detail())
                    .bind("ward", a.getWard())
                    .bind("district", a.getDistrict())
                    .bind("province", a.getProvince())
                    .bind("def", a.isIs_default())
                    .execute();
        });
    }

    public void delete(int addressId, int userId) {
        get().useHandle(h ->
                h.createUpdate("""
                DELETE FROM user_addresses
                WHERE address_id = :id AND user_id = :uid
            """)
                        .bind("id", addressId)
                        .bind("uid", userId)
                        .execute()
        );
    }

    public void setDefault(int addressId, int userId) {
        get().useHandle(h -> {
            h.createUpdate("""
                UPDATE user_addresses
                SET is_default = false
                WHERE user_id = :uid
            """).bind("uid", userId).execute();

            h.createUpdate("""
                UPDATE user_addresses
                SET is_default = true
                WHERE address_id = :id
            """).bind("id", addressId).execute();
        });
    }
}
