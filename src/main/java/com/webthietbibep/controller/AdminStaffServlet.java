package com.webthietbibep.controller;

import com.webthietbibep.dao.UserDAO;
import com.webthietbibep.model.User;
import com.webthietbibep.utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "AdminStaffServlet", urlPatterns = {"/admin/staff"})
public class AdminStaffServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

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
                case "delete" -> deleteStaff(request, response);
                default       -> listStaff(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/staff?message=error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        try {
            if ("insert".equals(action)) {
                insertStaff(request, response);
            } else if ("update".equals(action)) {
                updateStaff(request, response);
            } else {
                listStaff(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/staff?message=error");
        }
    }

    private void listStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> staffList = userDAO.findStaff();
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("/admin/staff-list.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, User staff)
            throws ServletException, IOException {
        request.setAttribute("staff", staff);
        request.getRequestDispatcher("/admin/staff-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User staff = userDAO.findById(id);
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/admin/staff");
            return;
        }
        showForm(request, response, staff);
    }

    private void insertStaff(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String rawPassword = request.getParameter("password");

        User u = new User();
        u.setUsername(request.getParameter("username"));
        u.setFull_name(request.getParameter("full_name"));
        u.setEmail(request.getParameter("email"));
        u.setPhone(request.getParameter("phone"));
        u.setRole(request.getParameter("role"));
        u.setPassword_hash(PasswordUtil.hash(rawPassword));
        u.setCreate_at(LocalDateTime.now());
        u.setVerify_token("");
        u.setIs_verified(true);

        userDAO.insert(u);
        response.sendRedirect(request.getContextPath() + "/admin/staff?message=saved");
    }

    private void updateStaff(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("staff_id"));
        User u = userDAO.findById(id);
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/admin/staff?message=error");
            return;
        }

        u.setFull_name(request.getParameter("full_name"));
        u.setEmail(request.getParameter("email"));
        u.setPhone(request.getParameter("phone"));
        u.setRole(request.getParameter("role"));

        String newPassword = request.getParameter("password");
        if (newPassword != null && !newPassword.isBlank()) {
            u.setPassword_hash(PasswordUtil.hash(newPassword));
        }

        userDAO.updateStaff(u);
        response.sendRedirect(request.getContextPath() + "/admin/staff?message=saved");
    }

    private void deleteStaff(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.deleteById(id);
        response.sendRedirect(request.getContextPath() + "/admin/staff?message=deleted");
    }
}
