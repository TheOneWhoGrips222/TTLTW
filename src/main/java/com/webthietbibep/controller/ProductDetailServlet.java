package com.webthietbibep.controller;

import com.webthietbibep.dao.*;
import com.webthietbibep.model.Product;
import com.webthietbibep.model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {

    private final ProductDAO        productDAO        = new ProductDAO();
    private final ProductImageDAO   productImageDAO   = new ProductImageDAO();
    private final ProductCommentDAO productCommentDAO = new ProductCommentDAO();
    private final SupplierDAO       supplierDAO       = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int     id      = Integer.parseInt(idStr);
            Product product = productDAO.getProduct(id);

            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            request.setAttribute("product",        product);
            request.setAttribute("images",         productImageDAO.getByProductId(id));
            request.setAttribute("comments",       productCommentDAO.getByProductId(id));
            request.setAttribute("relatedProducts", productDAO.getRelatedProducts(product.getCategory_id(), id));

            ReviewDao reviewDAO = new ReviewDao();

            request.setAttribute(
                    "reviews",
                    reviewDAO.getByProductId(id)
            );
            if (product.getSupplier_id() > 0) {
                Supplier supplier = supplierDAO.getById(product.getSupplier_id());
                request.setAttribute("supplier", supplier);
            }

            request.getRequestDispatcher("/product-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}