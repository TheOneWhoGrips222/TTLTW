package com.webthietbibep.controller;

import com.google.gson.Gson;
import com.webthietbibep.services.GhnApiService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet("/api/shipping-fee")
public class ShippingFeeServlet extends HttpServlet {

    private final GhnApiService ghnApiService = new GhnApiService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int toDistrictId = Integer.parseInt(request.getParameter("to_district_id"));
            String toWardCode = request.getParameter("to_ward_code");

            if (toWardCode == null || toWardCode.isBlank()) {
                throw new IllegalArgumentException("Ward code is required.");
            }

            long fee = ghnApiService.calculateShippingFee(toDistrictId, toWardCode);
            out.print(gson.toJson(Map.of("status", "success", "fee", fee)));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_OK);
            out.print(gson.toJson(Map.of("status", "error", "message", e.getMessage())));
        }
        out.flush();
    }
}