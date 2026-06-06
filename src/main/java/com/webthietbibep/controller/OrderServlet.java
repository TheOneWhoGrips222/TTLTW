package com.webthietbibep.controller;

import com.webthietbibep.dao.OrderItemDAO;
import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.dao.ProductDAO;
import com.webthietbibep.model.Order;
import com.webthietbibep.model.Product;
import com.webthietbibep.model.User;
import com.webthietbibep.services.GhnOrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {

    private OrdersDAO orderDAO = new OrdersDAO();
    private OrderItemDAO itemDAO = new OrderItemDAO();
    private ProductDAO productDAO = new ProductDAO();

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
            orders = orderDAO.getOrdersByUserAndStatus(user.getUser_id(), status);
        }


        Map<Integer, List<Product>> orderProducts = new LinkedHashMap<>();

        for (var o : orders) {
            var items = itemDAO.getByOrder(o.getOrder_id());
            List<Product> products = new ArrayList<>();

            for (var i : items) {
                Product p = productDAO.getById(i.getProduct_id());
                p.setPrice(i.getPrice_at_purchase()); // giá lúc mua
                products.add(p);
            }
            orderProducts.put(o.getOrder_id(), products);
        }

        req.setAttribute("orders", orders);
        req.setAttribute("orderProducts", orderProducts);
        req.getRequestDispatcher("/orders.jsp").forward(req, resp);
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

