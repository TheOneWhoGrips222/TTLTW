package com.webthietbibep.controller;

import com.webthietbibep.dao.RestockDAO;
import com.webthietbibep.dao.SupplierDAO;
import com.webthietbibep.model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ImportServlet", urlPatterns = {"/admin/import"})
public class ImportServlet extends HttpServlet {

    private final SupplierDAO supplierDAO = new SupplierDAO();
    private final RestockDAO  restockDAO  = new RestockDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        List<Supplier> suppliers = supplierDAO.getAll();

        request.setAttribute("suppliers", suppliers);

        String success = request.getParameter("success");
        String error   = request.getParameter("error");
        if (success != null) request.setAttribute("success", success);
        if (error   != null) request.setAttribute("error",   error);

        request.getRequestDispatcher("/admin/import.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            int    productId     = Integer.parseInt(request.getParameter("productId").trim());
            int    quantity      = Integer.parseInt(request.getParameter("quantity").trim());
            String supplierIdStr = request.getParameter("supplierId");
            String unitPriceStr  = request.getParameter("unitPrice");
            String note          = request.getParameter("note");

            if (quantity <= 0) throw new IllegalArgumentException("Số lượng phải lớn hơn 0");

            Integer supplierId = (supplierIdStr != null && !supplierIdStr.isBlank())
                    ? Integer.parseInt(supplierIdStr) : null;
            Double unitPrice = (unitPriceStr != null && !unitPriceStr.isBlank())
                    ? Double.parseDouble(unitPriceStr.replace(",", "").replace(".", "")) : null;

            HttpSession session  = request.getSession(false);
            Integer     importedBy = null;
            if (session != null && session.getAttribute("userId") != null) {
                importedBy = (Integer) session.getAttribute("userId");
            }

            restockDAO.recordImport(productId, supplierId, quantity, unitPrice, note, importedBy);

            response.sendRedirect(request.getContextPath()
                    + "/admin/import?success=" + quantity
                    + "&pid=" + productId);

        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/import?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/import?error=" + java.net.URLEncoder.encode("Lỗi hệ thống: " + e.getMessage(), "UTF-8"));
        }
    }
}