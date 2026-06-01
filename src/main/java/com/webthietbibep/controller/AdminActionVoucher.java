package com.webthietbibep.controller;

import com.webthietbibep.services.VoucherService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "AdminDeleteVoucher", value = "/admin/action-voucher")
public class AdminActionVoucher extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");
        VoucherService vs = new VoucherService();
        if("delete".equals(action)) {
            vs.DeleteVoucher(id);
        }
        response.sendRedirect(request.getContextPath() + "/admin/admin-voucher");



    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}