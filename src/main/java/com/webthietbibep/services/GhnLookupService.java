package com.webthietbibep.services;

import com.google.gson.*;
import com.webthietbibep.utils.GhnConfig;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

public class GhnLookupService {

    private final Gson gson = new Gson();

    public int findDistrictIdByName(
            String districtName)
            throws Exception {

        URL url =
                new URL(
                        GhnConfig.API_BASE_URL +
                                "/master-data/district");

        HttpURLConnection conn =
                (HttpURLConnection)
                        url.openConnection();

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

        JsonArray districts =
                response.getAsJsonArray("data");

        for(JsonElement e : districts){

            JsonObject d =
                    e.getAsJsonObject();

            String name =
                    d.get("DistrictName")
                            .getAsString();

            if(name.equalsIgnoreCase(
                    districtName)){

                return d.get("DistrictID")
                        .getAsInt();
            }
        }

        throw new Exception(
                "Không tìm thấy GHN DistrictID.");
    }

    public String findWardCodeByName(
            int districtId,
            String wardName)
            throws Exception {

        URL url =
                new URL(
                        GhnConfig.API_BASE_URL +
                                "/master-data/ward?district_id="
                                + districtId);

        HttpURLConnection conn =
                (HttpURLConnection)
                        url.openConnection();

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

        JsonArray wards =
                response.getAsJsonArray("data");

        for(JsonElement e : wards){

            JsonObject w =
                    e.getAsJsonObject();

            String name =
                    w.get("WardName")
                            .getAsString();

            if(name.equalsIgnoreCase(
                    wardName)){

                return w.get("WardCode")
                        .getAsString();
            }
        }

        throw new Exception(
                "Không tìm thấy GHN WardCode.");
    }
}