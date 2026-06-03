package com.webthietbibep.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/ghn-webhook")
public class GHNWebhookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        StringBuilder payload = new StringBuilder();

        BufferedReader reader = request.getReader();
        String line;

        while ((line = reader.readLine()) != null) {
            payload.append(line);
        }

        try {
            JSONObject json = new JSONObject(payload.toString());

            String status = json.optString("status");
            String orderCode = json.optString("order_code");

            System.out.println("===== GHN WEBHOOK =====");
            System.out.println("Status: " + status);
            System.out.println("Order Code: " + orderCode);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Webhook processed");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid JSON");
        }
    }
}