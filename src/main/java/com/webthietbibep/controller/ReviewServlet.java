package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private OrdersDAO ordersDAO = new OrdersDAO();

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        int productId =
                Integer.parseInt(req.getParameter("productId"));

        int orderId =
                Integer.parseInt(req.getParameter("orderId"));

        req.setAttribute(
                "product",
                productDAO.getById(productId)
        );

        req.setAttribute(
                "order",
                ordersDAO.getOrderById(orderId)
        );

        req.getRequestDispatcher("/review.jsp")
                .forward(req, resp);
    }
}