package com.webthietbibep.controller;

import com.webthietbibep.dao.ProductDAO;
import com.webthietbibep.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

@WebServlet("/api/product-search")
public class ProductSearchApiServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String query = req.getParameter("q");

        try (PrintWriter out = resp.getWriter()) {
            if (query == null || query.trim().isEmpty()) {
                out.print("[]");
                return;
            }

            List<Product> products = productDAO.searchByNameLimit(query.trim(), 5);

            StringBuilder json = new StringBuilder();
            json.append("[");

            NumberFormat vn = NumberFormat.getInstance(new Locale("vi", "VN"));

            for (int i = 0; i < products.size(); i++) {
                Product p = products.get(i);
                json.append("{");
                json.append("\"product_id\":").append(p.getProduct_id()).append(",");

                String safeName = p.getProduct_name().replace("\"", "\\\"");
                String safeImage = (p.getImage() != null) ? p.getImage().replace("\\", "/") : "no-image.png";
                String priceFmt = vn.format(p.getPrice());

                json.append("\"product_name\":\"").append(safeName).append("\",");
                json.append("\"image\":\"").append(safeImage).append("\",");
                json.append("\"price_format\":\"").append(priceFmt).append(" đ\"");
                json.append("}");

                if (i < products.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
        }
    }
}