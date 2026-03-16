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

@WebServlet(name = "LoginController" ,value = "/login")
public class LoginController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        request.getRequestDispatcher("/Login.jsp").forward(request,response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String username= request.getParameter("username");
        String password= request.getParameter("password");
        AuthService as= new AuthService();
        User u= as.login(username,password);
        if (u!= null) {
            if (!u.isIs_verified()) {
                request.setAttribute("errorMessage",
                        "Vui lòng xác nhận email trước khi đăng nhập");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
                return;
            }

            HttpSession sesion = request.getSession();
            sesion.setAttribute("user",u);
            if ("ADMIN".equals(u.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/Home");
            }
        }

        else {
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("Login.jsp").forward(request,response);
        }

    }
}
