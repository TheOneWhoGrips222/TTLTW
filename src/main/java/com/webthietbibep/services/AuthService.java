package com.webthietbibep.services;

import com.webthietbibep.dao.AuthDao;
import com.webthietbibep.model.User;
import com.webthietbibep.utils.PasswordUtil;

public class AuthService {
    AuthDao authDao = new AuthDao();

    public User login(String username, String password) {
        User u= authDao.getUserByUsername(username);
        if (u == null) {
            return null;
        }

        if (PasswordUtil.check(password, u.getPassword_hash())) {
            u.setPassword_hash(null);
            return u;
        }

        return null;
    }
}
