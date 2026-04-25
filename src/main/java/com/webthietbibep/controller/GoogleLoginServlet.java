package com.webthietbibep.controller;

import com.webthietbibep.dao.UserDAO;
import com.webthietbibep.model.GoogleUser;
import com.webthietbibep.model.User;
import com.webthietbibep.utils.GoogleUtils;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/login-google")
public class GoogleLoginServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String code = request.getParameter("code");

        String token = GoogleUtils.getToken(code);

        GoogleUser gguser = GoogleUtils.getUserInfo(token);

        String email = gguser.getEmail();
        String name = gguser.getName();

        UserDAO userDAO = new UserDAO();

        User user = userDAO.findByEmail(email);

        if (user == null) {
            user = new User();
            user.setEmail(email);
            user.setFull_name(name);
            user.setUsername(email);
            user.setRole("USER");
            user.setIs_verified(true);

            userDAO.insert(user);
        }
        request.getSession().setAttribute("user", user);

        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}