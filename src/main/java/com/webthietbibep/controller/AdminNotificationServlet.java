package com.webthietbibep.controller;

import com.webthietbibep.dao.NotificationDAO;
import com.webthietbibep.model.Notification;
import com.webthietbibep.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.format.DateTimeFormatter;
import java.util.List;


@WebServlet(name = "AdminNotificationServlet", urlPatterns = "/admin/notifications")
public class AdminNotificationServlet extends HttpServlet {

    private static final int MAX_NOTIFICATIONS = 20;
    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("HH:mm dd/MM");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache, no-store");

        NotificationDAO dao = new NotificationDAO();
        String contextPath = req.getContextPath();
        PrintWriter out = resp.getWriter();

        String countOnly = req.getParameter("count");
        if ("1".equals(countOnly)) {
            int count = dao.countUnread(contextPath);
            out.print("{\"count\":" + count + "}");
            return;
        }

        List<Notification> notifications = dao.getAll(contextPath, MAX_NOTIFICATIONS);
        out.print(toJson(notifications));
    }

    private String toJson(List<Notification> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            Notification n = list.get(i);
            if (i > 0) sb.append(",");
            sb.append("{");
            sb.append("\"id\":").append(jsonStr(n.getId())).append(",");
            sb.append("\"type\":").append(jsonStr(n.getType().name())).append(",");
            sb.append("\"title\":").append(jsonStr(n.getTitle())).append(",");
            sb.append("\"message\":").append(jsonStr(n.getMessage())).append(",");
            sb.append("\"link\":").append(jsonStr(n.getLink())).append(",");
            sb.append("\"icon\":").append(jsonStr(n.getIcon())).append(",");
            sb.append("\"colorClass\":").append(jsonStr(n.getColorClass())).append(",");
            sb.append("\"time\":").append(jsonStr(
                    n.getCreatedAt() != null ? n.getCreatedAt().format(FMT) : ""
            )).append(",");
            sb.append("\"isRead\":").append(n.isRead());
            sb.append("}");
        }
        sb.append("]");
        return sb.toString();
    }

    private String jsonStr(String s) {
        if (s == null) return "\"\"";
        return "\"" + s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "") + "\"";
    }
}