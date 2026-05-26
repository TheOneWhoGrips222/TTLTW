package com.webthietbibep.controller;

import com.webthietbibep.model.Article;
import com.webthietbibep.model.Category;
import com.webthietbibep.services.ArcticleService;
import com.webthietbibep.services.CategoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ArcticleController", value = "/arcticle")
public class ArcticleController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filter = request.getParameter("filter");
        int lastId = 0;
        String lastIdParam = request.getParameter("lastId");
        if (lastIdParam != null && !lastIdParam.isEmpty()) {
            lastId = Integer.parseInt(lastIdParam);
        }
        int pageSize = 4;
        String lastValue = request.getParameter("lastValue");
        if (lastValue == null) {
            lastValue = "";
        }
        ArcticleService as = new ArcticleService();
        CategoryService asc = new CategoryService();
        if(filter == null) filter = "new";
        List<Category> listCate =  asc.getAll();
        List<Article> listA = as.getFilterArticle(filter, lastId, lastValue, pageSize);
        List<Article> listHA = as.getListHotArticle();


        request.setAttribute("listA", listA);
        request.setAttribute("listHA", listHA);
        request.setAttribute("filter", filter);
        request.setAttribute("listCate", listCate);
        int nextLastId = 0;
        String nextLastValue = "";
        if (listA != null && !listA.isEmpty()) {
            nextLastId = listA.get(listA.size() - 1).getId();
            Article lastArticle = listA.get(listA.size() - 1);
            if ("population".equals(filter)) {
                nextLastValue = String.valueOf(lastArticle.getLikecount());
            } else if ("AZ".equals(filter)) {
                nextLastValue = lastArticle.getTitle();
            }
        }
        request.setAttribute("nextLastId", nextLastId);
        request.setAttribute("nextLastValue", nextLastValue);
        request.getRequestDispatcher("/goctuvan.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}