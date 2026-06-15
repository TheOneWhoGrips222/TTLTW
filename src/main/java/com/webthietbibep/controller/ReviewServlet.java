package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.dao.ProductDAO;
import com.webthietbibep.dao.ReviewDao;
import com.webthietbibep.model.Review;
import com.webthietbibep.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private OrdersDAO ordersDAO = new OrdersDAO();
    private ReviewDao reviewDAO = new ReviewDao();

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        int productId =
                Integer.parseInt(req.getParameter("productId"));

        int orderId =
                Integer.parseInt(req.getParameter("orderId"));

        req.setAttribute(
                "product",
                productDAO.getById(productId)
        );

        req.setAttribute(
                "order",
                ordersDAO.getOrderById(orderId)
        );

        req.getRequestDispatcher("/review.jsp")
                .forward(req, resp);
    }
    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException {

        User user = (User) req.getSession()
                .getAttribute("user");

        if(user == null){
            resp.sendRedirect("login");
            return;
        }

        int productId =
                Integer.parseInt(req.getParameter("productId"));

        int orderId =
                Integer.parseInt(req.getParameter("orderId"));

        int rating =
                Integer.parseInt(req.getParameter("rating"));

        String comment =
                req.getParameter("comment");

        if(rating < 1 || rating > 5){
            resp.sendRedirect("orders");
            return;
        }

        if(reviewDAO.hasReviewed(
                user.getUser_id(),
                productId,
                orderId)){
            resp.sendRedirect("orders");
            return;
        }

        Review review = new Review();

        review.setUser_id(user.getUser_id());
        review.setProduct_id(productId);
        review.setOrder_id(orderId);
        review.setRating(rating);
        review.setComment(comment);

        reviewDAO.insert(review);

        resp.sendRedirect("orders?status=HOAN_THANH");
    }
}