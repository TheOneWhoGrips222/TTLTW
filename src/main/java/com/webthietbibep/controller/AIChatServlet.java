package com.webthietbibep.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;

@WebServlet(name = "AIChatServlet", urlPatterns = {"/ai-chat"})
public class AIChatServlet extends HttpServlet {

    private String getApiKey() {
        String key = System.getenv("GEMINI_API_KEY");
        if (key == null || key.isBlank()) {
            key = getServletContext().getInitParameter("geminiApiKey");
        }
        return (key != null) ? key.trim() : null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String mode    = null;
        String message = null;
        String history = null;

        String contentType = request.getContentType();
        if (contentType != null && contentType.contains("application/x-www-form-urlencoded")) {
            String body = request.getReader().lines().collect(Collectors.joining());
            for (String pair : body.split("&")) {
                String[] kv = pair.split("=", 2);
                if (kv.length == 2) {
                    String key = java.net.URLDecoder.decode(kv[0], StandardCharsets.UTF_8);
                    String val = java.net.URLDecoder.decode(kv[1], StandardCharsets.UTF_8);
                    switch (key) {
                        case "mode"    -> mode    = val;
                        case "message" -> message = val;
                        case "history" -> history = val;
                    }
                }
            }
        } else {
            mode    = request.getParameter("mode");
            message = request.getParameter("message");
            history = request.getParameter("history");
        }

        if (message == null || message.isBlank()) {
            response.getWriter().write("{\"error\":\"Tin nhắn không được để trống\"}");
            return;
        }

        if ("admin".equals(mode)) {
            HttpSession session = request.getSession(false);
            Object user = (session != null) ? session.getAttribute("user") : null;
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"Bạn cần đăng nhập để sử dụng tính năng này\"}");
                return;
            }
        }

        String systemPrompt = "admin".equals(mode)
                ? "Bạn là trợ lý quản trị của cửa hàng thiết bị bếp WebThietBiBep. Trả lời ngắn gọn, chuyên nghiệp bằng tiếng Việt."
                : "Bạn là tư vấn viên của cửa hàng thiết bị bếp WebThietBiBep. Trả lời ngắn gọn, thân thiện bằng tiếng Việt.";

        String aiReply = callGeminiWithRetry(systemPrompt, message, history);
        response.getWriter().write("{\"reply\":" + escapeJson(aiReply) + "}");
    }

    // Tự động thử lại tối đa 3 lần nếu bị 429
    private String callGeminiWithRetry(String systemPrompt, String userMessage, String historyJson)
            throws IOException {
        int[] delays = {0, 5000, 15000}; // thử ngay, sau 5s, sau 15s
        for (int i = 0; i < delays.length; i++) {
            if (delays[i] > 0) {
                try { Thread.sleep(delays[i]); } catch (InterruptedException ignored) {}
            }
            String result = callGeminiAPI(systemPrompt, userMessage, historyJson);
            // Nếu không phải lỗi 429 thì trả về luôn
            if (!result.startsWith("__429__")) return result;
            System.out.println("[AIChatServlet] 429 - thử lại lần " + (i + 1) + " sau " + delays[i] + "ms");
        }
        return "⚠️ Hệ thống AI đang bận, vui lòng thử lại sau vài giây.";
    }

    private String callGeminiAPI(String systemPrompt, String userMessage, String historyJson)
            throws IOException {

        String apiKey = getApiKey();
        if (apiKey == null || apiKey.isBlank()) {
            return "⚠️ Chưa cấu hình Gemini API Key. Kiểm tra web.xml.";
        }

        String body = "{"
                + "\"contents\":[{\"role\":\"user\",\"parts\":[{\"text\":" + escapeJson(userMessage) + "}]}],"
                + "\"systemInstruction\":{\"parts\":[{\"text\":" + escapeJson(systemPrompt) + "}]},"
                + "\"generationConfig\":{\"maxOutputTokens\":200}"
                + "}";

        String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + apiKey;

        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);
        conn.setConnectTimeout(15000);
        conn.setReadTimeout(30000);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.getBytes(StandardCharsets.UTF_8));
        }

        int status = conn.getResponseCode();
        InputStream is = (status == 200) ? conn.getInputStream() : conn.getErrorStream();
        String responseStr;
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            responseStr = br.lines().collect(Collectors.joining());
        }

        if (status == 429) {
            System.err.println("[AIChatServlet] 429 Rate limit: " + responseStr);
            return "__429__"; // signal để retry
        }

        if (status != 200) {
            System.err.println("[AIChatServlet] Lỗi Gemini HTTP " + status + ": " + responseStr);
            return "⚠️ Lỗi kết nối AI (HTTP " + status + "). Vui lòng kiểm tra console của Server.";
        }

        return extractGeminiText(responseStr);
    }

    private String extractGeminiText(String json) {
        try {
            int idx = json.indexOf("\"text\":");
            if (idx == -1) return "Không nhận được phản hồi từ AI.";
            int start = json.indexOf("\"", idx + 7) + 1;
            int end = start;
            boolean esc = false;
            while (end < json.length()) {
                char c = json.charAt(end);
                if (esc) { esc = false; end++; continue; }
                if (c == '\\') { esc = true; end++; continue; }
                if (c == '"') break;
                end++;
            }
            return json.substring(start, end)
                    .replace("\\n", "\n").replace("\\t", "\t")
                    .replace("\\\"", "\"").replace("\\\\", "\\")
                    .replace("\\/", "/");
        } catch (Exception e) {
            return "Có lỗi xử lý phản hồi từ AI.";
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "null";
        StringBuilder sb = new StringBuilder("\"");
        for (char c : s.toCharArray()) {
            switch (c) {
                case '"'  -> sb.append("\\\"");
                case '\\' -> sb.append("\\\\");
                case '\n' -> sb.append("\\n");
                case '\r' -> sb.append("\\r");
                case '\t' -> sb.append("\\t");
                default   -> sb.append(c);
            }
        }
        return sb.append("\"").toString();
    }
}