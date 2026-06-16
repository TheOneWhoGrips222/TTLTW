package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.dao.RestockDAO;
import com.webthietbibep.dao.UserAddressDAO;
import com.webthietbibep.model.Order;
import com.webthietbibep.model.OrderItem;
import com.webthietbibep.model.UserAddress;
import com.webthietbibep.services.GhnOrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet(name = "AdminOrderController", urlPatterns = {"/admin/order"})
public class AdminOrderController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private final OrdersDAO orderDAO = new OrdersDAO();
    private final UserAddressDAO addressDAO = new UserAddressDAO();
    private final GhnOrderService ghnService = new GhnOrderService();
    private final RestockDAO restockDAO = new RestockDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list" -> listOrders(request, response);
            case "detail" -> viewOrderDetail(request, response);
            default -> listOrders(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("update_status".equals(action)) {
            updateOrderStatus(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/order");
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        syncGhnOrders();
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status_filter");

        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException ignored) {}
        }

        int totalRecords = orderDAO.countOrdersFiltered(keyword, status);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        List<Order> orders = orderDAO.getOrdersFiltered(keyword, status, currentPage, PAGE_SIZE);

        int startPage = Math.max(1, currentPage - 2);
        int endPage = Math.min(totalPages, currentPage + 2);

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("statusFilter", status != null ? status : "");

        request.getRequestDispatcher("/admin/order-list.jsp").forward(request, response);
    }

    private void viewOrderDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/order");
                return;
            }

            int orderId = Integer.parseInt(idParam);
            Order order = orderDAO.getOrderById(orderId);

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/admin/order?msg=not_found");
                return;
            }

            List<OrderItem> items = orderDAO.getOrderItems(orderId);

            request.setAttribute("order", order);
            request.setAttribute("orderVouchers", orderDAO.getVouchersByOrderId(orderId));
            request.setAttribute("items", items);
            request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/order?error=invalid_id");
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int orderId;
        String newStatus;
        try {
            orderId = Integer.parseInt(request.getParameter("order_id"));
            newStatus = request.getParameter("status");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/order?error=invalid_id");
            return;
        }

        Order currentOrder = orderDAO.getOrderById(orderId);
        if (currentOrder == null) {
            response.sendRedirect(request.getContextPath() + "/admin/order?error=not_found");
            return;
        }
        String oldStatus = currentOrder.getStatus();

        // 0) Nếu đơn đang được XÁC NHẬN GIAO HÀNG lần đầu (CHO_XAC_NHAN -> VAN_CHUYEN),
        //    trừ tồn kho tương ứng số lượng sản phẩm trong đơn TRƯỚC khi đổi trạng thái.
        //    Nếu không đủ hàng, dừng lại và báo lỗi, không đổi trạng thái.
        if ("CHO_XAC_NHAN".equals(oldStatus) && "VAN_CHUYEN".equals(newStatus)) {
            try {
                boolean ok = restockDAO.deductStockForOrder(orderId);
                if (!ok) {
                    String msg = URLEncoder.encode("Khong du hang trong kho de xac nhan don nay!", StandardCharsets.UTF_8);
                    response.sendRedirect(request.getContextPath() + "/admin/order?action=detail&id=" + orderId + "&msg=" + msg);
                    return;
                }
            } catch (IllegalStateException e) {
                String msg = URLEncoder.encode("Khong du ton kho de xac nhan don nay: " + e.getMessage(), StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/admin/order?action=detail&id=" + orderId + "&msg=" + msg);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                String msg = URLEncoder.encode("Loi khi tru ton kho: " + e.getMessage(), StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/admin/order?action=detail&id=" + orderId + "&msg=" + msg);
                return;
            }
        }

        // 1) Cập nhật trạng thái - không để lỗi GHN làm hỏng việc đổi trạng thái
        int result = orderDAO.updateStatus(orderId, newStatus);

        String ghnWarning = null;

        // 2) Tạo đơn GHN (nếu cần) - lỗi ở bước này KHÔNG được rollback trạng thái đã đổi
        if ("VAN_CHUYEN".equals(newStatus)) {
            try {
                Order order = orderDAO.getOrderById(orderId);

                if (order == null) {
                    ghnWarning = "Khong tim thay don hang.";
                } else if (order.getGhn_order_code() == null || order.getGhn_order_code().isEmpty()) {

                    UserAddress address = addressDAO.findById(order.getAddress_id());

                    if (address == null) {
                        ghnWarning = "Don hang chua co dia chi giao hang hop le.";
                    } else if (address.getDistrict_id() <= 0 || address.getWard_code() == null || address.getWard_code().isEmpty()) {
                        ghnWarning = "Dia chi giao hang thieu thong tin Quan/Phuong (district_id hoac ward_code).";
                    } else {
                        String ghnCode = ghnService.createOrder(order, address);
                        orderDAO.saveGhnCode(orderId, ghnCode);
                        System.out.println("Created GHN order: " + ghnCode);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                ghnWarning = "Doi trang thai thanh cong nhung tao don GHN loi: " + e.getMessage();
            }
        }

        if ("HOAN_THANH".equals(newStatus)) {
            try {
                restockDAO.recordSoldItems(orderId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String message;
        if (result <= 0) {
            message = "Cập nhật thất bại!";
        } else if (ghnWarning != null) {
            message = "Cập nhật trạng thái thành công, nhưng đồng bộ GHN lỗi: " + ghnWarning;
        } else {
            message = "Cập nhật thành công!";
        }

        String encodedMsg = URLEncoder.encode(message, StandardCharsets.UTF_8);

        response.sendRedirect(request.getContextPath() + "/admin/order?action=detail&id=" + orderId + "&msg=" + encodedMsg);
    }

    private void syncGhnOrders() {
        try {
            List<Order> orders = orderDAO.getOrdersNeedSync();

            for (Order order : orders) {
                String ghnStatus = ghnService.getOrderStatus(order.getGhn_order_code());
                String webStatus = mapStatus(ghnStatus);

                if (webStatus != null && !webStatus.equals(order.getStatus())) {
                    orderDAO.updateStatus(order.getOrder_id(), webStatus);

                    if ("HOAN_THANH".equals(webStatus)) {
                        restockDAO.recordSoldItems(order.getOrder_id());
                    }

                    System.out.println("SYNC " + order.getOrder_id() + " : " + order.getStatus() + " -> " + webStatus);
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