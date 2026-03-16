package com.webthietbibep.controller;

import com.webthietbibep.dao.BrandDAO;
import com.webthietbibep.dao.ProductDAO;
import com.webthietbibep.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private static final int PAGE_SIZE = 9;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String search = req.getParameter("search");

        List<Product> products;
        int totalProducts;
        int totalPages;
        int page = 1;
        String pageStr = req.getParameter("page");
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        if (search != null && !search.trim().isEmpty()) {

            products = productDAO.searchByName(search.trim());

            totalProducts = products.size();
            totalPages = 1;

            req.setAttribute("searchKeyword", search);

        } else {

            String categoryIdStr = req.getParameter("categoryId");
            String priceRange = req.getParameter("priceRange");
            String sort = req.getParameter("sort");

            String[] brands = req.getParameterValues("brand");

            Integer categoryId = null;
            if (categoryIdStr != null && !categoryIdStr.isBlank()) {
                categoryId = Integer.parseInt(categoryIdStr.trim());
            }


            products = productDAO.getProductsFilter(priceRange, sort, brands, categoryId, page, PAGE_SIZE);
            totalProducts = productDAO.countProducts(priceRange, brands, categoryId);
            totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

            req.setAttribute("categoryId", categoryId);
            req.setAttribute("brands", brands);
            req.setAttribute("priceRange", priceRange);
            req.setAttribute("sort", sort);
        }
        req.setAttribute("products", products);

        req.setAttribute("brandList", brandDAO.getAll());

        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("products.jsp").forward(req, resp);
    }
}