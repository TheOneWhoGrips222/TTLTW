package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.utils.VNPayConfig;
import com.webthietbibep.utils.VnPayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;

@WebServlet("/payment/vnpay-return")
public class VnPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            Map<String, String> fields = new HashMap<>();
            Enumeration<String> params = req.getParameterNames();

            while (params.hasMoreElements()) {
                String fieldName = params.nextElement();
                String fieldValue = req.getParameter(fieldName);

                if (fieldValue != null && fieldValue.length() > 0) {
                    fields.put(fieldName, fieldValue);
                }
            }

            String vnpSecureHash = fields.remove("vnp_SecureHash");
            fields.remove("vnp_SecureHashType");
            List<String> fieldNames = new ArrayList<>(fields.keySet());
            Collections.sort(fieldNames);

            StringBuilder hashData = new StringBuilder();
            Iterator<String> itr = fieldNames.iterator();

            while (itr.hasNext()) {
                String fieldName = itr.next();
                String fieldValue = fields.get(fieldName);

                if (fieldValue != null && !fieldValue.isEmpty()) {
                    hashData.append(fieldName);
                    hashData.append("=");
                    hashData.append(fieldValue);

                    hashData.append("&");
                }
            }

            if (hashData.length() > 0) {
                hashData.setLength(hashData.length() - 1);
            }

            String signValue = VnPayUtil.hmacSHA512(VNPayConfig.HASH_SECRET, hashData.toString());

            System.out.println("========== RETURN DEBUG ==========");
            System.out.println("HASH DATA = " + hashData);
            System.out.println("VNP HASH  = " + vnpSecureHash);
            System.out.println("MY HASH   = " + signValue);
            System.out.println("==================================");

            if (vnpSecureHash == null || !vnpSecureHash.equalsIgnoreCase(signValue)) {
                System.out.println("INVALID SIGNATURE - SAI CHỮ KÝ");
                resp.sendRedirect(req.getContextPath() + "/payment-fail.jsp");
                return;
            }

            String txnRef = req.getParameter("vnp_TxnRef");
            String responseCode = req.getParameter("vnp_ResponseCode");
            String transactionNo = req.getParameter("vnp_TransactionNo");

            if (txnRef == null) {
                resp.sendRedirect(req.getContextPath() + "/payment-fail.jsp");
                return;
            }

            int orderId = Integer.parseInt(txnRef);
            OrdersDAO dao = new OrdersDAO();

            if ("00".equals(responseCode)) {
                dao.updatePaymentSuccess(orderId, transactionNo);

                resp.sendRedirect(
                        req.getContextPath()
                                + "/payment?orderId=" + orderId
                                + "&result=success");

            } else {

                dao.updatePaymentFail(orderId);

                resp.sendRedirect(
                        req.getContextPath()
                                + "/payment?orderId=" + orderId
                                + "&result=fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/payment");
        }
    }
}