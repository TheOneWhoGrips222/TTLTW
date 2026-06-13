package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.model.Order;
import com.webthietbibep.model.User;
import com.webthietbibep.model.Voucher;
import com.webthietbibep.services.VoucherService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/cancel-order")
public class CancelOrderServlet extends HttpServlet {

    private OrdersDAO orderDAO = new OrdersDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        int orderId = Integer.parseInt(req.getParameter("order_id"));
         Order order = orderDAO.getOrderById(orderId);
        if (order != null && "CHO_XAC_NHAN".equals(order.getStatus())) {
            List<Voucher> vouchers = orderDAO.getVouchersByOrderId(orderId);
             VoucherService vs = new  VoucherService();
            if (vouchers != null) {
                  for (Voucher v : vouchers) {
                      vs.returnUserVoucher(user.getUser_id(), v.getId());
                }
            }
        }
        orderDAO.cancelOrder(orderId, user.getUser_id());

        resp.sendRedirect("orders");
    }
}

