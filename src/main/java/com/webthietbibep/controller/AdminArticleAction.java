package com.webthietbibep.controller;

import com.webthietbibep.model.Article;
import com.webthietbibep.services.ArcticleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AdminDelArticle", value = "/admin/action-article")
public class AdminArticleAction extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");
        ArcticleService as = new ArcticleService();

        if ("delete".equals(action)) {
            as.deleteArticle(id);
            response.sendRedirect(request.getContextPath() + "/admin/content?message=deleted");
        } else if ("edit".equals(action)) {

            Article article = as.getArticleById(id);
            request.setAttribute("oldArticle", article);

            request.getRequestDispatcher("/admin/admin_content_form.jsp").forward(request, response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}