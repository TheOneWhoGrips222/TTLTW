package com.webthietbibep.controller;

import com.webthietbibep.dao.WishlistDAO;
import com.webthietbibep.model.Product;
import com.webthietbibep.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "WishlistController", value = "/wishlist")
public class WishlistController extends HttpServlet {

    private final WishlistDAO wishlistDAO = new WishlistDAO();


    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();


        User user = (User) session.getAttribute("user");

        // chưa đăng nhập
        if (user == null) {

            String queryString = request.getQueryString();
            String redirectUrl = "wishlist" + (queryString != null ? "?" + queryString : "");

            session.setAttribute("redirectUrl", redirectUrl); // Lưu lại để LoginController dùng
            response.sendRedirect("login"); // Chuyển sang trang Login
            return;
        }

        // đã đăng nhập
        String action = request.getParameter("action");
        String pIdStr = request.getParameter("product_id");

        if (action != null && pIdStr != null) {
            try {
                int pid = Integer.parseInt(pIdStr);

                if ("add".equals(action)) {
                    if (!wishlistDAO.checkExist(user.getUser_id(), pid)) {
                        wishlistDAO.insert(user.getUser_id(), pid);
                    }
                } else if ("remove".equals(action)) {
                    wishlistDAO.delete(user.getUser_id(), pid);
                }

                String referer = request.getHeader("Referer");

                if (referer != null && !referer.contains("login")) {
                    response.sendRedirect(referer);
                } else {
                    response.sendRedirect("wishlist");
                }
                return;

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }


        List<Product> wishlistProducts = wishlistDAO.getWishlistByUserId(user.getUser_id());
        request.setAttribute("wishlist", wishlistProducts);
        request.getRequestDispatcher("wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }
}