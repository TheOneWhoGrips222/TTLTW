package com.webthietbibep.controller;

import com.webthietbibep.dao.UserAddressDAO;
import com.webthietbibep.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/set-default")
public class SetDefaultAddressServlet extends HttpServlet {

    private final UserAddressDAO dao = new UserAddressDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));

        dao.setDefault(id, user.getUser_id());

        resp.sendRedirect("addresses");
    }
}

