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

        GoogleUser user = GoogleUtils.getUserInfo(token);

        String email = user.getEmail();
        String name = user.getName();

        UserDAO userDAO = new UserDAO();

        User u = userDAO.findByEmail(email);

        if (u == null) {
            u = new User();
            u.setEmail(email);
            u.setFull_name(name);
            u.setUsername(email);
            u.setRole("USER");
            u.setIs_verified(true);

            userDAO.insert(u);
        }

        request.getSession().setAttribute("user", u);

        response.sendRedirect("home");
    }
}