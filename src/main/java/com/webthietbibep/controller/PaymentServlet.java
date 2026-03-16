package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    private final OrdersDAO ordersDAO = new OrdersDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String orderIdParam = req.getParameter("orderId");
        if (orderIdParam == null) {
            resp.sendRedirect("orders");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect("orders");
            return;
        }

        ordersDAO.cancelExpiredOrders();

        Order order = ordersDAO.getOrderById(orderId);
        if (order == null) {
            resp.sendRedirect("orders");
            return;
        }

        if (!"CHO_THANH_TOAN".equals(order.getStatus())) {
            resp.sendRedirect("orders");
            return;
        }
        req.setAttribute("order", order);
        req.getRequestDispatcher("/payment.jsp").forward(req, resp);
    }
}

