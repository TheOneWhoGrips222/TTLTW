package com.webthietbibep.controller;

import com.webthietbibep.dao.RestockDAO;
import com.webthietbibep.model.RestockSuggestion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "RestockServlet", urlPatterns = {"/admin/restock"})
public class RestockServlet extends HttpServlet {

    private final RestockDAO restockDAO = new RestockDAO();

    @Override
    protected void doGet (HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        List<RestockSuggestion> suggestions = restockDAO.getRestockSuggestions();

        long urgentCount  = suggestions.stream().filter(s -> "URGENT".equals(s.getUrgencyLevel())).count();
        long warningCount = suggestions.stream().filter(s -> "WARNING".equals(s.getUrgencyLevel())).count();

        request.setAttribute("suggestions",  suggestions);
        request.setAttribute("urgentCount",  urgentCount);
        request.setAttribute("warningCount", warningCount);

        request.getRequestDispatcher("/admin/restock-suggestion.jsp").forward(request, response);
    }
}