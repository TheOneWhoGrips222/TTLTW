package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        int orderId =
                Integer.parseInt(req.getParameter("orderId"));

        OrdersDAO dao = new OrdersDAO();

        Order order = dao.getOrderById(orderId);

        req.setAttribute("order", order);

        req.getRequestDispatcher("/payment.jsp")
                .forward(req, resp);
    }
}