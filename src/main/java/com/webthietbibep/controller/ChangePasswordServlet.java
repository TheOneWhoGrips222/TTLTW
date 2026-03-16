package com.webthietbibep.controller;

import com.webthietbibep.dao.UserDAO;
import com.webthietbibep.model.User;
import com.webthietbibep.utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/change_password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        String oldPass = req.getParameter("oldPassword");
        String newPass = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        // 1. check new password confirm
        if (!newPass.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            doGet(req, resp);
            return;
        }

        // 2. check old password
        String currentHash = userDAO.getPasswordHashById(user.getUser_id());

        if (!PasswordUtil.check(oldPass, currentHash)) {
            req.setAttribute("error", "Mật khẩu hiện tại không đúng");
            doGet(req, resp);
            return;
        }

        // 3. update new password
        String newHash = PasswordUtil.hash(newPass);
        userDAO.updatePassword(user.getUser_id(), newHash);

        req.setAttribute("success", "Đổi mật khẩu thành công");
        doGet(req, resp);
    }
}

