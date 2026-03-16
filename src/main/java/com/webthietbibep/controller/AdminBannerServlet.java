package com.webthietbibep.controller;

import com.webthietbibep.model.Banner;
import com.webthietbibep.services.BannerService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "AdminBannerServlet", urlPatterns = {"/admin/banners"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminBannerServlet extends HttpServlet {

    private final BannerService bannerService = new BannerService();

    private static final String UPLOAD_DIR = "assets/uploads/banners";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                req.getRequestDispatcher("/admin/admin_banner_form.jsp").forward(req, resp);
                break;
            case "edit":
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Banner existingBanner = bannerService.getBannerById(id);
                    req.setAttribute("banner", existingBanner);
                    req.getRequestDispatcher("/admin/admin_banner_form.jsp").forward(req, resp);
                } catch (Exception e) {
                    resp.sendRedirect("banners?error=true");
                }
                break;
            case "delete":
                deleteBanner(req, resp);
                break;
            default:
                listBanners(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if ("insert".equals(action)) {
            insertBanner(req, resp);
        } else if ("update".equals(action)) {
            updateBanner(req, resp);
        } else {
            listBanners(req, resp);
        }
    }

    private String handleImageUpload(HttpServletRequest req) throws IOException, ServletException {
        Part filePart = req.getPart("image_file");
        if (filePart != null && filePart.getSize() > 0) {
            String applicationPath = req.getServletContext().getRealPath("");
            String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

            File uploadDir = new File(uploadFilePath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);

            // Lưu file
            filePart.write(uploadFilePath + File.separator + fileName);

            return UPLOAD_DIR + "/" + fileName;
        }

        String imageUrl = req.getParameter("image_url");
        if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            return imageUrl.trim(); // VD: https://example.com/anh.jpg
        }

        return null;
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String content : contentDisp.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return "unknown.jpg";
    }

    // --- INSERT ---
    private void insertBanner(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String linkUrl = req.getParameter("link_url");
            int sortOrder = Integer.parseInt(req.getParameter("sort_order"));
            byte isActive = Byte.parseByte(req.getParameter("is_active"));

            String imagePath = handleImageUpload(req);
            if (imagePath == null) imagePath = "";

            Banner newBanner = new Banner(0, title, description, imagePath, linkUrl, sortOrder, isActive);
            bannerService.insertBanner(newBanner);
            resp.sendRedirect(req.getContextPath() + "/admin/banners?message=inserted");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/banners?error=true");
        }
    }

    private void updateBanner(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String linkUrl = req.getParameter("link_url");
            int sortOrder = Integer.parseInt(req.getParameter("sort_order"));
            byte isActive = Byte.parseByte(req.getParameter("is_active"));

            String oldImage = req.getParameter("old_image");

            String newImage = handleImageUpload(req);

            if (newImage == null) {
                newImage = oldImage;
            }

            Banner banner = new Banner(id, title, description, newImage, linkUrl, sortOrder, isActive);
            bannerService.updateBanner(banner);
            resp.sendRedirect(req.getContextPath() + "/admin/banners?message=updated");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/banners?error=true");
        }
    }

    private void listBanners(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listBanners", bannerService.getAllBannersAdmin());
        req.getRequestDispatcher("/admin/admin_banners.jsp").forward(req, resp);
    }

    private void deleteBanner(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            bannerService.deleteBanner(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/admin/banners");
    }
}