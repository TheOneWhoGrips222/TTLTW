package com.webthietbibep.services;

import com.google.gson.*;
import com.webthietbibep.dao.UserAddressDAO;
import com.webthietbibep.model.Order;
import com.webthietbibep.model.UserAddress;
import com.webthietbibep.utils.GhnConfig;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

public class GhnOrderService {

    private final Gson gson=new Gson();

    public String createOrder(
            Order order,
            UserAddress address
    ) throws Exception {

        JsonObject body=new JsonObject();

        body.addProperty(
                "payment_type_id",
                2
        );

        body.addProperty(
                "note",
                "Đơn test đồ án"
        );

        body.addProperty(
                "required_note",
                "CHOXEMHANGKHONGTHU"
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
                "QUẬN 1"
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
                (int)order.getTotal_amount()
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

        URL url=new URL(

                GhnConfig.API_BASE_URL+
                        "/v2/shipping-order/create"

        );

        HttpURLConnection conn=
                (HttpURLConnection)
                        url.openConnection();

        conn.setRequestMethod("POST");

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

        conn.setDoOutput(true);

        conn.getOutputStream()
                .write(
                        gson.toJson(body)
                                .getBytes(
                                        StandardCharsets.UTF_8
                                )
                );

        JsonObject response=
                gson.fromJson(

                        new InputStreamReader(
                                conn.getInputStream(),
                                StandardCharsets.UTF_8
                        ),

                        JsonObject.class
                );

        System.out.println(
                response.toString()
        );

        return response
                .getAsJsonObject("data")
                .get("order_code")
                .getAsString();
    }

}