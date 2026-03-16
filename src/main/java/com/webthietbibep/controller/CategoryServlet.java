package com.webthietbibep.controller;

import com.webthietbibep.dao.CategoryDAO;
import com.webthietbibep.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;

import java.util.List;

@WebServlet(name = "CategoryServlet", urlPatterns = "/load-categories", loadOnStartup = 1)
public class CategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    public void init() throws ServletException {

        List<Category> categories = categoryDAO.getAll();


        getServletContext().setAttribute("categories", categories);

        System.out.println("✔ Categories loaded: " + categories.size());
    }
}
