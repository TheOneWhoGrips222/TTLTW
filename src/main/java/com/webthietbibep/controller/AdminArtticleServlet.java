package com.webthietbibep.controller;

import com.webthietbibep.model.Article;
import com.webthietbibep.services.ArcticleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminArtticleServlet", value = "/admin/content")
public class AdminArtticleServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filter =  request.getParameter("filter");
        String search =  request.getParameter("search");
        if(filter == null) filter = "new";
        if(search == null) search = "";
        ArcticleService as = new ArcticleService();

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) page = Integer.parseInt(pageParam);
        int pageSize = 10;

        List<Article> filterA = as.getFilterArticleAdmin(filter,search,page, pageSize);
        int totalRecords = as.getTotalArticle(filter, search);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);







        request.setAttribute("filterA",filterA);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.getRequestDispatcher("/admin/admin_content.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}