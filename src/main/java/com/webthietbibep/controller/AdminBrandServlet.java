package com.webthietbibep.controller;

import com.webthietbibep.dao.BrandDAO;
import com.webthietbibep.model.Brand;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "AdminBrandServlet", urlPatterns = {"/admin/brands"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize       = 1024 * 1024 * 2,
        maxRequestSize    = 1024 * 1024 * 10
)
public class AdminBrandServlet extends HttpServlet {

    private final BrandDAO brandDAO = new BrandDAO();
    private static final String UPLOAD_DIR = "assets/uploads/brands";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";
        try {
            switch (action) {
                case "new"    -> showNewForm(request, response);
                case "edit"   -> showEditForm(request, response);
                case "delete" -> deleteBrand(request, response);
                default       -> listBrands(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/brands?message=error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            String action       = getPartString(request, "action");
            String brandName    = getPartString(request, "brand_name");
            String logoUrl      = getPartString(request, "logo_url");
            String existingLogo = getPartString(request, "existing_logo");
            String brandIdStr   = getPartString(request, "brand_id");

            String logo = resolveLogoUpload(request, logoUrl);

            if ("insert".equals(action)) {
                Brand b = new Brand();
                b.setBrand_name(brandName);
                b.setLogo_url(logo != null ? logo : "");
                brandDAO.insert(b);
                response.sendRedirect(request.getContextPath() + "/admin/brands?message=saved");

            } else if ("update".equals(action)) {
                if (logo == null || logo.isBlank()) logo = existingLogo;
                int id = Integer.parseInt(brandIdStr != null ? brandIdStr : "0");
                Brand b = new Brand();
                b.setBrand_id(id);
                b.setBrand_name(brandName);
                b.setLogo_url(logo != null ? logo : "");
                brandDAO.update(b);
                response.sendRedirect(request.getContextPath() + "/admin/brands?message=saved");

            } else {
                listBrands(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/brands?message=error");
        }
    }

    private void listBrands(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Brand> list = brandDAO.getAll();
        request.setAttribute("brands", list);
        request.getRequestDispatcher("/admin/brand-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/brand-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Brand existing = brandDAO.getById(id);
            if (existing != null) {
                request.setAttribute("brand", existing);
                request.getRequestDispatcher("/admin/brand-form.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/brands");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/brands");
        }
    }

    private void deleteBrand(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            brandDAO.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/brands?message=deleted");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/brands");
        }
    }

    private String resolveLogoUpload(HttpServletRequest request, String logoUrl)
            throws IOException, ServletException {

        Part filePart = request.getPart("logo_file");
        if (filePart != null && filePart.getSize() > 0) {
            String ct = filePart.getContentType();
            if (ct != null && (ct.contains("jpeg") || ct.contains("png") || ct.contains("svg"))) {

                String appPath   = request.getServletContext().getRealPath("");
                File   uploadDir = new File(appPath, UPLOAD_DIR);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String ext      = ct.contains("png") ? ".png" : ct.contains("svg") ? ".svg" : ".jpg";
                String fileName = UUID.randomUUID().toString() + ext;
                File   destFile = new File(uploadDir, fileName);

                filePart.write(destFile.getAbsolutePath());

                return UPLOAD_DIR + "/" + fileName;
            }
        }

        if (logoUrl != null && !logoUrl.isBlank()
                && (logoUrl.startsWith("http://") || logoUrl.startsWith("https://"))) {
            return logoUrl.trim();
        }

        return null;
    }

    private String getPartString(HttpServletRequest request, String name)
            throws IOException, ServletException {
        Part part = request.getPart(name);
        if (part == null) return null;
        try (InputStream is = part.getInputStream()) {
            return new String(is.readAllBytes(), "UTF-8").trim();
        }
    }
}
