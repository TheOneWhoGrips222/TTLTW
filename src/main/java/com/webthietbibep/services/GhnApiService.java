package com.webthietbibep.services;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.webthietbibep.utils.GhnConfig;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class GhnApiService {

    private final Gson gson = new Gson();

    public long calculateShippingFee(int toDistrictId, String toWardCode) throws Exception {
        try {

            int fromDistrictId = 1442;
            if(toDistrictId <= 0) {
                 throw new Exception("Mã Quận/Huyện người nhận không hợp lệ.");
            }

            System.out.println("Calculating fee from District " + fromDistrictId + " to District " + toDistrictId);

            String availableServicesUrl = GhnConfig.API_BASE_URL + "/v2/shipping-order/available-services" +
                    "?shop_id=" + GhnConfig.SHOP_ID +
                    "&from_district=" + fromDistrictId +
                    "&to_district=" + toDistrictId; 

            URL serviceUrl = new URL(availableServicesUrl);
            HttpURLConnection serviceConn = (HttpURLConnection) serviceUrl.openConnection();
            serviceConn.setRequestMethod("GET");
            serviceConn.setRequestProperty("Token", GhnConfig.TOKEN);
            serviceConn.setRequestProperty("Content-Type", "application/json");

            int serviceResponseCode = serviceConn.getResponseCode();
            if (serviceResponseCode != HttpURLConnection.HTTP_OK) {
                 BufferedReader errStream = new BufferedReader(new InputStreamReader(serviceConn.getErrorStream(), StandardCharsets.UTF_8));
                 StringBuilder errResponse = new StringBuilder();
                 String inputLine;
                 while ((inputLine = errStream.readLine()) != null) {
                     errResponse.append(inputLine);
                 }
                 errStream.close();
                 System.out.println("Lỗi API available-services: " + errResponse.toString());
                throw new Exception("Không thể lấy danh sách dịch vụ từ GHN (HTTP " + serviceResponseCode + ")");
            }

            BufferedReader serviceIn = new BufferedReader(new InputStreamReader(serviceConn.getInputStream(), StandardCharsets.UTF_8));
            JsonObject serviceJsonResponse = gson.fromJson(serviceIn, JsonObject.class);
            serviceIn.close();

            System.out.println("Available Services Response: " + serviceJsonResponse.toString());

            if (serviceJsonResponse.get("code").getAsInt() != 200) {
                throw new Exception("GHN báo lỗi khi lấy dịch vụ: " + serviceJsonResponse.get("message").getAsString());
            }

            JsonElement dataElement = serviceJsonResponse.get("data");
            if (dataElement == null || dataElement.isJsonNull() || !dataElement.isJsonArray()) {
                throw new Exception("Không có dịch vụ vận chuyển nào cho tuyến đường này (data is null or not an array).");
            }

            JsonArray services = dataElement.getAsJsonArray();
            if (services.size() == 0) {
                throw new Exception("Không có dịch vụ vận chuyển nào cho tuyến đường này (array is empty).");
            }

            int serviceId = services.get(0).getAsJsonObject().get("service_id").getAsInt();

            JsonObject feeRequest = new JsonObject();
            feeRequest.addProperty("service_id", serviceId);
            feeRequest.addProperty("insurance_value", 500000);
            feeRequest.addProperty("coupon", "");
            feeRequest.addProperty("from_district_id", fromDistrictId);
            feeRequest.addProperty("to_district_id", toDistrictId);
            feeRequest.addProperty("to_ward_code", toWardCode);
            feeRequest.addProperty("weight", 200);
            feeRequest.addProperty("length", 20);
            feeRequest.addProperty("width", 15);
            feeRequest.addProperty("height", 10);
            
            String feeUrlString = GhnConfig.API_BASE_URL + GhnConfig.FEE_API_PATH;

            URL feeUrl = new URL(feeUrlString);
            HttpURLConnection feeConn = (HttpURLConnection) feeUrl.openConnection();
            feeConn.setRequestMethod("POST"); // GHN API v2 FEE thường là POST
            feeConn.setRequestProperty("Content-Type", "application/json");
            feeConn.setRequestProperty("Token", GhnConfig.TOKEN);
            feeConn.setRequestProperty("ShopId", String.valueOf(GhnConfig.SHOP_ID));
            feeConn.setDoOutput(true);
            
            feeConn.getOutputStream().write(gson.toJson(feeRequest).getBytes(StandardCharsets.UTF_8));

            int feeResponseCode = feeConn.getResponseCode();
            if (feeResponseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader feeIn = new BufferedReader(new InputStreamReader(feeConn.getInputStream(), StandardCharsets.UTF_8));
                JsonObject feeJsonResponse = gson.fromJson(feeIn, JsonObject.class);
                feeIn.close();

                if (feeJsonResponse.get("code").getAsInt() == 200) {
                    return feeJsonResponse.getAsJsonObject("data").get("total").getAsLong();
                } else {
                    throw new Exception("Lỗi từ GHN: " + feeJsonResponse.get("message").getAsString());
                }
            } else {
                BufferedReader errStream = new BufferedReader(new InputStreamReader(feeConn.getErrorStream(), StandardCharsets.UTF_8));
                JsonObject errJsonResponse = gson.fromJson(errStream, JsonObject.class);
                errStream.close();
                throw new Exception("Lỗi từ GHN: " + errJsonResponse.toString());
            }

        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }
}