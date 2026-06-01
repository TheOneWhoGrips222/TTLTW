package com.webthietbibep.controller;

import com.webthietbibep.dao.SupplierDAO;
import com.webthietbibep.model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminSupplierServlet", urlPatterns = {"/admin/suppliers"})
public class AdminSupplierServlet extends HttpServlet {

    private final SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "list";
        try {
            switch (action) {
                case "new"    -> showForm(request, response, null);
                case "edit"   -> showEditForm(request, response);
                case "delete" -> deleteSupplier(request, response);
                default       -> listSuppliers(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/suppliers?message=error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            String action = request.getParameter("action");
            Supplier s = bindFromRequest(request);

            if ("insert".equals(action)) {
                supplierDAO.insert(s);
                response.sendRedirect(request.getContextPath() + "/admin/suppliers?message=saved");
            } else if ("update".equals(action)) {
                s.setSupplier_id(Integer.parseInt(request.getParameter("supplier_id")));
                supplierDAO.update(s);
                response.sendRedirect(request.getContextPath() + "/admin/suppliers?message=saved");
            } else {
                listSuppliers(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/suppliers?message=error");
        }
    }

    private void listSuppliers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Supplier> list = supplierDAO.getAll();
        request.setAttribute("suppliers", list);
        request.getRequestDispatcher("/admin/supplier-list.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, Supplier supplier)
            throws ServletException, IOException {
        request.setAttribute("supplier", supplier);
        request.getRequestDispatcher("/admin/supplier-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Supplier s = supplierDAO.getById(id);
        if (s == null) {
            response.sendRedirect(request.getContextPath() + "/admin/suppliers");
            return;
        }
        showForm(request, response, s);
    }

    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        supplierDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/suppliers?message=deleted");
    }

    private Supplier bindFromRequest(HttpServletRequest request) {
        Supplier s = new Supplier();
        s.setCompany_name(request.getParameter("company_name"));
        s.setContact_name(request.getParameter("contact_name"));
        s.setPhone(request.getParameter("phone"));
        s.setEmail(request.getParameter("email"));
        s.setAddress(request.getParameter("address"));
        s.setWebsite(request.getParameter("website"));
        s.setNote(request.getParameter("note"));
        return s;
    }
}