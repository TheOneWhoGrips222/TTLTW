package com.webthietbibep.services;

import com.google.gson.*;
import com.webthietbibep.utils.GhnConfig;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

public class GhnApiService {

    private final Gson gson =
            new Gson();

    public long calculateShippingFee(
            int toDistrictId,
            String toWardCode)
            throws Exception {

        int fromDistrictId =
                1442;

        String serviceUrl =
                GhnConfig.API_BASE_URL +
                        "/v2/shipping-order/available-services"
                        +
                        "?shop_id="
                        + GhnConfig.SHOP_ID
                        +
                        "&from_district="
                        + fromDistrictId
                        +
                        "&to_district="
                        + toDistrictId;

        HttpURLConnection conn =
                (HttpURLConnection)
                        new URL(serviceUrl)
                                .openConnection();

        conn.setRequestMethod("GET");

        conn.setRequestProperty(
                "Token",
                GhnConfig.TOKEN);

        JsonObject response =
                gson.fromJson(
                        new InputStreamReader(
                                conn.getInputStream(),
                                StandardCharsets.UTF_8),
                        JsonObject.class);

        JsonArray services =
                response
                        .getAsJsonArray(
                                "data");

        if(services==null
                || services.size()==0){

            throw new Exception(
                    "Không có dịch vụ vận chuyển.");
        }

        int serviceId =
                services
                        .get(0)
                        .getAsJsonObject()
                        .get("service_id")
                        .getAsInt();

        JsonObject body =
                new JsonObject();

        body.addProperty(
                "service_id",
                serviceId);

        body.addProperty(
                "from_district_id",
                fromDistrictId);

        body.addProperty(
                "to_district_id",
                toDistrictId);

        body.addProperty(
                "to_ward_code",
                toWardCode);

        body.addProperty(
                "weight",
                500);

        HttpURLConnection feeConn =
                (HttpURLConnection)
                        new URL(
                                GhnConfig.API_BASE_URL
                                        +
                                        "/v2/shipping-order/fee")
                                .openConnection();

        feeConn.setRequestMethod(
                "POST");

        feeConn.setDoOutput(true);

        feeConn.setRequestProperty(
                "Token",
                GhnConfig.TOKEN);

        feeConn.setRequestProperty(
                "ShopId",
                String.valueOf(
                        GhnConfig.SHOP_ID));

        feeConn.setRequestProperty(
                "Content-Type",
                "application/json");

        feeConn.getOutputStream()
                .write(
                        gson.toJson(body)
                                .getBytes(
                                        StandardCharsets.UTF_8));

        JsonObject feeResponse =
                gson.fromJson(
                        new InputStreamReader(
                                feeConn.getInputStream(),
                                StandardCharsets.UTF_8),
                        JsonObject.class);

        return feeResponse
                .getAsJsonObject("data")
                .get("total")
                .getAsLong();
    }
}