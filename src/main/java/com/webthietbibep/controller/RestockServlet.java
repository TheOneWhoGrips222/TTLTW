package com.webthietbibep.controller;

import com.webthietbibep.dao.RestockDAO;
import com.webthietbibep.dao.SupplierDAO;
import com.webthietbibep.model.RestockSuggestion;
import com.webthietbibep.model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "RestockServlet", urlPatterns = {"/admin/restock"})
public class RestockServlet extends HttpServlet {

    private final RestockDAO  restockDAO  = new RestockDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        List<RestockSuggestion> suggestions = restockDAO.getRestockSuggestions();
        List<Supplier>          suppliers   = supplierDAO.getAll();

        long urgentCount  = suggestions.stream().filter(s -> "URGENT".equals(s.getUrgencyLevel())).count();
        long warningCount = suggestions.stream().filter(s -> "WARNING".equals(s.getUrgencyLevel())).count();

        String success = request.getParameter("success");

        request.setAttribute("suggestions",  suggestions);
        request.setAttribute("suppliers",    suppliers);
        request.setAttribute("urgentCount",  urgentCount);
        request.setAttribute("warningCount", warningCount);
        request.setAttribute("importSuccess", "1".equals(success));

        request.getRequestDispatcher("/admin/restock-suggestion.jsp").forward(request, response);
    }
}