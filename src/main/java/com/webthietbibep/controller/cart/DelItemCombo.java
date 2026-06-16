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

@WebServlet(name = "DelItemCombo", value = "/del-combo")
public class DelItemCombo extends HttpServlet {
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

        int id = Integer.parseInt(request.getParameter("id"));
        CartService cs = new CartService();
        Integer cartId = cs.getCartIdByUserId(user.getUser_id());
        if (cartId == null) {
            cartId = cs.createCart(user.getUser_id());
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart != null) {
            cart.delItemCombo(id);
        }

        cs.deleteCombo(cartId, id);

        response.sendRedirect("cart");
    }
}