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

    private static final String TMN_CODE = VNPayConfig.TMN_CODE;
    private static final String HASH_SECRET = VNPayConfig.HASH_SECRET;
    private static final String PAY_URL = VNPayConfig.PAY_URL;
    private static final String RETURN_URL = VNPayConfig.RETURN_URL;

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        try {

            int orderId =
                    Integer.parseInt(req.getParameter("orderId"));

            OrdersDAO ordersDAO = new OrdersDAO();

            Order order =
                    ordersDAO.getOrderById(orderId);

            if (order == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            System.out.println("========== ORDER ==========");
            System.out.println("ORDER ID = " + order.getOrder_id());
            System.out.println("TOTAL = " + order.getTotal_amount());

            long amount =
                    Math.round(order.getTotal_amount() * 100);

            System.out.println("VNP_AMOUNT = " + amount);

            String txnRef =
                    String.valueOf(order.getOrder_id());

            Calendar calendar =
                    Calendar.getInstance(
                            TimeZone.getTimeZone("Asia/Ho_Chi_Minh")
                    );

            String createDate =
                    new SimpleDateFormat("yyyyMMddHHmmss")
                            .format(calendar.getTime());

            calendar.add(Calendar.MINUTE, 15);

            String expireDate =
                    new SimpleDateFormat("yyyyMMddHHmmss")
                            .format(calendar.getTime());

            Map<String, String> params =
                    new HashMap<>();

            params.put("vnp_Version", "2.1.0");
            params.put("vnp_Command", "pay");
            params.put("vnp_TmnCode", TMN_CODE);

            params.put("vnp_Amount",
                    String.valueOf(amount));

            params.put("vnp_CurrCode", "VND");

            params.put("vnp_TxnRef", txnRef);

            params.put(
                    "vnp_OrderInfo",
                    "ThanhToanDonHang" + orderId
            );

            params.put("vnp_OrderType", "other");

            params.put("vnp_Locale", "vn");

            params.put(
                    "vnp_ReturnUrl",
                    RETURN_URL
            );

            params.put(
                    "vnp_IpAddr",
                    "127.0.0.1"
            );

            params.put(
                    "vnp_CreateDate",
                    createDate
            );

            params.put(
                    "vnp_ExpireDate",
                    expireDate
            );

            List<String> fieldNames =
                    new ArrayList<>(params.keySet());

            Collections.sort(fieldNames);

            StringBuilder hashData =
                    new StringBuilder();

            StringBuilder query =
                    new StringBuilder();

            Iterator<String> itr =
                    fieldNames.iterator();

            while (itr.hasNext()) {

                String fieldName =
                        itr.next();

                String fieldValue =
                        params.get(fieldName);

                if (fieldValue != null
                        && !fieldValue.isEmpty()) {

                    // KHI XÂY DỰNG HASHDATA, KHÔNG URLEncoder.encode() FIELDVALUE
                    hashData.append(fieldName);
                    hashData.append("=");
                    hashData.append(fieldValue); // <--- ĐÃ SỬA Ở ĐÂY

                    // KHI XÂY DỰNG QUERY, CÓ URLEncoder.encode() FIELDNAME VÀ FIELDVALUE
                    query.append(
                            URLEncoder.encode(
                                    fieldName,
                                    StandardCharsets.UTF_8 // Đã sửa sang UTF_8
                            )
                    );

                    query.append("=");

                    query.append(
                            URLEncoder.encode(
                                    fieldValue,
                                    StandardCharsets.UTF_8 // Đã sửa sang UTF_8
                            )
                    );

                    if (itr.hasNext()) {
                        hashData.append("&");
                        query.append("&");
                    }
                }
            }

            String secureHash =
                    VnPayUtil.hmacSHA512(
                            HASH_SECRET,
                            hashData.toString()
                    );

            query.append("&vnp_SecureHash=");
            query.append(secureHash);

            String paymentUrl =
                    PAY_URL + "?" + query;

            System.out.println("\n========== VNPAY DEBUG ==========");
            System.out.println("TMN_CODE = " + TMN_CODE);
            System.out.println("RETURN_URL = " + RETURN_URL);
            System.out.println("SECRET = " + HASH_SECRET);

            System.out.println("\nHASH DATA (RAW):"); // Đổi tên để dễ phân biệt
            System.out.println(hashData);

            System.out.println("\nSECURE HASH:");
            System.out.println(secureHash);

            System.out.println("\nPAYMENT URL:");
            System.out.println(paymentUrl);

            System.out.println("=================================\n");

            resp.sendRedirect(paymentUrl);

        } catch (Exception e) {

            e.printStackTrace();

            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage()
            );
        }
    }
}