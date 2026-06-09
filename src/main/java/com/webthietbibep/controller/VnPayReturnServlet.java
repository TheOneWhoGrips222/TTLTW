package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/payment/vnpay-return")
public class VnPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        String txnRef =
                req.getParameter("vnp_TxnRef");

        String responseCode =
                req.getParameter("vnp_ResponseCode");

        String transactionNo =
                req.getParameter("vnp_TransactionNo");

        if(txnRef == null){
            resp.sendRedirect(
                    req.getContextPath() +
                            "/checkout?error");
            return;
        }

        int orderId =
                Integer.parseInt(txnRef);

        OrdersDAO dao = new OrdersDAO();

        if("00".equals(responseCode)){

            dao.updatePaymentSuccess(
                    orderId,
                    transactionNo
            );

            resp.sendRedirect(
                    req.getContextPath()
                            + "/payment-success.jsp");

        } else {

            dao.updatePaymentFail(orderId);

            resp.sendRedirect(
                    req.getContextPath()
                            + "/payment-fail.jsp");
        }
    }
}