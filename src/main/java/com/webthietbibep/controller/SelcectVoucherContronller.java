package com.webthietbibep.controller;

import com.webthietbibep.cart.Cart;
import com.webthietbibep.cart.CartItem;
import com.webthietbibep.model.Product; // Nhớ import thêm Product phục vụ cho buynow
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


        String mode = request.getParameter("mode");
        double cartTotal = 0;
        List<CartItem> cartItems = null;

        if ("buynow".equals(mode)) {

            Product buyNowProduct = (Product) session.getAttribute("buyNowProduct");
            Integer buyNowQuantity = (Integer) session.getAttribute("buyNowQuantity");

            if (buyNowProduct == null || buyNowQuantity == null) {
                response.sendRedirect("products");
                return;
            }
            cartTotal = buyNowProduct.getPrice() * buyNowQuantity;
            cartItems = new java.util.ArrayList<>();
            CartItem oneItem = new CartItem();
            oneItem.setProduct(buyNowProduct);
            oneItem.setQuantity(buyNowQuantity);
            oneItem.setPrice(buyNowProduct.getPrice());
            cartItems.add(oneItem);
        } else {

            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                response.sendRedirect("cart");
                return;
            }
            cartTotal = cart.getTotal();
            cartItems = cart.getItems();
        }


        VoucherService vs = new VoucherService();
        List<Voucher> listV = vs.getUserSelectVoucher(user.getUser_id());
        for (Voucher v : listV) {
            boolean check = v.isValid(cartTotal, cartItems);
            v.setValidVoucher(check);
        }

        request.setAttribute("listV", listV);
        request.setAttribute("mode", mode);

        request.getRequestDispatcher("select_voucher.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        VoucherService vs = new VoucherService();

        String idFreeShip = request.getParameter("idF");
        String idDiscount = request.getParameter("discount");

        if (idFreeShip != null && !idFreeShip.isEmpty()) {
            int idFS = Integer.parseInt(idFreeShip);
            Voucher v = vs.getVoucherByID(idFS);
            session.setAttribute("chosseFS", v);
        } else {
            session.removeAttribute("chosseFS");
        }


        if (idDiscount != null && !idDiscount.isEmpty()) {
            int idD = Integer.parseInt(idDiscount);
            Voucher vd = vs.getVoucherByID(idD);
            session.setAttribute("chosseD", vd);
        } else {
            session.removeAttribute("chosseD");
        }


        String mode = request.getParameter("mode");
        Product buyNowProduct = (Product) session.getAttribute("buyNowProduct");
        Integer buyNowQuantity = (Integer) session.getAttribute("buyNowQuantity");




        if ("buynow".equals(mode)) {
            response.sendRedirect("checkout?mode=buynow");
        } else {
            response.sendRedirect("checkout?mode=cart");
        }
    }
}