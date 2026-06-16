package com.webthietbibep.controller;

import com.webthietbibep.dao.RestockDAO;
import com.webthietbibep.model.ImportHistory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ImportHistoryServlet", urlPatterns = {"/admin/import-history"})
public class ImportHistoryServlet extends HttpServlet {

    private static final int PAGE_SIZE = 20;

    private final RestockDAO restockDAO = new RestockDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String productIdParam = request.getParameter("productId");
        String pageParam      = request.getParameter("page");

        int page = 1;
        try { if (pageParam != null) page = Integer.parseInt(pageParam); } catch (Exception ignored) {}
        if (page < 1) page = 1;

        List<ImportHistory> historyList;

        if (productIdParam != null && !productIdParam.isBlank()) {
            int productId = Integer.parseInt(productIdParam);
            historyList = restockDAO.getImportHistoryByProduct(productId);
            request.setAttribute("filterProductId", productId);
        } else {
            historyList = restockDAO.getAllImportHistory(page, PAGE_SIZE);
            int total     = restockDAO.countImportHistory();
            int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages",  totalPages);
            request.setAttribute("totalRecords", total);
        }

        request.setAttribute("historyList", historyList);
        request.getRequestDispatcher("/admin/import-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            int    productId  = Integer.parseInt(request.getParameter("productId"));
            int    quantity   = Integer.parseInt(request.getParameter("quantity"));
            String supplierIdStr = request.getParameter("supplierId");
            String unitPriceStr  = request.getParameter("unitPrice");
            String note          = request.getParameter("note");

            Integer supplierId = (supplierIdStr != null && !supplierIdStr.isBlank())
                    ? Integer.parseInt(supplierIdStr) : null;
            Double unitPrice   = (unitPriceStr  != null && !unitPriceStr.isBlank())
                    ? Double.parseDouble(unitPriceStr)  : null;

            HttpSession session = request.getSession(false);
            Integer importedBy  = null;
            if (session != null && session.getAttribute("userId") != null) {
                importedBy = (Integer) session.getAttribute("userId");
            }

            restockDAO.recordImport(productId, supplierId, quantity, unitPrice, note, importedBy);

            response.sendRedirect(request.getContextPath()
                    + "/admin/import-history?success=1&productId=" + productId);

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi ghi nhận nhập hàng: " + e.getMessage());
            doGet(request, response);
        }
    }
}