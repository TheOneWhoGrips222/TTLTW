package com.webthietbibep.controller;

import com.google.gson.Gson;
import com.webthietbibep.services.GhnApiService;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;

@WebServlet("/api/shipping-fee")
public class ShippingFeeServlet
        extends HttpServlet {

    private final GhnApiService service =
            new GhnApiService();

    private final Gson gson =
            new Gson();

    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException {

        resp.setContentType(
                "application/json");

        try{

            int districtId =
                    Integer.parseInt(
                            req.getParameter(
                                    "to_district_id"));

            String wardCode =
                    req.getParameter(
                            "to_ward_code");

            long fee =
                    service
                            .calculateShippingFee(
                                    districtId,
                                    wardCode);

            resp.getWriter()
                    .print(
                            gson.toJson(
                                    Map.of(
                                            "status",
                                            "success",
                                            "fee",
                                            fee)));

        }
        catch(Exception e){

            resp.getWriter()
                    .print(
                            gson.toJson(
                                    Map.of(
                                            "status",
                                            "error",
                                            "message",
                                            e.getMessage())));
        }
    }
}