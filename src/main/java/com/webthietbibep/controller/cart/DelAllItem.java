package com.webthietbibep.controller.cart;

import com.webthietbibep.cart.Cart;
import com.webthietbibep.model.User;
import com.webthietbibep.services.CartService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "DelAllItem", value = "/delete-all")
public class DelAllItem extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        CartService cs = new CartService();
        Integer cartId = cs.getCartIdByUserId(user.getUser_id());
        if (cartId == null) {
            cartId = cs.createCart(user.getUser_id());
        }
        Cart cart = (Cart) request.getSession().getAttribute("cart");
        if(cart != null) {
            cart.delAllItems();
        }
        cs.deleteAll(cartId);
        response.sendRedirect("cart");
    }
}