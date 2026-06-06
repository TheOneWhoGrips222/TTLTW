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
import java.time.LocalDateTime;

@WebServlet(name = "AdminAddVoucher", value = "/admin/add-voucher")
public class AdminAddVoucher extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CategoryService cs = new CategoryService();
        request.setAttribute("categories", cs.getAll());

        Voucher defaultVoucher = new Voucher();
        defaultVoucher.setId(0);
        defaultVoucher.setStatus(1);
        request.setAttribute("oldVoucher", defaultVoucher);

        request.getRequestDispatcher("/admin/admin_voucher_form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");
        int voucherId = (id != null && !id.isEmpty()) ? Integer.parseInt(id) : 0;

        String title = request.getParameter("title");
        String code = request.getParameter("code");
        String cateRaw = request.getParameter("category_id");
        String description = request.getParameter("description");
        String discountType = request.getParameter("discountType");
        String discountValueRaw = request.getParameter("discountValue");
        String minOrderValueRaw = request.getParameter("minOrderValue");
        String quantityRaw = request.getParameter("quantity");
        String statusRaw = request.getParameter("status");

        Voucher v = new Voucher();
        v.setId(voucherId);
        v.setTitle(title);
        v.setCode(code);
        v.setDescription(description);
        v.setDiscountType(discountType);
        v.setCategory_id((cateRaw != null && !cateRaw.isEmpty()) ? Integer.parseInt(cateRaw) : 0);
        v.setDiscountValue((discountValueRaw != null && !discountValueRaw.isEmpty()) ? Double.parseDouble(discountValueRaw) : 0);
        v.setMinOrderValue((minOrderValueRaw != null && !minOrderValueRaw.isEmpty()) ? Double.parseDouble(minOrderValueRaw) : 0);
        v.setQuantity((quantityRaw != null && !quantityRaw.isEmpty()) ? Integer.parseInt(quantityRaw) : 0);
        v.setStatus((statusRaw != null && !statusRaw.isEmpty()) ? Integer.parseInt(statusRaw) : 0);

        v.setEndDate(LocalDateTime.now().plusDays(7));

        VoucherService vs = new VoucherService();

        if (voucherId > 0) {
            vs.updateVoucher(v);
        } else {
            vs.AddVoucher(v);
        }

        response.sendRedirect(request.getContextPath() + "/admin/admin-voucher?message=success");
    }
}