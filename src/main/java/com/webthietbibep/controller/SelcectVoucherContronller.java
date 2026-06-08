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

        // 2. KIỂM TRA MODE ĐỂ TÍNH TỔNG TIỀN PHÙ HỢP
        String mode = request.getParameter("mode");
        double cartTotal = 0;
        List<CartItem> cartItems = null;

        if ("buynow".equals(mode)) {
            // Chế độ mua ngay: Lấy từ session sản phẩm mua ngay
            Product buyNowProduct = (Product) session.getAttribute("buyNowProduct");
            Integer buyNowQuantity = (Integer) session.getAttribute("buyNowQuantity");

            if (buyNowProduct == null || buyNowQuantity == null) {
                response.sendRedirect("products");
                return;
            }
            cartTotal = buyNowProduct.getPrice() * buyNowQuantity;
        } else {
            // Chế độ giỏ hàng bình thường
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                response.sendRedirect("cart");
                return;
            }
            cartTotal = cart.getTotal();
            cartItems = cart.getItems();
        }

        // 3. LẤY DANH SÁCH VOUCHER VÀ KIỂM TRA ĐIỀU KIỆN HỢP LỆ
        VoucherService vs = new VoucherService();
        List<Voucher> listV = vs.getUserSelectVoucher(user.getUser_id());
        for (Voucher v : listV) {
            boolean check = v.isValid(cartTotal, cartItems);
            v.setValidVoucher(check);
        }

        request.setAttribute("listV", listV);
        request.setAttribute("mode", mode); // Gửi thêm mode sang JSP để form POST nhận diện được nếu cần

        request.getRequestDispatcher("select_voucher.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        VoucherService vs = new VoucherService();

        String idFreeShip = request.getParameter("idF");
        String idDiscount = request.getParameter("discount");

        // Xử lý lưu voucher Freeship
        if (idFreeShip != null && !idFreeShip.isEmpty()) {
            int idFS = Integer.parseInt(idFreeShip);
            Voucher v = vs.getVoucherByID(idFS);
            session.setAttribute("chosseFS", v);
        } else {
            session.removeAttribute("chosseFS");
        }

        // Xử lý lưu voucher Giảm giá
        if (idDiscount != null && !idDiscount.isEmpty()) {
            int idD = Integer.parseInt(idDiscount);
            Voucher vd = vs.getVoucherByID(idD);
            session.setAttribute("chosseD", vd);
        } else {
            session.removeAttribute("chosseD");
        }

        // 4. KIỂM TRA ĐỂ REDIRECT VỀ ĐÚNG TRANG CHECKOUT
        String mode = request.getParameter("mode");
        Product buyNowProduct = (Product) session.getAttribute("buyNowProduct");
        Integer buyNowQuantity = (Integer) session.getAttribute("buyNowQuantity");

        // Nếu tham số mode gửi lên là buynow hoặc kiểm tra thấy dữ liệu buynow trong session tồn tại
        if ("buynow".equals(mode) || (buyNowProduct != null && buyNowQuantity != null)) {
            response.sendRedirect("checkout?mode=buynow");
        } else {
            response.sendRedirect("checkout");
        }
    }
}