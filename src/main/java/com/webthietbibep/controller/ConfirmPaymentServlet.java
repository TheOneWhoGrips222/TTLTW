package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/confirm-payment")
public class ConfirmPaymentServlet extends HttpServlet {

    private final OrdersDAO ordersDAO = new OrdersDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int orderId = Integer.parseInt(req.getParameter("orderId"));
        ordersDAO.updateStatus(orderId, "CHO_XAC_NHAN");

        resp.sendRedirect("orders");
    }
}

