package com.webthietbibep.controller;

import com.webthietbibep.model.User;
import com.webthietbibep.services.VoucherService;
import jakarta.mail.Session;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "getVoucherContronller", value = "/getVoucher")
public class GetVoucherContronller extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {




    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int id =  Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            String queryString = request.getQueryString();
            String redirectUrl = "cart" + (queryString != null ? "?" + queryString : "");

            session.setAttribute("redirectUrl", redirectUrl);
            response.sendRedirect("login");
            return;
        }
        VoucherService vs = new VoucherService();
        vs.getVoucher(id,user.getUser_id());
        vs.subVoucherQuantity(id);
        response.setStatus(HttpServletResponse.SC_OK);

    }
}