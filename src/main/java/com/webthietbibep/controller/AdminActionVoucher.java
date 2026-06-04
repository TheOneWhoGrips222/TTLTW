package com.webthietbibep.controller;

import com.webthietbibep.model.Voucher;
import com.webthietbibep.services.CategoryService;
import com.webthietbibep.services.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AdminActionVoucher", value = "/admin/action-voucher")
public class AdminActionVoucher extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");
        VoucherService vs = new VoucherService();

        if ("delete".equals(action)) {
            vs.DeleteVoucher(id);
            response.sendRedirect(request.getContextPath() + "/admin/admin-voucher?message=deleted");
        } else if ("edit".equals(action)) {
            Voucher voucher = vs.getVoucherByID(id);
            if (voucher != null) {
                request.setAttribute("oldVoucher", voucher);

                CategoryService cs = new CategoryService();
                request.setAttribute("categories", cs.getAll());

                request.getRequestDispatcher("/admin/admin_voucher_form.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/admin-voucher?error=notfound");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}