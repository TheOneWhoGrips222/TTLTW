package com.webthietbibep.utils;

import com.google.gson.Gson;
import com.webthietbibep.model.GoogleUser;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class GoogleUtils {

    private static final String CLIENT_ID = "";
    private static final String CLIENT_SECRET = "";
    private static final String REDIRECT_URI = "http://localhost:8080/demo_war/login-google";

    private static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String USER_INFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";

    public static String getToken(String code) {
        try {
            URL url = new URL(TOKEN_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setDoOutput(true);

            String params =
                    "code=" + code +
                            "&client_id=" + CLIENT_ID +
                            "&client_secret=" + CLIENT_SECRET +
                            "&redirect_uri=" + REDIRECT_URI +
                            "&grant_type=authorization_code";

            OutputStream os = conn.getOutputStream();
            os.write(params.getBytes(StandardCharsets.UTF_8));
            os.flush();
            os.close();

            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));

            StringBuilder response = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            reader.close();

            Gson gson = new Gson();
            TokenResponse tokenResponse = gson.fromJson(response.toString(), TokenResponse.class);

            return tokenResponse.getAccess_token();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static GoogleUser getUserInfo(String accessToken) {
        try {
            String urlStr = USER_INFO_URL + "?access_token=" + accessToken;
            URL url = new URL(urlStr);

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader reader = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8)
            );

            StringBuilder response = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            reader.close();

            Gson gson = new Gson();
            return gson.fromJson(response.toString(), GoogleUser.class);

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}