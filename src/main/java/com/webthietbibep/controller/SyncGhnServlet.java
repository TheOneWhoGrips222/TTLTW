package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.model.Order;
import com.webthietbibep.services.GhnOrderService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/sync-ghn")
public class SyncGhnServlet extends HttpServlet {

    private OrdersDAO ordersDAO = new OrdersDAO();
    private GhnOrderService ghnService = new GhnOrderService();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws IOException {

        List<Order> orders =
                ordersDAO.getOrdersNeedSync();

        for (Order order : orders) {

            try {

                String ghnStatus =
                        ghnService.getOrderStatus(
                                order.getGhn_order_code()
                        );

                String webStatus =
                        mapStatus(ghnStatus);

                if (webStatus != null
                        && !webStatus.equals(order.getStatus())) {

                    ordersDAO.updateStatus(
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

            } catch (Exception e) {

                e.printStackTrace();

            }
        }

        resp.getWriter().println("Sync done");
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