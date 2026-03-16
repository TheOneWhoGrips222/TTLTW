package com.webthietbibep.controller;

import com.webthietbibep.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/verify")
public class VerifyEmailServlet extends HttpServlet {

    UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = req.getParameter("token");

        boolean success = userDAO.verifyByToken(token);

        if (success) {
            req.setAttribute("success", "Xác nhận email thành công, bạn có thể đăng nhập");
        } else {
            req.setAttribute("error", "Link xác nhận không hợp lệ");
        }
        req.getRequestDispatcher("/Login.jsp").forward(req, resp);
    }
}

