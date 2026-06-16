package com.webthietbibep.controller.cart;

import com.webthietbibep.cart.Cart;
import com.webthietbibep.cart.CartItem;
import com.webthietbibep.cart.CartItemCombo;
import com.webthietbibep.model.Product;
import com.webthietbibep.model.Combo;
import com.webthietbibep.model.User;
import com.webthietbibep.services.BrandService;
import com.webthietbibep.services.CartService;
import com.webthietbibep.services.ComboService;
import com.webthietbibep.services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CartController", value = "/cart")
public class CartController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        BrandService bs = new BrandService();
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        if (user == null) {
            String queryString = request.getQueryString();
            String redirectUrl = "cart" + (queryString != null ? "?" + queryString : "");

            session.setAttribute("redirectUrl", redirectUrl);
            response.sendRedirect("login");
            return;
        }

        CartService cartService = new CartService();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            Integer cartId = cartService.getCartIdByUserId(user.getUser_id());
            if (cartId == null) {
                cartId = cartService.createCart(user.getUser_id());
            }

            cart = new Cart();

            ProductService ps = new ProductService();
            List<CartItem> items = cartService.getCartItems(cartId);
            if (items != null) {
                for (CartItem item : items) {
                    Product p = ps.getProduct(item.getProduct() != null ? item.getProduct().getProduct_id() : 0);
                    if (p != null) {
                        item.setProduct(p);
                        item.setPrice(p.getPrice());
                        cart.getData().put(p.getProduct_id(), item);
                    }
                }
            }

            ComboService cs = new ComboService();
            List<CartItemCombo> comboItems = cartService.getCartItemCombos(cartId);
            if (comboItems != null) {
                for (CartItemCombo cItem : comboItems) {
                    Combo c = cs.getCombo(cItem.getCombo() != null ? cItem.getCombo().getId() : 0);
                    if (c != null) {
                        cItem.setCombo(c);
                        cItem.setPrice(c.getDiscountprice());
                        cart.getData2().put(c.getId(), cItem);
                    }
                }
            }

            session.setAttribute("cart", cart);
        } else {
            cart.removeTimeOut();
        }

        Map<Integer, String> data = new HashMap<>();
        if (cart != null && cart.getData() != null) {
            for (CartItem ci : cart.getData().values()) {
                if (ci.getProduct() != null) {
                    int Pid = ci.getProduct().getProduct_id();
                    int Bid = ci.getProduct().getBrand_id();
                    if (!data.containsKey(Pid)) {
                        var brand = bs.getBrandById(Bid);
                        if (brand != null) {
                            String brandname = brand.getBrand_name();
                            if (brandname != null) {
                                data.put(Pid, brandname);
                            }
                        }
                    }
                }
            }
        }

        request.setAttribute("data", data);
        request.getRequestDispatcher("giohang.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}