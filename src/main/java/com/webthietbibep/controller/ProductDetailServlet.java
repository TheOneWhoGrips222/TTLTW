package com.webthietbibep.controller;

import com.webthietbibep.dao.ProductCommentDAO;
import com.webthietbibep.dao.ProductDAO;
import com.webthietbibep.dao.ProductFeatureDAO;
import com.webthietbibep.dao.ProductImageDAO;
import com.webthietbibep.model.Product;
import com.webthietbibep.model.ProductComment;
import com.webthietbibep.model.ProductFeature;
import com.webthietbibep.model.ProductImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final ProductFeatureDAO featureDAO = new ProductFeatureDAO();
    private final ProductCommentDAO commentDAO =  new ProductCommentDAO();
    private final ProductImageDAO imageDAO = new ProductImageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        Product product = productDAO.getProduct(productId);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }
        List<ProductFeature> features = featureDAO.getByProductId(productId);

        List<Product> relatedProducts = productDAO.getRelatedProducts(product.getCategory_id(), productId);

        List<ProductComment> comments = commentDAO.getByProductId(productId);

        List<ProductImage> images = imageDAO.getByProductId(productId);

        request.setAttribute("images", images);
        request.setAttribute("comments", comments);
        request.setAttribute("product", product);
        request.setAttribute("features", features);
        request.setAttribute("relatedProducts", relatedProducts);

        request.getRequestDispatcher("/product-detail.jsp")
                .forward(request, response);
    }
}
