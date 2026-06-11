package com.webthietbibep.controller;

import com.webthietbibep.cart.Cart;
import com.webthietbibep.cart.CartItem;
import com.webthietbibep.dao.OrderItemDAO;
import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.dao.UserAddressDAO;
import com.webthietbibep.model.*;
import com.webthietbibep.services.GhnOrderService;
import com.webthietbibep.services.VoucherService;
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
    private final GhnOrderService ghnService = new GhnOrderService();
    private final VoucherService vs = new  VoucherService();
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
        double productTotal = 0;

        if ("buynow".equals(mode)) {
            Product product = (Product) req.getSession().getAttribute("buyNowProduct");
            Integer quantity = (Integer) req.getSession().getAttribute("buyNowQuantity");

            if (product == null || quantity == null) {
                resp.sendRedirect("products");
                return;
            }

            productTotal = product.getPrice() * quantity;
            NumberFormat vn = NumberFormat.getInstance(new Locale("vi", "VN"));
            String buyNowTotalFormatted = vn.format(productTotal) + " đ";

            req.setAttribute("buyNowTotal", productTotal);
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
            productTotal = cart.getTotal();
            req.setAttribute("cart", cart);
            req.setAttribute("mode", "cart");
        }

        Voucher chosseFS = (Voucher) req.getSession().getAttribute("chosseFS");
        Voucher chosseD = (Voucher) req.getSession().getAttribute("chosseD");

        double discount = 0;
        if (chosseD != null) {
            if ("percent".equals(chosseD.getDiscountType())) {
                discount = productTotal * (chosseD.getDiscountValue() / 100.0);
                if(chosseD.getMaxValueDiscount() > 0 && discount > chosseD.getMaxValueDiscount()){
                    discount = chosseD.getMaxValueDiscount();
                }
            } else {
                discount = chosseD.getDiscountValue();
            }
        }

        req.setAttribute("discount", discount);
        req.setAttribute("chosseFS", chosseFS);
        req.setAttribute("chosseD", chosseD);
        req.setAttribute("addresses", addressDAO.findByUserId(user.getUser_id()));
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

        double shippingFee = 0;
        String shippingFeeStr = req.getParameter("shippingFee");

        if (shippingFeeStr != null && !shippingFeeStr.isEmpty()) {
            shippingFee = Double.parseDouble(shippingFeeStr);
        }

        Order order = new Order();
        order.setUser_id(user.getUser_id());
        order.setAddress_id(addressId);
        order.setPayment_method(payment);
        if ("BANK".equals(payment)) {
            order.setStatus("CHO_THANH_TOAN");
        } else {
            order.setStatus("CHO_XAC_NHAN");
        }

        Voucher chosseFS = (Voucher) req.getSession().getAttribute("chosseFS");
        Voucher chosseD = (Voucher) req.getSession().getAttribute("chosseD");
        double productTotal = 0;
        int orderId;

        if ("buynow".equals(mode)) {
            Product product = (Product) req.getSession().getAttribute("buyNowProduct");
            Integer quantity = (Integer) req.getSession().getAttribute("buyNowQuantity");

            if (product == null || quantity == null) {
                resp.sendRedirect("products");
                return;
            }
            productTotal = product.getPrice() * quantity;

            double discount = 0;
            if (chosseD != null) {
                if ("percent".equals(chosseD.getDiscountType())) {
                    discount = productTotal * (chosseD.getDiscountValue() / 100.0);
                    if(chosseD.getMaxValueDiscount() > 0 && discount > chosseD.getMaxValueDiscount()){
                        discount = chosseD.getMaxValueDiscount();
                    }
                } else {
                    discount = chosseD.getDiscountValue();
                }
            }

            double discountShipping = 0;
            if (chosseFS != null) {
                if ("freeship".equals(chosseFS.getDiscountType())) {
                    discountShipping = shippingFee;
                } else {
                    discountShipping = chosseFS.getDiscountValue();
                    if (discountShipping > shippingFee) {
                        discountShipping = shippingFee;
                    }
                }
            }

            double total = productTotal + shippingFee - discount - discountShipping;
            if (total < 0) {
                total = 0;
            }
            order.setTotal_amount(total);
            orderId = ordersDAO.insert(order);

            if (chosseD != null) {
                ordersDAO.saveOrderVoucher(orderId, chosseD.getId());
            }
            if (chosseFS != null) {
                ordersDAO.saveOrderVoucher(orderId, chosseFS.getId());
            }

            OrderItem oi = new OrderItem();
            oi.setOrder_id(orderId);
            oi.setProduct_id(product.getProduct_id());
            oi.setQuantity(quantity);
            oi.setPrice_at_purchase(product.getPrice());
            itemDAO.insert(oi);

            req.getSession().removeAttribute("buyNowProduct");
            req.getSession().removeAttribute("buyNowQuantity");

        } else {
            Cart cart = (Cart) req.getSession().getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                resp.sendRedirect("cart");
                return;
            }
            productTotal = cart.getTotal();

            double discount = 0;
            if (chosseD != null) {
                if ("percent".equals(chosseD.getDiscountType())) {
                    discount = productTotal * (chosseD.getDiscountValue() / 100.0);
                    if(chosseD.getMaxValueDiscount() > 0 && discount > chosseD.getMaxValueDiscount()){
                        discount = chosseD.getMaxValueDiscount();
                    }
                } else {
                    discount = chosseD.getDiscountValue();
                }
            }

            double discountShipping = 0;
            if (chosseFS != null) {
                if ("freeship".equals(chosseFS.getDiscountType())) {
                    discountShipping = shippingFee;
                } else {
                    discountShipping = chosseFS.getDiscountValue();
                    if (discountShipping > shippingFee) {
                        discountShipping = shippingFee;
                    }
                }
            }

            double total = productTotal + shippingFee - discount - discountShipping;
            if (total < 0) {
                total = 0;
            }
            order.setTotal_amount(total);
            orderId = ordersDAO.insert(order);

            if (chosseD != null) {
                ordersDAO.saveOrderVoucher(orderId, chosseD.getId());
            }
            if (chosseFS != null) {
                ordersDAO.saveOrderVoucher(orderId, chosseFS.getId());
            }

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
        if (chosseD != null) { vs.removeUserVoucher(user.getUser_id(), chosseD.getId()); }
        if (chosseFS != null) { vs.removeUserVoucher(user.getUser_id(), chosseFS.getId()); }
        req.getSession().removeAttribute("chosseFS");
        req.getSession().removeAttribute("chosseD");

        if ("BANK".equals(payment)) {
            resp.sendRedirect(req.getContextPath() + "/payment/vnpay?orderId=" + orderId);
        } else {
            resp.sendRedirect("orders");
        }
    }
}