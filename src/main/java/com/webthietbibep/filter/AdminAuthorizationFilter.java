package com.webthietbibep.filter;

import com.webthietbibep.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@WebFilter(urlPatterns = "/admin/*")
public class AdminAuthorizationFilter implements Filter {
    private static final Set<String> OWNER_ONLY = new HashSet<>(Arrays.asList(
            "/admin/dashboard",
            "/admin/chart-data",
            "/admin/period-detail",
            "/admin/users",
            "/admin/staff",
            "/admin/banners",
            "/admin/content",
            "/admin/add-article"
    ));

    // WAREHOUSE được phép
    private static final Set<String> WAREHOUSE_ALLOWED = new HashSet<>(Arrays.asList(
            "/admin/products",
            "/admin/product-save",
            "/admin/product-list",
            "/admin/brands",
            "/admin/categories",
            "/admin/suppliers",
            "/admin/restock",
            "/admin/import",
            "/admin/import-history",
            "/admin/ecosystems",
            "/admin/combo-list",
            "/admin/combo-save",
            "/admin/delete-image"
    ));

    // SALES được phép
    private static final Set<String> SALES_ALLOWED = new HashSet<>(Arrays.asList(
            "/admin/order"
    ));

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        HttpSession session    = req.getSession(false);
        User        user       = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = user.getRole();
        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (path.contains("?")) path = path.substring(0, path.indexOf('?'));

        if ("OWNER".equals(role) || "ADMIN".equals(role)) {
            chain.doFilter(request, response);
            return;
        }

        if ("WAREHOUSE".equals(role)) {
            if (isAllowed(path, WAREHOUSE_ALLOWED)) {
                chain.doFilter(request, response);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/products");
            }
            return;
        }

        if ("SALES".equals(role)) {
            if (isAllowed(path, SALES_ALLOWED)) {
                chain.doFilter(request, response);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/order");
            }
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/Home");
    }

    private boolean isAllowed(String path, Set<String> allowedPrefixes) {
        for (String prefix : allowedPrefixes) {
            if (path.equals(prefix) || path.startsWith(prefix + "/") || path.startsWith(prefix + "?")) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void destroy() {}
}