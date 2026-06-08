package com.webthietbibep.controller;

import com.webthietbibep.cart.Cart;
import com.webthietbibep.cart.CartItem;
import com.webthietbibep.model.User;
import com.webthietbibep.model.Voucher;
import com.webthietbibep.services.VoucherService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SelcectVoucherContronller", value = "/select-voucher")
public class SelcectVoucherContronller extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        // 1. NẾU CHƯA ĐĂNG NHẬP
        if (user == null) {

            String queryString = request.getQueryString();
            String redirectUrl = "cart" + (queryString != null ? "?" + queryString : "");

            session.setAttribute("redirectUrl", redirectUrl);
            response.sendRedirect("login");
            return;
        }


        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect("cart");
            return;
        }
        List<CartItem> cartItems = cart.getItems();

        VoucherService vs = new VoucherService();
         double cartTotal = cart.getTotal();
        List<Voucher> listV = vs.getUserSelectVoucher(user.getUser_id());
        for(Voucher v : listV){
        boolean check = v.isValid(cartTotal,cartItems);
        v.setValidVoucher(check);
        }
        request.setAttribute("listV", listV);

     request.getRequestDispatcher("select_voucher.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}