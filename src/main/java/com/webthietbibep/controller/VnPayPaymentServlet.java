package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.model.Order;
import com.webthietbibep.utils.VnPayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/payment/vnpay")
public class VnPayPaymentServlet extends HttpServlet {

    private static final String TMN_CODE = "ICSBUOBM";
    private static final String HASH_SECRET = "5I57399ZPCTE4FXVXUE809L16IP06FF6";

    private static final String PAY_URL =
            "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";

    private static final String RETURN_URL =
            "https://shopdungcunhabep.id.vn/demo-1.0-SNAPSHOT/payment/vnpay-return";

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        int orderId =
                Integer.parseInt(req.getParameter("orderId"));

        OrdersDAO ordersDAO = new OrdersDAO();

        Order order = ordersDAO.getOrderById(orderId);

        if(order == null){
            resp.sendError(404);
            return;
        }

        long amount =
                (long)(order.getTotal_amount() * 100);

        String txnRef =
                String.valueOf(order.getOrder_id());

        Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("GMT+7"));

        String createDate =
                new SimpleDateFormat("yyyyMMddHHmmss")
                        .format(cal.getTime());

        cal.add(Calendar.MINUTE,15);

        String expireDate =
                new SimpleDateFormat("yyyyMMddHHmmss")
                        .format(cal.getTime());

        Map<String,String> params = new HashMap<>();

        params.put("vnp_Version","2.1.0");
        params.put("vnp_Command","pay");
        params.put("vnp_TmnCode",TMN_CODE);

        params.put("vnp_Amount",
                String.valueOf(amount));

        params.put("vnp_CurrCode","VND");

        params.put("vnp_TxnRef",txnRef);

        params.put("vnp_OrderInfo",
                "Thanh toan don hang #" + orderId);

        params.put("vnp_OrderType","other");

        params.put("vnp_Locale","vn");

        params.put("vnp_ReturnUrl",RETURN_URL);

        params.put("vnp_IpAddr",
                req.getRemoteAddr());

        params.put("vnp_CreateDate",
                createDate);

        params.put("vnp_ExpireDate",
                expireDate);

        List<String> fieldNames =
                new ArrayList<>(params.keySet());

        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        for(String field : fieldNames){

            String value = params.get(field);

            if(value != null && !value.isEmpty()){

                hashData.append(field)
                        .append("=")
                        .append(URLEncoder.encode(value,
                                StandardCharsets.US_ASCII));

                query.append(URLEncoder.encode(field,
                                StandardCharsets.US_ASCII))
                        .append("=")
                        .append(URLEncoder.encode(value,
                                StandardCharsets.US_ASCII));

                hashData.append("&");
                query.append("&");
            }
        }

        hashData.deleteCharAt(hashData.length()-1);
        query.deleteCharAt(query.length()-1);

        String secureHash =
                VnPayUtil.hmacSHA512(
                        HASH_SECRET,
                        hashData.toString());

        query.append("&vnp_SecureHash=")
                .append(secureHash);

        String paymentUrl =
                PAY_URL + "?" + query;

        resp.sendRedirect(paymentUrl);
    }
}