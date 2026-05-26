package com.webthietbibep.utils;


import java.net.*;
import java.io.*;

public class GhnTest {

    public static void main(String[] args) throws Exception {

        URL url = new URL(
                "https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/ward?district_id=1442"
        );

        HttpURLConnection conn =
                (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("GET");

        conn.setRequestProperty(
                "Token",
                "26a33ce0-56ac-11f1-a973-aee5264794df"
        );

        int code = conn.getResponseCode();

        System.out.println("HTTP CODE = " + code);

        BufferedReader br =
                new BufferedReader(
                        new InputStreamReader(
                                conn.getInputStream()
                        )
                );

        String line;

        while ((line = br.readLine()) != null) {
            System.out.println(line);
        }

        br.close();
    }
}