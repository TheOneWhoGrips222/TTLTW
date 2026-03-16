package com.webthietbibep.controller;

import com.webthietbibep.dao.UserDAO;
import com.webthietbibep.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User loginUser = (User) req.getSession().getAttribute("user");
        if (loginUser == null) {
            resp.sendRedirect("login");
            return;
        }

        User user = userDAO.findById(loginUser.getUser_id());
        req.setAttribute("user", user);
        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loginUser = (User) req.getSession().getAttribute("user");

        User u = new User();
        u.setUser_id(loginUser.getUser_id());
        u.setFull_name(req.getParameter("full_name"));
        u.setEmail(req.getParameter("email"));
        u.setPhone(req.getParameter("phone"));

        userDAO.updateProfile(u);

        resp.sendRedirect("profile");
    }

}
