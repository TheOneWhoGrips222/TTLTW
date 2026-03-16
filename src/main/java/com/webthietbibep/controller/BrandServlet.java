package com.webthietbibep.controller;

import com.webthietbibep.dao.BrandDAO;
import com.webthietbibep.dao.ProductDAO;
import com.webthietbibep.model.Brand;
import com.webthietbibep.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/brand")
public class BrandServlet extends HttpServlet {

    private final BrandDAO brandDAO = new BrandDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {


        String idParam = req.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        try {

            int brandId = Integer.parseInt(idParam);

            Brand brand = brandDAO.getById(brandId);


            if (brand == null) {

                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Thương hiệu không tồn tại");
                return;
            }


            List<Product> products = productDAO.getByBrandId(brandId);


            req.setAttribute("brand", brand);
            req.setAttribute("products", products);


            req.getRequestDispatcher("brand.jsp").forward(req, resp);

        } catch (NumberFormatException e) {

            System.out.println("Lỗi format ID Brand: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/home");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}