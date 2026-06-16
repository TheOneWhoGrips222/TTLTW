package com.webthietbibep.controller;

import com.webthietbibep.dao.StatsDAO;
import com.webthietbibep.model.ChartData;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ChartDataApiServlet", urlPatterns = {"/admin/chart-data"})
public class ChartDataApiServlet extends HttpServlet {

    private final StatsDAO statsDAO = new StatsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");

        String mode     = request.getParameter("mode");
        String fromDate = request.getParameter("from");
        String toDate   = request.getParameter("to");

        List<ChartData> data = statsDAO.getRevenueByMode(mode, fromDate, toDate);

        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < data.size(); i++) {
            ChartData d = data.get(i);
            if (i > 0) json.append(",");
            json.append("{")
                    .append("\"date\":\"").append(escape(d.getDate())).append("\",")
                    .append("\"value\":").append(d.getValue()).append(",")
                    .append("\"orderCount\":").append(d.getOrderCount()).append(",")
                    .append("\"productsSold\":").append(d.getProductsSold()).append(",")
                    .append("\"periodStart\":\"").append(escape(d.getPeriodStart())).append("\",")
                    .append("\"periodEnd\":\"").append(escape(d.getPeriodEnd())).append("\"")
                    .append("}");
        }
        json.append("]");

        response.getWriter().write(json.toString());
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}