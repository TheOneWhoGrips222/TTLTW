package com.webthietbibep.controller;

import com.webthietbibep.model.User;
import com.webthietbibep.services.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

@WebServlet(name = "LoginController", value = "/login")
public class LoginController extends HttpServlet {

    private static final Set<String> STAFF_ROLES = Set.of("OWNER", "ADMIN", "WAREHOUSE", "SALES");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        AuthService as = new AuthService();
        User u = as.login(username, password);

        if (u != null) {
            if (!u.isIs_verified()) {
                request.setAttribute("errorMessage", "Vui lòng xác nhận email trước khi đăng nhập");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", u);

            String role = u.getRole();
            if (STAFF_ROLES.contains(role)) {
                switch (role) {
                    case "WAREHOUSE" -> response.sendRedirect(request.getContextPath() + "/admin/products");
                    case "SALES"     -> response.sendRedirect(request.getContextPath() + "/admin/order");
                    default          -> response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/Home");
            }
        } else {
            request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
}