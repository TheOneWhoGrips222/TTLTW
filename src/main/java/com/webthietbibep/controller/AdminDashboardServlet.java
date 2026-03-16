package com.webthietbibep.controller;

import com.webthietbibep.dao.StatsDAO;
import com.webthietbibep.model.ChartData;
import com.webthietbibep.model.TopProduct;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        StatsDAO statsDAO = new StatsDAO();

        double totalRevenue = statsDAO.getTotalRevenue();
        int totalOrders = statsDAO.countAllOrders();
        int totalUsers = statsDAO.countUsers();

        List<ChartData> chartDataList = statsDAO.getRevenueLast7Days();
        List<TopProduct> topProducts = statsDAO.getTopSellingProducts();

        NumberFormat vnFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
        req.setAttribute("totalRevenueFormat", vnFormat.format(totalRevenue));
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("totalUsers", totalUsers);

        req.setAttribute("chartDataList", chartDataList);
        req.setAttribute("topProducts", topProducts);

        req.getRequestDispatcher("/admin/admin_dashboard.jsp").forward(req, resp);
    }
}