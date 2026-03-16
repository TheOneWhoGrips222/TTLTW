package com.webthietbibep.controller;

import com.webthietbibep.dao.ProductDAO;
import com.webthietbibep.model.OrderItem;
import com.webthietbibep.model.Product;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/buy-now")
public class BuyNowServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect("products");
            return;
        }

        int productId = Integer.parseInt(idStr);
        Product product = productDAO.getProduct(productId);

        if (product == null) {
            resp.sendRedirect("products");
            return;
        }

        OrderItem buyNowItem = new OrderItem();
        buyNowItem.setProduct_id(product.getProduct_id());
        buyNowItem.setQuantity(1);
        buyNowItem.setPrice_at_purchase(product.getPrice());

        req.getSession().setAttribute("buyNowProduct", product);
        req.getSession().setAttribute("buyNowQuantity", 1);

        resp.sendRedirect("checkout?mode=buynow");

    }
}

