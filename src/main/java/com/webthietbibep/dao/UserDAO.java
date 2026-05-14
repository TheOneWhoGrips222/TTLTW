package com.webthietbibep.dao;

import com.webthietbibep.model.User;

import java.util.List;

public class UserDAO extends BaseDao {

    // Update profile (KHÔNG update username)
    public void updateProfile(User user) {
        get().useHandle(handle ->
                handle.createUpdate("""
                    UPDATE users
                    SET full_name = :fullName,
                        email     = :email,
                        phone     = :phone
                    WHERE user_id = :id
                """)
                        .bind("fullName", user.getFull_name())
                        .bind("email", user.getEmail())
                        .bind("phone", user.getPhone())
                        .bind("id", user.getUser_id())
                        .execute()
        );
    }
    // 1. Lấy danh sách tất cả user
    public List<User> findAll() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM users ORDER BY user_id DESC")
                        .mapToBean(User.class)
                        .list()
        );
    }

    // 2. Tìm theo ID (Đã có - giữ nguyên)
    public User findById(int userId) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE user_id = :id")
                        .bind("id", userId)
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null)
        );
    }

    // 3. Thêm mới User (Admin tạo)
    public void insert(User user) {
        get().useHandle(handle ->
                handle.createUpdate("INSERT INTO users (username, full_name, email, phone, password_hash, role, create_at, verify_token, is_verified) " +
                                "VALUES (:username, :fullName, :email, :phone, :pass, :role, :createAt,:token, :verified)")
                        .bind("username", user.getUsername())
                        .bind("fullName", user.getFull_name())
                        .bind("email", user.getEmail())
                        .bind("phone", user.getPhone())
                        .bind("pass", user.getPassword_hash()) // Lưu ý: Nên mã hóa password trước khi truyền vào đây
                        .bind("role", user.getRole())
                        .bind("createAt", user.getCreate_at())
                        .bind("token", user.getVerify_token())
                        .bind("verified", user.isIs_verified())
                        .execute()
        );
    }

    // 4. Update User (Admin cập nhật - bao gồm cả Role và Password nếu có)
    public void update(User user) {
        // Logic: Nếu password rỗng thì không update cột password
        String sql = "UPDATE users SET full_name = :fullName, email = :email, phone = :phone, role = :role ";
        if (user.getPassword_hash() != null && !user.getPassword_hash().isEmpty()) {
            sql += ", password_hash = :pass ";
        }
        sql += "WHERE user_id = :id";

        String finalSql = sql;
        get().useHandle(handle -> {
            var update = handle.createUpdate(finalSql)
                    .bind("fullName", user.getFull_name())
                    .bind("email", user.getEmail())
                    .bind("phone", user.getPhone())
                    .bind("role", user.getRole())
                    .bind("id", user.getUser_id());

            if (user.getPassword_hash() != null && !user.getPassword_hash().isEmpty()) {
                update.bind("pass", user.getPassword_hash());
            }
            update.execute();
        });
    }

    // 5. Xóa User
    public void delete(int userId) {
        get().useHandle(handle ->
                handle.createUpdate("DELETE FROM users WHERE user_id = :id")
                        .bind("id", userId)
                        .execute()
        );
    }

    // 6. Kiểm tra username tồn tại (để validate khi tạo mới)
    public boolean existsUsername(String username) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM users WHERE username = :username")
                        .bind("username", username)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }
        public User getById(int id) {
            String sql = "SELECT * FROM users WHERE user_id = :id";

            return get().withHandle(h ->
                    h.createQuery(sql)
                            .bind("id", id)
                            .mapToBean(User.class)
                            .findOne()
                            .orElse(null)
            );
        }
    public String getPasswordHashById(int userId) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT password_hash FROM users WHERE user_id = :id")
                        .bind("id", userId)
                        .mapTo(String.class)
                        .one()
        );
    }
    public void updatePassword(int userId, String newPasswordHash) {
        get().useHandle(handle ->
                handle.createUpdate("""
                UPDATE users 
                SET password_hash = :pass 
                WHERE user_id = :id
            """)
                        .bind("pass", newPasswordHash)
                        .bind("id", userId)
                        .execute()
        );
    }

    public User findByToken(String token) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE verify_token = :token")
                        .bind("token", token)
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public void verifyUser(int userId) {
        get().useHandle(handle ->
                handle.createUpdate("""
                UPDATE users
                SET is_verified = TRUE,
                    verify_token = NULL
                WHERE user_id = :id
            """)
                        .bind("id", userId)
                        .execute()
        );
    }

    public boolean verifyByToken(String token) {
        return get().withHandle(handle ->
                handle.createUpdate("""
            UPDATE users 
            SET is_verified = true, verify_token = NULL
            WHERE verify_token = :token
        """)
                        .bind("token", token)
                        .execute()
        ) > 0;
    }

    public User findByEmail(String email) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE email = :email")
                        .bind("email", email)
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null)
        );
    }
    //check email tồn tại chưa
    public boolean existsEmail(String email) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM users WHERE email = :email")
                        .bind("email", email)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }



}
