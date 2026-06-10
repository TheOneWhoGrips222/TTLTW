package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.model.Order;
import com.webthietbibep.utils.VNPayConfig;
import com.webthietbibep.utils.VnPayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/payment/vnpay")
public class VnPayPaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        try {

            int orderId =
                    Integer.parseInt(req.getParameter("orderId"));

            OrdersDAO dao = new OrdersDAO();
            Order order = dao.getOrderById(orderId);

            if (order == null) {
                resp.sendError(404);
                return;
            }

            long amount =
                    Math.round(order.getTotal_amount()) * 100L;

            Calendar cal =
                    Calendar.getInstance(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));

            String createDate =
                    new SimpleDateFormat("yyyyMMddHHmmss")
                            .format(cal.getTime());

            cal.add(Calendar.MINUTE, 15);

            String expireDate =
                    new SimpleDateFormat("yyyyMMddHHmmss")
                            .format(cal.getTime());

            Map<String, String> vnpParams =
                    new HashMap<>();

            vnpParams.put("vnp_Version", "2.1.0");
            vnpParams.put("vnp_Command", "pay");
            vnpParams.put("vnp_TmnCode", VNPayConfig.TMN_CODE);
            vnpParams.put("vnp_Amount", String.valueOf(amount));
            vnpParams.put("vnp_CurrCode", "VND");

            vnpParams.put("vnp_TxnRef",
                    String.valueOf(order.getOrder_id()));

            vnpParams.put("vnp_OrderInfo",
                    "ThanhToanDonHang" + order.getOrder_id());

            vnpParams.put("vnp_OrderType", "other");

            vnpParams.put("vnp_Locale", "vn");

            vnpParams.put("vnp_ReturnUrl",
                    VNPayConfig.RETURN_URL);

            vnpParams.put("vnp_IpAddr",
                    req.getRemoteAddr());

            vnpParams.put("vnp_CreateDate",
                    createDate);

            vnpParams.put("vnp_ExpireDate",
                    expireDate);

            List<String> fieldNames =
                    new ArrayList<>(vnpParams.keySet());

            Collections.sort(fieldNames);

            StringBuilder hashData =
                    new StringBuilder();

            StringBuilder query =
                    new StringBuilder();

            int i = 0;

            for (String fieldName : fieldNames) {

                String fieldValue =
                        vnpParams.get(fieldName);

                if (fieldValue != null
                        && !fieldValue.isEmpty()) {

                    if (i == 1) {
                        hashData.append("&");
                        query.append("&");
                    }

                    hashData.append(
                            URLEncoder.encode(
                                    fieldName,
                                    StandardCharsets.US_ASCII));

                    hashData.append("=");

                    hashData.append(
                            URLEncoder.encode(
                                    fieldValue,
                                    StandardCharsets.US_ASCII));

                    query.append(
                            URLEncoder.encode(
                                    fieldName,
                                    StandardCharsets.US_ASCII));

                    query.append("=");

                    query.append(
                            URLEncoder.encode(
                                    fieldValue,
                                    StandardCharsets.US_ASCII));

                    i = 1;
                }
            }

            String secureHash =
                    VnPayUtil.hmacSHA512(
                            VNPayConfig.HASH_SECRET,
                            hashData.toString());

            query.append("&vnp_SecureHash=");
            query.append(secureHash);

            String paymentUrl =
                    VNPayConfig.PAY_URL
                            + "?"
                            + query;

            System.out.println("========== VNPAY ==========");
            System.out.println("ORDER ID = "
                    + order.getOrder_id());

            System.out.println("TOTAL = "
                    + order.getTotal_amount());

            System.out.println("AMOUNT = "
                    + amount);

            System.out.println("HASH DATA = "
                    + hashData);

            System.out.println("HASH = "
                    + secureHash);

            System.out.println("URL = "
                    + paymentUrl);

            System.out.println("===========================");

            resp.sendRedirect(paymentUrl);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500);
        }
    }
}