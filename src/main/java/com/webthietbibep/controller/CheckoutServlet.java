package com.webthietbibep.controller;

import com.webthietbibep.cart.Cart;
import com.webthietbibep.cart.CartItem;
import com.webthietbibep.dao.OrderItemDAO;
import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.dao.UserAddressDAO;
import com.webthietbibep.model.Order;
import com.webthietbibep.model.OrderItem;
import com.webthietbibep.model.Product;
import com.webthietbibep.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.NumberFormat;
import java.util.Locale;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final UserAddressDAO addressDAO = new UserAddressDAO();
    private final OrdersDAO ordersDAO = new OrdersDAO();
    private final OrderItemDAO itemDAO = new OrderItemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }


        String mode = req.getParameter("mode");

        Cart cart = null;
        if ("buynow".equals(mode)) {
            Product product = (Product) req.getSession().getAttribute("buyNowProduct");
            Integer quantity = (Integer) req.getSession().getAttribute("buyNowQuantity");

            if (product == null || quantity == null) {
                resp.sendRedirect("products");
                return;
            }

            double total = product.getPrice() * quantity;
            NumberFormat vn = NumberFormat.getInstance(new Locale("vi", "VN"));
            String buyNowTotalFormatted = vn.format(total) + " đ";

            req.setAttribute("buyNowTotalFormatted", buyNowTotalFormatted);
            req.setAttribute("buyNowProduct", product);
            req.setAttribute("buyNowQuantity", quantity);
            req.setAttribute("mode", "buynow");
        } else {
            cart = (Cart) req.getSession().getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                resp.sendRedirect("cart");
                return;
            }
            req.setAttribute("cart", cart);
            req.setAttribute("mode", "cart");
        }

        req.setAttribute("addresses",
                addressDAO.findByUserId(user.getUser_id()));
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);

    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        String mode = req.getParameter("mode");

        String addressIdStr = req.getParameter("addressId");

        if (addressIdStr == null || addressIdStr.isEmpty()) {
            req.setAttribute("error", "Vui lòng thêm và chọn địa chỉ nhận hàng trước khi đặt hàng");
            doGet(req, resp);
            return;
        }
        int addressId = Integer.parseInt(addressIdStr);
        String payment = req.getParameter("paymentMethod");

        Order order = new Order();
        order.setUser_id(user.getUser_id());
        order.setAddress_id(addressId);
        order.setPayment_method(payment);
        if ("BANK".equals(payment)) {
            order.setStatus("CHO_THANH_TOAN");
        } else {
            order.setStatus("CHO_XAC_NHAN");
        }


        int orderId;

        if ("buynow".equals(mode)) {

            Product product = (Product) req.getSession().getAttribute("buyNowProduct");
            Integer quantity = (Integer) req.getSession().getAttribute("buyNowQuantity");

            if (product == null || quantity == null) {
                resp.sendRedirect("products");
                return;
            }

            order.setTotal_amount(product.getPrice() * quantity);
            orderId = ordersDAO.insert(order);

            OrderItem oi = new OrderItem();
            oi.setOrder_id(orderId);
            oi.setProduct_id(product.getProduct_id());
            oi.setQuantity(quantity);
            oi.setPrice_at_purchase(product.getPrice());
            itemDAO.insert(oi);

            req.getSession().removeAttribute("buyNowProduct");
            req.getSession().removeAttribute("buyNowQuantity");

        }
        else {

            Cart cart = (Cart) req.getSession().getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                resp.sendRedirect("cart");
                return;
            }

            order.setTotal_amount(cart.getTotal());
            orderId = ordersDAO.insert(order);

            for (CartItem ci : cart.getItems()) {
                OrderItem oi = new OrderItem();
                oi.setOrder_id(orderId);
                oi.setProduct_id(ci.getProduct().getProduct_id());
                oi.setQuantity(ci.getQuantity());
                oi.setPrice_at_purchase(ci.getPrice());
                itemDAO.insert(oi);
            }

            req.getSession().removeAttribute("cart");
        }

        if ("BANK".equals(payment)) {
            resp.sendRedirect("payment?orderId=" + orderId);
        } else {
            resp.sendRedirect("orders");
        }

    }

}
