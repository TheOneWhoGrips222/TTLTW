package com.webthietbibep.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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

        System.out.println("===== GHN WEBHOOK =====");
        System.out.println(payload.toString());

        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("Webhook received");
    }
}