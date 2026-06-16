package com.webthietbibep.controller;

import com.webthietbibep.dao.StatsDAO;
import com.webthietbibep.model.PeriodOrder;
import com.webthietbibep.model.TopProduct;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PeriodDetailApiServlet", urlPatterns = {"/admin/period-detail"})
public class PeriodDetailApiServlet extends HttpServlet {

    private final StatsDAO statsDAO = new StatsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");

        String from = request.getParameter("from");
        String to   = request.getParameter("to");

        if (from == null || to == null || from.isBlank() || to.isBlank()) {
            response.getWriter().write("{\"error\":\"Thiếu tham số from/to\"}");
            return;
        }

        List<TopProduct>  products = statsDAO.getProductsByDateRange(from, to);
        List<PeriodOrder> orders   = statsDAO.getOrdersByDateRange(from, to);

        StringBuilder json = new StringBuilder("{");
        json.append("\"from\":\"").append(escape(from)).append("\",");
        json.append("\"to\":\"").append(escape(to)).append("\",");

        json.append("\"products\":[");
        for (int i = 0; i < products.size(); i++) {
            TopProduct p = products.get(i);
            if (i > 0) json.append(",");
            json.append("{")
                    .append("\"productName\":\"").append(escape(p.getProductName())).append("\",")
                    .append("\"productImage\":\"").append(escape(p.getProductImage())).append("\",")
                    .append("\"totalSold\":").append(p.getTotalSold()).append(",")
                    .append("\"totalRevenue\":").append(p.getTotalRevenue())
                    .append("}");
        }
        json.append("],");

        json.append("\"orders\":[");
        for (int i = 0; i < orders.size(); i++) {
            PeriodOrder o = orders.get(i);
            if (i > 0) json.append(",");
            json.append("{")
                    .append("\"orderId\":").append(o.getOrderId()).append(",")
                    .append("\"customerName\":\"").append(escape(o.getCustomerName())).append("\",")
                    .append("\"createdAt\":\"").append(escape(o.getFormattedTime())).append("\",")
                    .append("\"totalAmount\":").append(o.getTotalAmount()).append(",")
                    .append("\"paymentMethod\":\"").append(escape(o.getPaymentMethod())).append("\",")
                    .append("\"paymentStatus\":\"").append(escape(o.getPaymentStatus())).append("\"")
                    .append("}");
        }
        json.append("]");

        json.append("}");

        response.getWriter().write(json.toString());
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}