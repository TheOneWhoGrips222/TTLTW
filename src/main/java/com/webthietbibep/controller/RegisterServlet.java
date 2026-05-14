package com.webthietbibep.controller;

import com.webthietbibep.dao.UserDAO;
import com.webthietbibep.model.User;
import com.webthietbibep.utils.EmailService;
import com.webthietbibep.utils.PasswordUtil;
import com.webthietbibep.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String fullName = req.getParameter("fullName");
        String email    = req.getParameter("email");
        String phone    = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirm  = req.getParameter("confirmPassword");
        String token = java.util.UUID.randomUUID().toString();

        if (!password.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            doGet(req, resp);
            return;
        }
        if (!ValidationUtil.isValidPassword(password)) {
            req.setAttribute("error",
                    "Mật khẩu phải tối thiểu 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt");
            doGet(req, resp);
            return;
        }


        if (userDAO.existsUsername(username)) {
            req.setAttribute("error", "Tên đăng nhập đã tồn tại");
            doGet(req, resp);
            return;
        }
        if (userDAO.existsEmail(email)) {
            req.setAttribute("error", "Email đã tồn tại");
            doGet(req, resp);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setFull_name(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword_hash(PasswordUtil.hash(password));
        user.setRole("USER");
        user.setCreate_at(LocalDateTime.now());
        user.setVerify_token(token);
        user.setIs_verified(false);
        userDAO.insert(user);
        EmailService.sendVerifyEmail(email, token,username);


        req.setAttribute("success", "Đăng ký thành công, Vui lòng kiểm tra email để xác thực tài khoản.");
        req.getRequestDispatcher("/Login.jsp").forward(req, resp);
        System.out.println(req.getContextPath());

    }

}
