package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.dao.UserAddressDAO;
import com.webthietbibep.dao.UserDAO;
import com.webthietbibep.model.Order;
import com.webthietbibep.model.User;
import com.webthietbibep.model.UserAddress;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/users"})
public class AdminUserServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private UserAddressDAO userAddressDAO = new UserAddressDAO();
    private OrdersDAO ordersDAO = new OrdersDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            case "view":
                showUserDetail(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "insert":
                insertUser(request, response);
                break;
            case "update":
                updateUser(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> list = userDAO.findAll();
        request.setAttribute("users", list);
        request.getRequestDispatcher("/admin/admin_user_list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("user", new User());
        request.getRequestDispatcher("/admin/admin_user_form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User existingUser = userDAO.findById(id);

        if (existingUser == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?message=notfound");
            return;
        }

        request.setAttribute("user", existingUser);
        request.getRequestDispatcher("/admin/admin_user_form.jsp").forward(request, response);
    }

        private void showUserDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        User user = userDAO.findById(id);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?message=notfound");
            return;
        }

        List<UserAddress> addresses = userAddressDAO.findByUserId(id);
        List<Order> orders = ordersDAO.getOrdersByUser(id);

        // Tính tổng chi tiêu
        double totalSpent = orders.stream()
                .filter(o -> "HOAN_THANH".equals(o.getStatus()))
                .mapToDouble(Order::getTotal_amount)
                .sum();

        long completedOrders = orders.stream()
                .filter(o -> "HOAN_THANH".equals(o.getStatus()))
                .count();

        request.setAttribute("user", user);
        request.setAttribute("addresses", addresses);
        request.setAttribute("orders", orders);
        request.setAttribute("totalSpent", totalSpent);
        request.setAttribute("completedOrders", completedOrders);

        request.getRequestDispatcher("/admin/admin_user_detail.jsp").forward(request, response);
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String username = request.getParameter("username");
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (userDAO.existsUsername(username)) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
            request.setAttribute("user", new User(0, username, fullName, email, phone, "", null, role, null, true));
            request.getRequestDispatcher("/admin/admin_user_form.jsp").forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setFull_name(fullName);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setRole(role);
        newUser.setCreate_at(LocalDateTime.now());
        newUser.setPassword_hash(password);

        userDAO.insert(newUser);
        response.sendRedirect(request.getContextPath() + "/admin/users?message=saved");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        String password = request.getParameter("password");

        User user = new User();
        user.setUser_id(id);
        user.setFull_name(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRole(role);

        if (password != null && !password.trim().isEmpty()) {
            user.setPassword_hash(password);
        } else {
            user.setPassword_hash("");
        }

        userDAO.update(user);
        response.sendRedirect(request.getContextPath() + "/admin/users?message=updated");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/users?message=deleted");
    }
}