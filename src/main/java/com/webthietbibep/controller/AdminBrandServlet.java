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

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
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
    private static final String UPLOAD_RELATIVE = "assets/uploads/brands";

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
            // Dùng getParameter() cho text fields — hoạt động đúng với @MultipartConfig
            // KHÔNG dùng getPart() cho text fields để tránh ảnh hưởng đến file Part
            String action       = request.getParameter("action");
            String brandName    = request.getParameter("brand_name");
            String logoUrl      = request.getParameter("logo_url");
            String existingLogo = request.getParameter("existing_logo");
            String brandIdStr   = request.getParameter("brand_id");

            // Chỉ dùng getPart() cho file upload
            String logo = saveFileLogo(request, logoUrl);

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

    private String saveFileLogo(HttpServletRequest request, String logoUrl)
            throws IOException, ServletException {

        Part filePart = request.getPart("logo_file");

        if (filePart != null && filePart.getSize() > 0) {
            String ct = filePart.getContentType();
            if (ct == null) ct = "";

            if (ct.contains("jpeg") || ct.contains("png") || ct.contains("svg")) {

                // Lấy đường dẫn thư mục webapp đang chạy
                Path uploadDir = getUploadDir();
                if (uploadDir == null) {
                    System.err.println("[BrandUpload] ERROR: Cannot resolve upload directory");
                    return null;
                }

                String ext      = ct.contains("png") ? ".png" : ct.contains("svg") ? ".svg" : ".jpg";
                String fileName = UUID.randomUUID() + ext;
                Path   dest     = uploadDir.resolve(fileName);

                try (InputStream in = filePart.getInputStream()) {
                    long saved = Files.copy(in, dest, StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("[BrandUpload] OK — saved " + saved + " bytes => " + dest);
                }

                return UPLOAD_RELATIVE + "/" + fileName;
            }
        }

        // Không có file → dùng URL nếu hợp lệ
        if (logoUrl != null && !logoUrl.isBlank()
                && (logoUrl.startsWith("http://") || logoUrl.startsWith("https://"))) {
            return logoUrl.trim();
        }

        return null;
    }

    /**
     * Lấy thư mục lưu ảnh upload.
     * Dùng getRealPath của một resource đã biết tồn tại (/assets/css)
     * để tránh trường hợp getRealPath("/") trả về null hoặc sai.
     */
    private Path getUploadDir() {
        try {
            // Cách 1: dùng getRealPath của folder css đã chắc chắn tồn tại
            String cssPath = getServletContext().getRealPath("/assets/css");
            if (cssPath != null) {
                // cssPath = .../assets/css  →  đi lên 2 cấp = webapp root
                Path webappRoot = Paths.get(cssPath).getParent().getParent();
                Path uploadDir  = webappRoot.resolve(UPLOAD_RELATIVE);
                Files.createDirectories(uploadDir);
                System.out.println("[BrandUpload] uploadDir (via css): " + uploadDir);
                return uploadDir;
            }
        } catch (Exception e) {
            System.err.println("[BrandUpload] Cách 1 thất bại: " + e.getMessage());
        }

        try {
            // Cách 2: getRealPath("/")
            String root = getServletContext().getRealPath("/");
            if (root != null) {
                Path uploadDir = Paths.get(root, UPLOAD_RELATIVE);
                Files.createDirectories(uploadDir);
                System.out.println("[BrandUpload] uploadDir (via root): " + uploadDir);
                return uploadDir;
            }
        } catch (Exception e) {
            System.err.println("[BrandUpload] Cách 2 thất bại: " + e.getMessage());
        }

        try {
            // Cách 3: dùng user.dir (thư mục project IntelliJ)
            Path uploadDir = Paths.get(System.getProperty("user.dir"),
                    "src", "main", "webapp", UPLOAD_RELATIVE);
            Files.createDirectories(uploadDir);
            System.out.println("[BrandUpload] uploadDir (via user.dir): " + uploadDir);
            return uploadDir;
        } catch (Exception e) {
            System.err.println("[BrandUpload] Cách 3 thất bại: " + e.getMessage());
        }

        return null;
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
}
