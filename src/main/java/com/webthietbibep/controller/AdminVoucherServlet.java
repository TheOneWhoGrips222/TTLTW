package com.webthietbibep.controller;

import com.webthietbibep.model.Voucher;
import com.webthietbibep.services.VoucherService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminVoucherServlet", value = "/admin/admin-voucher")
public class AdminVoucherServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filter =  request.getParameter("filter");
        String search =  request.getParameter("search");

        if(filter == null) filter = "all";
        if(search == null) search = "";
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) page = Integer.parseInt(pageParam);
        int pageSize = 10;
        VoucherService vs = new VoucherService();
        List<Voucher> listV = vs.getAdminListVouchers(filter,search,page,pageSize);
        int totalRecords = vs.getTotalVouchers(filter,search);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        request.setAttribute("listV",listV);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.getRequestDispatcher("/admin/admin_voucher.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}