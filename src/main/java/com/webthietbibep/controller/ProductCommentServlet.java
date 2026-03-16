package com.webthietbibep.controller;

import com.webthietbibep.dao.ProductCommentDAO;
import com.webthietbibep.model.ProductComment;
import com.webthietbibep.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/product-comment")
public class ProductCommentServlet extends HttpServlet {

    private final ProductCommentDAO commentDAO = new ProductCommentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("product_id"));
        String content = request.getParameter("content");

        if (content == null || content.isBlank()) {
            response.sendRedirect(
                    request.getContextPath() + "/product-detail?id=" + productId
            );
            return;
        }

        ProductComment c = new ProductComment();
        c.setProduct_id(productId);
        c.setUser_id(user.getUser_id());
        c.setContent(content);

        commentDAO.insert(c);

        response.sendRedirect(
                request.getContextPath() + "/product-detail?id=" + productId
        );
    }
}

