package com.webthietbibep.dao;

import com.webthietbibep.model.User;

import java.util.List;

public class UserDAO extends BaseDao {

    public void updateProfile(User user) {
        get().useHandle(handle ->
                handle.createUpdate("""
                    UPDATE users
                    SET full_name = :fullName, email = :email, phone = :phone
                    WHERE user_id = :id
                """)
                        .bind("fullName", user.getFull_name())
                        .bind("email", user.getEmail())
                        .bind("phone", user.getPhone())
                        .bind("id", user.getUser_id())
                        .execute()
        );
    }

    public List<User> findAll() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM users ORDER BY user_id DESC")
                        .mapToBean(User.class).list()
        );
    }

    public User findById(int userId) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE user_id = :id")
                        .bind("id", userId).mapToBean(User.class).findOne().orElse(null)
        );
    }

    public User getById(int id) { return findById(id); }

    public void insert(User user) {
        get().useHandle(handle ->
                handle.createUpdate("""
                    INSERT INTO users (username, full_name, email, phone, password_hash, role, create_at, verify_token, is_verified)
                    VALUES (:username, :fullName, :email, :phone, :pass, :role, :createAt, :token, :verified)
                """)
                        .bind("username", user.getUsername())
                        .bind("fullName", user.getFull_name())
                        .bind("email",    user.getEmail())
                        .bind("phone",    user.getPhone())
                        .bind("pass",     user.getPassword_hash())
                        .bind("role",     user.getRole())
                        .bind("createAt", user.getCreate_at())
                        .bind("token",    user.getVerify_token())
                        .bind("verified", user.isIs_verified())
                        .execute()
        );
    }

    public void update(User user) {
        String sql = "UPDATE users SET full_name=:fullName, email=:email, phone=:phone, role=:role ";
        if (user.getPassword_hash() != null && !user.getPassword_hash().isEmpty())
            sql += ", password_hash=:pass ";
        sql += "WHERE user_id=:id";
        String fs = sql;
        get().useHandle(handle -> {
            var u = handle.createUpdate(fs)
                    .bind("fullName", user.getFull_name()).bind("email", user.getEmail())
                    .bind("phone", user.getPhone()).bind("role", user.getRole()).bind("id", user.getUser_id());
            if (user.getPassword_hash() != null && !user.getPassword_hash().isEmpty())
                u.bind("pass", user.getPassword_hash());
            u.execute();
        });
    }

    public void delete(int userId) {
        get().useHandle(h -> h.createUpdate("DELETE FROM users WHERE user_id=:id").bind("id", userId).execute());
    }

    public void deleteById(int userId) { delete(userId); }

    public boolean existsUsername(String username) {
        return get().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM users WHERE username=:u").bind("u", username).mapTo(Integer.class).one() > 0
        );
    }

    public boolean existsEmail(String email) {
        return get().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM users WHERE email=:e").bind("e", email).mapTo(Integer.class).one() > 0
        );
    }

    public String getPasswordHashById(int userId) {
        return get().withHandle(h ->
                h.createQuery("SELECT password_hash FROM users WHERE user_id=:id").bind("id", userId).mapTo(String.class).one()
        );
    }

    public void updatePassword(int userId, String newHash) {
        get().useHandle(h -> h.createUpdate("UPDATE users SET password_hash=:p WHERE user_id=:id").bind("p", newHash).bind("id", userId).execute());
    }

    public User findByToken(String token) {
        return get().withHandle(h ->
                h.createQuery("SELECT * FROM users WHERE verify_token=:t").bind("t", token).mapToBean(User.class).findOne().orElse(null)
        );
    }

    public void verifyUser(int userId) {
        get().useHandle(h -> h.createUpdate("UPDATE users SET is_verified=TRUE, verify_token=NULL WHERE user_id=:id").bind("id", userId).execute());
    }

    public boolean verifyByToken(String token) {
        return get().withHandle(h ->
                h.createUpdate("UPDATE users SET is_verified=true, verify_token=NULL WHERE verify_token=:t").bind("t", token).execute()
        ) > 0;
    }

    public User findByEmail(String email) {
        return get().withHandle(h ->
                h.createQuery("SELECT * FROM users WHERE email=:e").bind("e", email).mapToBean(User.class).findOne().orElse(null)
        );
    }

    public List<User> findStaff() {
        return get().withHandle(h ->
                h.createQuery("""
                    SELECT * FROM users
                    WHERE role IN ('OWNER','ADMIN','WAREHOUSE','SALES')
                    ORDER BY role ASC, user_id DESC
                """).mapToBean(User.class).list()
        );
    }

    public void updateStaff(User user) {
        String sql = "UPDATE users SET full_name=:fullName, email=:email, phone=:phone, role=:role";
        if (user.getPassword_hash() != null && !user.getPassword_hash().isBlank())
            sql += ", password_hash=:pass";
        sql += " WHERE user_id=:id";
        String fs = sql;
        get().useHandle(h -> {
            var u = h.createUpdate(fs)
                    .bind("fullName", user.getFull_name()).bind("email", user.getEmail())
                    .bind("phone", user.getPhone()).bind("role", user.getRole()).bind("id", user.getUser_id());
            if (user.getPassword_hash() != null && !user.getPassword_hash().isBlank())
                u.bind("pass", user.getPassword_hash());
            u.execute();
        });
    }
}