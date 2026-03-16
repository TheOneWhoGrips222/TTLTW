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

@WebServlet(name = "ArticleByCategory", value = "/article-category")
public class ArticleByCategory extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filter = request.getParameter("filter");
        if(filter == null) filter = "new";
        int cateId =  Integer.parseInt(request.getParameter("cateId"));
        ArcticleService as = new ArcticleService();
        CategoryService cs =  new CategoryService();
        CategoryService asc = new CategoryService();


        List<Article> listHA = as.getListHotArticle();
        List<Article> listC = as.getArticleByCategory(cateId,filter);
        List<Category> listCate =  asc.getAll();
        String name = cs.getCategoryById(cateId).getCategory_name();



        request.setAttribute("listHA", listHA);
        request.setAttribute("filter", filter);
        request.setAttribute("listC", listC);
        request.setAttribute("name", name);
        request.setAttribute("listCate", listCate);
        request.getRequestDispatcher("/articleCategory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}