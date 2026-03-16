package com.webthietbibep.controller;

import com.webthietbibep.dao.CategoryDAO;
import com.webthietbibep.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoryServlet", urlPatterns = {"/admin/categories"})
public class AdminCategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        this.categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                req.getRequestDispatcher("/admin/admin_category_form.jsp").forward(req, resp);
                break;
            case "edit":
                int idEdit = Integer.parseInt(req.getParameter("id"));
                Category existingCategory = categoryDAO.getCategory(idEdit);
                req.setAttribute("category", existingCategory);
                req.getRequestDispatcher("/admin/admin_category_form.jsp").forward(req, resp);
                break;
            case "delete":
                int idDelete = Integer.parseInt(req.getParameter("id"));
                categoryDAO.delete(idDelete);
                resp.sendRedirect(req.getContextPath() + "/admin/categories?message=deleted");
                break;
            default: // list
                List<Category> list = categoryDAO.getAll();
                req.setAttribute("categories", list);
                req.getRequestDispatcher("/admin/admin_category_list.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        String name = req.getParameter("category_name");
        String logo = req.getParameter("logo");

        if ("insert".equals(action)) {
            Category newC = new Category();
            newC.setCategory_name(name);
            newC.setLogo(logo);
            categoryDAO.insert(newC);
            resp.sendRedirect(req.getContextPath() + "/admin/categories?message=added");
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("category_id"));
            Category updateC = new Category(id, name, logo);
            categoryDAO.update(updateC);
            resp.sendRedirect(req.getContextPath() + "/admin/categories?message=updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }
}