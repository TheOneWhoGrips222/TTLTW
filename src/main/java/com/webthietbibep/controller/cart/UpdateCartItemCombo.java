package com.webthietbibep.controller.cart;

import com.webthietbibep.cart.Cart;
import com.webthietbibep.model.Combo;
import com.webthietbibep.services.ComboService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "UpdateCartItemCombo", value = "/update-cartcombo")
public class UpdateCartItemCombo extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id =  Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Cart cart = (Cart)session.getAttribute("cart");
        ComboService comboService = new ComboService();
        Combo combo = comboService.getCombo(id);
        int comboStock = combo.getStock_quantity();

        if (cart != null && cart.getData2().containsKey(id)) {
            int curQuantity = cart.getData2().get(id).getQuantity();
            if("up".equals(action)) {
                if(( comboStock == 0) || (curQuantity + 1 >  comboStock) ){
                    session.setAttribute("message", "Combo đã vượt số lượng còn lại hoặc hết hàng không thể thêm");
                }
                else {
                    cart.getData2().get(id).setQuantity(curQuantity + 1);
                    session.removeAttribute("message");
                }
            }
            else  if("down".equals(action) && curQuantity>1){
                cart.getData2().get(id).setQuantity(curQuantity-1);
                session.removeAttribute("message");
            }
            session.setAttribute("cart",cart);
        }
        response.sendRedirect("cart");

    }
}