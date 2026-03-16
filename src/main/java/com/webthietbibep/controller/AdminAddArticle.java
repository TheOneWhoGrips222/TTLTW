package com.webthietbibep.controller;

import com.webthietbibep.model.Article;
import com.webthietbibep.services.ArcticleService;
import com.webthietbibep.services.CategoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;


@WebServlet(name = "AdminAddArticle", value = "/admin/add-article")
public class AdminAddArticle extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/admin/admin_content_form.jsp").forward(request, response);
    }

    @Override

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String id = request.getParameter("id");
        int articleId = (id != null && !id.isEmpty()) ? Integer.parseInt(id) : 0;
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String tip = request.getParameter("tip");
        String summary = request.getParameter("summary");
        String body = request.getParameter("body");
        String image = request.getParameter("image");
        String is_active = request.getParameter("is_active");
        String cateRaw = request.getParameter("cate");

        Article a = new Article();
        a.setId(articleId);
        a.setTitle(title);
        a.setAuthor(author);
        a.setTip(tip);
        a.setContent(summary);
        a.setBody(body);
        a.setImage(image);

        int cateId = (cateRaw != null && !cateRaw.isEmpty()) ? Integer.parseInt(cateRaw) : 0;
        a.setCategory_id(cateId);
        a.setIs_active((byte) ("1".equals(is_active) ? 1 : 0));

        // kiểm tra id tồn tại
        CategoryService cs = new CategoryService();
        boolean check = cs.checkExist(cateId);

        if (check) {

            ArcticleService as = new ArcticleService();

            if (articleId > 0) {
                as.updateArticle(a);

            }


            else {

                a.setCreate_date(new java.sql.Date(System.currentTimeMillis()).toLocalDate());
                as.addArticle(a);
            }
            response.sendRedirect(request.getContextPath() + "/admin/content?message=success");
            return;
        } else {

            request.setAttribute("oldArticle", a);
            request.setAttribute("errorMessage", "ID danh mục :" + cateId + " không tồn tại!");


            request.getRequestDispatcher("/admin/admin_content_form.jsp").forward(request, response);
        }
    }
}