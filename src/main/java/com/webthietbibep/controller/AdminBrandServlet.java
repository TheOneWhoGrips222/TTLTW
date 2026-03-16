package com.webthietbibep.controller;

import com.webthietbibep.dao.BrandDAO;
import com.webthietbibep.model.Brand;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminBrandServlet", urlPatterns = {"/admin/brands"})
public class AdminBrandServlet extends HttpServlet {

    private final BrandDAO brandDAO = new BrandDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteBrand(request, response);
                    break;
                default:
                    listBrands(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/brands?message=error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "insert":
                    insertBrand(request, response);
                    break;
                case "update":
                    updateBrand(request, response);
                    break;
                default:
                    listBrands(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/brands?message=error");
        }
    }

    private void listBrands(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Brand> list = brandDAO.getAll();
        request.setAttribute("brands", list);
        request.getRequestDispatcher("/admin/brand-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/admin/brand-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Brand existingBrand = brandDAO.getById(id);

            if (existingBrand != null) {
                request.setAttribute("brand", existingBrand);
                request.getRequestDispatcher("/admin/brand-form.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/brands");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/brands");
        }
    }

    private void insertBrand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("brand_name");
        String logo = request.getParameter("logo_url");

        Brand newBrand = new Brand();
        newBrand.setBrand_name(name);
        newBrand.setLogo_url(logo);

        brandDAO.insert(newBrand);

        response.sendRedirect(request.getContextPath() + "/admin/brands?message=saved");
    }

    private void updateBrand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("brand_id"));
        String name = request.getParameter("brand_name");
        String logo = request.getParameter("logo_url");
        String slo = request.getParameter("slogan");
        String des  = request.getParameter("description");

        Brand brand = new Brand(id, logo, name, slo, des);

        brandDAO.update(brand);

        response.sendRedirect(request.getContextPath() + "/admin/brands?message=saved");
    }

    private void deleteBrand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            brandDAO.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/brands?message=deleted");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/brands");
        }
    }
}