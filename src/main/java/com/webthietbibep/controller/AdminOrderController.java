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

    private static final int PAGE_SIZE = 10;

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
            case "list"   -> listOrders(request, response);
            case "detail" -> viewOrderDetail(request, response);
            default       -> listOrders(request, response);
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
        String keyword = request.getParameter("keyword");
        String status  = request.getParameter("status_filter");

        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException ignored) {}
        }

        int totalRecords = orderDAO.countOrdersFiltered(keyword, status);
        int totalPages   = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        List<Order> orders = orderDAO.getOrdersFiltered(keyword, status, currentPage, PAGE_SIZE);

        int startPage = Math.max(1, currentPage - 2);
        int endPage   = Math.min(totalPages, currentPage + 2);

        request.setAttribute("orders",       orders);
        request.setAttribute("currentPage",  currentPage);
        request.setAttribute("totalPages",   totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("startPage",    startPage);
        request.setAttribute("endPage",      endPage);
        request.setAttribute("keyword",      keyword != null ? keyword : "");
        request.setAttribute("statusFilter", status  != null ? status  : "");

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
            int orderId   = Integer.parseInt(request.getParameter("order_id"));
            String newStatus = request.getParameter("status");

            int result = orderDAO.updateStatus(orderId, newStatus);

            String message    = (result > 0) ? "Cập nhật thành công!" : "Cập nhật thất bại!";
            String encodedMsg = URLEncoder.encode(message, StandardCharsets.UTF_8);

            response.sendRedirect(request.getContextPath()
                    + "/admin/order?action=detail&id=" + orderId + "&msg=" + encodedMsg);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/order?error=system_error");
        }
    }
}
