package com.webthietbibep.controller;

import com.webthietbibep.dao.OrdersDAO;
import com.webthietbibep.model.Order;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.BufferedReader;
import java.io.IOException;

import org.json.JSONObject;

@WebServlet("/ghn-webhook")
public class GHNWebhookServlet extends HttpServlet {

    private OrdersDAO orderDAO = new OrdersDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        StringBuilder payload = new StringBuilder();

        BufferedReader reader = request.getReader();

        String line;

        while((line=reader.readLine())!=null){
            payload.append(line);
        }

        JSONObject json=new JSONObject(payload.toString());

        String ghnStatus=json.optString("status");
        String orderCode=json.optString("order_code");

        System.out.println("===== GHN WEBHOOK =====");
        System.out.println("GHN STATUS: "+ghnStatus);
        System.out.println("ORDER CODE: "+orderCode);

        Order order=orderDAO.getByGhnCode(orderCode);

        if(order!=null){

            String appStatus=switch (ghnStatus){

                case "ready_to_pick",
                     "picking" -> "CHO_XAC_NHAN";

                case "transporting",
                     "sorting" -> "VAN_CHUYEN";

                case "delivering" -> "CHO_GIAO_HANG";

                case "delivered" -> "HOAN_THANH";

                case "cancel" -> "DA_HUY";

                default -> null;
            };

            if(appStatus!=null){

                orderDAO.updateStatus(
                        order.getOrder_id(),
                        appStatus
                );

                System.out.println(
                        "UPDATED -> "+appStatus
                );
            }
        }

        response.getWriter()
                .write("Webhook processed");
    }
}