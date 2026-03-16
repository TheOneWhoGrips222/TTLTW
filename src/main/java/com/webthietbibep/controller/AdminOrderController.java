package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.model.Order;
import com.webthietbibep.model.OrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet(name = "AdminOrderController", urlPatterns = {"/admin/order"})
public class AdminOrderController extends HttpServlet {

    private final OrdersDAO orderDAO = new OrdersDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list" -> listOrders(request, response);
            case "detail" -> viewOrderDetail(request, response);
            default -> listOrders(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("update_status".equals(action)) {
            updateOrderStatus(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/order");
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Order> list = orderDAO.getAllOrders();
        request.setAttribute("orders", list);
        request.getRequestDispatcher("/admin/order-list.jsp").forward(request, response);
    }

    private void viewOrderDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/order");
                return;
            }

            int orderId = Integer.parseInt(idParam);
            Order order = orderDAO.getOrderById(orderId);

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/admin/order?msg=not_found");
                return;
            }

            List<OrderItem> items = orderDAO.getOrderItems(orderId);

            request.setAttribute("order", order);
            request.setAttribute("items", items);
            request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/order?error=invalid_id");
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("order_id"));
            String newStatus = request.getParameter("status");

            int result = orderDAO.updateStatus(orderId, newStatus);

            String message = (result > 0) ? "Cập nhật thành công!" : "Cập nhật thất bại!";
            String encodedMsg = URLEncoder.encode(message, StandardCharsets.UTF_8);

            response.sendRedirect(request.getContextPath() + "/admin/order?action=detail&id=" + orderId + "&msg=" + encodedMsg);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/order?error=system_error");
        }
    }
}