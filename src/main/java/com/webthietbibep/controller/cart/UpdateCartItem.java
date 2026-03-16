package com.webthietbibep.controller.cart;

import com.webthietbibep.cart.Cart;
import com.webthietbibep.model.Product;
import com.webthietbibep.services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "UpdateCartItem", value = "/update-cart")
public class UpdateCartItem extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id =  Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Cart cart = (Cart)session.getAttribute("cart");
        ProductService ps = new ProductService();
        Product product = ps.getProduct(id);
        int productStock = product.getStock_quantity();

        if (cart != null && cart.getData().containsKey(id)) {
            int curQuantity = cart.getData().get(id).getQuantity();
            if("up".equals(action)) {
                    if((productStock == 0) || (curQuantity + 1 > productStock) ){
                        session.setAttribute("message", "Sản phẩm đã vượt số lượng còn lại hoặc hết hàng không thể thêm");
                    }
                else {
                    cart.getData().get(id).setQuantity(curQuantity + 1);
                     session.removeAttribute("message");
                }
            }
            else  if("down".equals(action) && curQuantity>1){
                cart.getData().get(id).setQuantity(curQuantity-1);
                session.removeAttribute("message");
            }
            session.setAttribute("cart",cart);
        }
       response.sendRedirect("cart");
    }
}