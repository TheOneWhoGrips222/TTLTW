package com.webthietbibep.services;

import com.google.gson.*;
import com.webthietbibep.model.Order;
import com.webthietbibep.model.UserAddress;
import com.webthietbibep.utils.GhnConfig;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

public class GhnOrderService {

    private final Gson gson = new Gson();

    public String createOrder(
            Order order,
            UserAddress address
    ) throws Exception {

        int serviceId =
                getServiceId(
                        address.getDistrict_id()
                );

        JsonObject body = new JsonObject();

        body.addProperty(
                "payment_type_id",
                2
        );

        body.addProperty(
                "required_note",
                "CHOXEMHANGKHONGTHU"
        );

        body.addProperty(
                "note",
                "Don test do an"
        );

        body.addProperty(
                "service_id",
                serviceId
        );

        body.addProperty(
                "from_name",
                "WEB THIET BI BEP"
        );

        body.addProperty(
                "from_phone",
                "0353334530"
        );

        body.addProperty(
                "from_address",
                "Quận 1"
        );

        body.addProperty(
                "from_ward_name",
                "Tân Định"
        );

        body.addProperty(
                "from_district_name",
                "Quận 1"
        );

        body.addProperty(
                "from_province_name",
                "Hồ Chí Minh"
        );

        body.addProperty(
                "to_name",
                address.getReceiver_name()
        );

        body.addProperty(
                "to_phone",
                address.getPhone()
        );

        body.addProperty(
                "to_address",
                address.getAddress_detail()
        );

        body.addProperty(
                "to_ward_code",
                address.getWard_code()
        );

        body.addProperty(
                "to_district_id",
                address.getDistrict_id()
        );

        body.addProperty(
                "cod_amount",
                (int) order.getTotal_amount()
        );

        body.addProperty(
                "weight",
                1000
        );

        body.addProperty(
                "length",
                20
        );

        body.addProperty(
                "width",
                15
        );

        body.addProperty(
                "height",
                10
        );

        JsonArray items = new JsonArray();

        JsonObject item = new JsonObject();

        item.addProperty(
                "name",
                "Thiết bị bếp"
        );

        item.addProperty(
                "quantity",
                1
        );

        item.addProperty(
                "price",
                (int)order.getTotal_amount()
        );

        item.addProperty(
                "length",
                20
        );

        item.addProperty(
                "width",
                15
        );

        item.addProperty(
                "height",
                10
        );

        item.addProperty(
                "weight",
                1000
        );

        items.add(item);

        body.add(
                "items",
                items
        );
        System.out.println("===== REQUEST BODY =====");
        System.out.println(
                gson.toJson(body)
        );

        URL url = new URL(
                GhnConfig.API_BASE_URL
                        + "/v2/shipping-order/create"
        );

        HttpURLConnection conn =
                (HttpURLConnection)
                        url.openConnection();

        conn.setRequestMethod(
                "POST"
        );

        conn.setDoOutput(true);

        conn.setRequestProperty(
                "Token",
                GhnConfig.TOKEN
        );

        conn.setRequestProperty(
                "ShopId",
                String.valueOf(
                        GhnConfig.SHOP_ID
                )
        );

        conn.setRequestProperty(
                "Content-Type",
                "application/json"
        );

        conn.getOutputStream()
                .write(
                        gson.toJson(body)
                                .getBytes(
                                        StandardCharsets.UTF_8
                                )
                );

        InputStream stream;

        if(conn.getResponseCode() >= 400){

            stream =
                    conn.getErrorStream();

        }else{

            stream =
                    conn.getInputStream();
        }

        JsonObject response =
                gson.fromJson(
                        new InputStreamReader(
                                stream,
                                StandardCharsets.UTF_8
                        ),
                        JsonObject.class
                );

        System.out.println(
                "CREATE ORDER HTTP="
                        + conn.getResponseCode()
        );

        System.out.println(
                response.toString()
        );

        if(conn.getResponseCode() >= 400){

            throw new RuntimeException(
                    response.toString()
            );
        }

        return response
                .getAsJsonObject("data")
                .get("order_code")
                .getAsString();
    }

    private int getServiceId(
            int toDistrictId
    ) throws Exception {

        int fromDistrictId = 1442;

        String url =
                GhnConfig.API_BASE_URL
                        + "/v2/shipping-order/available-services"
                        + "?shop_id="
                        + GhnConfig.SHOP_ID
                        + "&from_district="
                        + fromDistrictId
                        + "&to_district="
                        + toDistrictId;

        HttpURLConnection conn =
                (HttpURLConnection)
                        new URL(url)
                                .openConnection();

        conn.setRequestMethod(
                "GET"
        );

        conn.setRequestProperty(
                "Token",
                GhnConfig.TOKEN
        );

        InputStream stream;

        if(conn.getResponseCode() >= 400){

            stream =
                    conn.getErrorStream();

        }else{

            stream =
                    conn.getInputStream();
        }

        JsonObject response =
                gson.fromJson(
                        new InputStreamReader(
                                stream,
                                StandardCharsets.UTF_8
                        ),
                        JsonObject.class
                );

        System.out.println(
                "SERVICE HTTP="
                        + conn.getResponseCode()
        );

        System.out.println(
                response.toString()
        );

        if(conn.getResponseCode() >= 400){

            throw new RuntimeException(
                    response.toString()
            );
        }

        JsonArray data =
                response.getAsJsonArray(
                        "data"
                );

        if(data == null || data.size() == 0){

            throw new RuntimeException(
                    "GHN khong co service"
            );
        }

        return data
                .get(0)
                .getAsJsonObject()
                .get("service_id")
                .getAsInt();
    }
}