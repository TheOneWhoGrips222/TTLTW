package com.webthietbibep.controller;

import com.webthietbibep.model.User;
import com.webthietbibep.model.Voucher;
import com.webthietbibep.services.VoucherService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "VoucherContronlle", value = "/list-voucher")
public class VoucherContronller extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        VoucherService vs = new VoucherService();
        User user = (User) request.getSession().getAttribute("user");
        int lastId = 0;
        String lastIdParam = request.getParameter("lastId");
        if (lastIdParam != null && !lastIdParam.isEmpty()) {
            lastId = Integer.parseInt(lastIdParam);
        }
        int pageSize = 6;
        List<Voucher> listV = vs.getListVouchers(lastId, pageSize);

        int nextLastId = 0;
        if (listV != null && !listV.isEmpty()) {
            nextLastId = listV.get(listV.size() - 1).getId();
        }
        if (user != null) {
            for (Voucher v : listV) {

                boolean check = vs.checkVoucher(v.getId(), user.getUser_id());
                v.setCollection(check);
            }
            }

        request.setAttribute("listV", listV);
        request.setAttribute("nextLastId", nextLastId);
        request.getRequestDispatcher("khuyenmai.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}