package com.webthietbibep.controller;

import com.webthietbibep.dao.OrderItemDAO;
import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.dao.ProductDAO;
import com.webthietbibep.dao.ReviewDao;
import com.webthietbibep.model.Order;
import com.webthietbibep.model.Product;
import com.webthietbibep.model.User;
import com.webthietbibep.model.Voucher;
import com.webthietbibep.services.GhnOrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {

    private OrdersDAO orderDAO = new OrdersDAO();
    private OrderItemDAO itemDAO = new OrderItemDAO();
    private ProductDAO productDAO = new ProductDAO();
    private ReviewDao reviewDAO = new ReviewDao();

    private GhnOrderService ghnService = new GhnOrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        orderDAO.cancelExpiredOrders();
        syncGhnOrders();

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        String status = req.getParameter("status");

        List<Order> orders;
        if (status == null || status.isBlank()) {
            orders = orderDAO.getOrdersByUser(user.getUser_id());
        } else {
            orders = orderDAO.getOrdersByUserAndStatus(
                    user.getUser_id(),
                    status
            );
        }

        Map<Integer, List<Product>> orderProducts = new LinkedHashMap<>();
        Map<Integer, List<Voucher>> orderVouchers = new LinkedHashMap<>();

        Map<String, Boolean> reviewedMap = new HashMap<>();

        for (Order o : orders) {

            var items = itemDAO.getByOrder(o.getOrder_id());

            List<Product> products = new ArrayList<>();

            for (var i : items) {

                Product p = productDAO.getById(i.getProduct_id());

                if (p != null) {

                    p.setPrice(i.getPrice_at_purchase());

                    products.add(p);

                    boolean reviewed = reviewDAO.hasReviewed(
                            user.getUser_id(),
                            p.getProduct_id(),
                            o.getOrder_id()
                    );

                    String key =
                            o.getOrder_id()
                                    + "_"
                                    + p.getProduct_id();

                    reviewedMap.put(key, reviewed);
                }
            }

            orderProducts.put(o.getOrder_id(), products);

            List<Voucher> vouchers =
                    orderDAO.getVouchersByOrderId(
                            o.getOrder_id()
                    );

            orderVouchers.put(
                    o.getOrder_id(),
                    vouchers
            );
        }

        req.setAttribute("orders", orders);
        req.setAttribute("orderProducts", orderProducts);
        req.setAttribute("orderVouchers", orderVouchers);
        req.setAttribute("reviewedMap", reviewedMap);

        req.getRequestDispatcher("/orders.jsp")
                .forward(req, resp);
    }

    private void syncGhnOrders() {

        try {

            List<Order> orders =
                    orderDAO.getOrdersNeedSync();

            for (Order order : orders) {

                String ghnStatus =
                        ghnService.getOrderStatus(
                                order.getGhn_order_code()
                        );

                String webStatus =
                        mapStatus(ghnStatus);

                if (webStatus != null
                        && !webStatus.equals(order.getStatus())) {

                    orderDAO.updateStatus(
                            order.getOrder_id(),
                            webStatus
                    );

                    System.out.println(
                            "SYNC "
                                    + order.getOrder_id()
                                    + " : "
                                    + order.getStatus()
                                    + " -> "
                                    + webStatus
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String mapStatus(String ghnStatus) {

        switch (ghnStatus) {

            case "ready_to_pick":
            case "picking":
            case "money_collect_picking":
            case "transporting":
            case "sorting":
                return "VAN_CHUYEN";

            case "delivering":
                return "CHO_GIAO_HANG";

            case "delivered":
                return "HOAN_THANH";

            case "cancel":
                return "DA_HUY";

            default:
                return null;
        }
    }
}