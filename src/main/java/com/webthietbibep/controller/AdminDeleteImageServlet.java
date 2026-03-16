package com.webthietbibep.controller;

import com.webthietbibep.dao.ProductImageDAO;
import com.webthietbibep.model.ProductImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;

@WebServlet("/admin/delete-product-image")
public class AdminDeleteImageServlet extends HttpServlet {
    private ProductImageDAO productImageDAO = new ProductImageDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int imageId = Integer.parseInt(req.getParameter("image_id"));
            ProductImage img = productImageDAO.getById(imageId);

            if (img != null) {
                if (!img.getImage_url().startsWith("http")) {
                    String realPath = getServletContext().getRealPath("/") + img.getImage_url();
                    File file = new File(realPath);
                    if (file.exists()) file.delete();
                }


                productImageDAO.deleteById(imageId);
                resp.getWriter().write("success");
            }
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write("error");
        }
    }
}