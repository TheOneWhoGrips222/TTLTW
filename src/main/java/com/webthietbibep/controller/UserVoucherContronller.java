package com.webthietbibep.controller;

import com.webthietbibep.model.User;
import com.webthietbibep.model.Voucher;
import com.webthietbibep.services.VoucherService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserVoucherContronller", value = "/user-voucher")
public class UserVoucherContronller extends HttpServlet {
    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");
        if (user == null) {

            String queryString = request.getQueryString();
            String redirectUrl = "cart" + (queryString != null ? "?" + queryString : "");

            session.setAttribute("redirectUrl", redirectUrl);
            response.sendRedirect("login");
            return;
        }
        String type = request.getParameter("statusFilter");
        if (type == null) {
            type = "all";
        }
        VoucherService vs = new VoucherService();
        List<Voucher> listU = vs.getUserVouchers(type, user.getUser_id());
        request.setAttribute("listU", listU);
        request.getRequestDispatcher("user_voucher.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}