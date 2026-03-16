package com.webthietbibep.controller;

import com.webthietbibep.dao.UserAddressDAO;
import com.webthietbibep.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/delete-address")
public class DeleteAddressServlet extends HttpServlet {

    private final UserAddressDAO dao = new UserAddressDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        int addressId = Integer.parseInt(req.getParameter("id"));

        dao.delete(addressId, user.getUser_id());

        resp.sendRedirect("addresses");
    }
}
