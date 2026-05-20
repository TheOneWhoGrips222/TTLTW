package com.webthietbibep.controller.cart;

import com.webthietbibep.cart.Cart;
import com.webthietbibep.model.Combo;
import com.webthietbibep.model.User;
import com.webthietbibep.services.ComboService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AddComboCart", value = "/add-combo")
public class AddComboCart extends HttpServlet {
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

        String idParam = request.getParameter("id");
        if( idParam == null  || idParam.isEmpty()){response.sendRedirect("listcombo"); return;}
        int id ;
         try {
             id = Integer.parseInt(idParam);
         }
         catch(NumberFormatException e){
             response.sendRedirect("listcombo");
             return;
         }

        ComboService comboService = new ComboService();
        Combo combo =  comboService.getCombo(id);
        if(combo == null){response.sendRedirect("listcombo"); return;}

        int quantity = 1;
        String qParam = request.getParameter("q");
        if (qParam != null && !qParam.isEmpty()) {
            try {
                quantity = Integer.parseInt(qParam);
                if (quantity < 1) quantity = 1;
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }
        Cart cart = (Cart) session.getAttribute("cart");
        if(cart == null){
            cart = new Cart();
        }
        if(combo.getStock_quantity() == 0 ){
            session.setAttribute("message", "Combo này hiện đang hết hàng!");
            redirectBack(request, response, id);
            return;
        }
        int currComboQuantity = 0;
        if (!cart.getData2().containsKey(id)) {
        } else {
            currComboQuantity = cart.getData2().get(id).getQuantity();
        }

        if ((currComboQuantity + quantity) > combo.getStock_quantity()) {
            session.setAttribute("message", "Combo đã hết hàng không thể vào giỏ hàng.");
            session.setAttribute("messageType", "error");
        }
        else {
            cart.addItemCombo(combo, quantity);
            session.setAttribute("cart", cart);

            session.setAttribute("message", "Đã thêm Combo vào giỏ hàng!");
            session.setAttribute("messageType", "success");
        }
        redirectBack(request, response, id);
    }
    private void redirectBack(HttpServletRequest request, HttpServletResponse response, int comboId) throws IOException {
        String referer = request.getHeader("Referer");

        if (referer != null && !referer.isEmpty()) {
            // Quay lại trang trước đó
            response.sendRedirect(referer);
        } else {
            response.sendRedirect("combo?id=" + comboId);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}