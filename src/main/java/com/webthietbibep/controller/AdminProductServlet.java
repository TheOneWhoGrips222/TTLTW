package com.webthietbibep.controller;

import com.webthietbibep.dao.BrandDAO;
import com.webthietbibep.dao.CategoryDAO;
import com.webthietbibep.dao.ProductDAO;
import com.webthietbibep.dao.ProductImageDAO;
import com.webthietbibep.model.Product;
import com.webthietbibep.model.ProductImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.List;


@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
@WebServlet(name = "AdminProductServlet", urlPatterns = {"/admin/product-save"})
public class AdminProductServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private BrandDAO brandDAO;
    private ProductImageDAO productImageDAO; // Khai báo

    @Override
    public void init() {
        this.productDAO = new ProductDAO();
        this.categoryDAO = new CategoryDAO();
        this.brandDAO = new BrandDAO();
        this.productImageDAO = new ProductImageDAO(); // Khởi tạo
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        Product p = new Product();
        List<ProductImage> listExtraImages = null; // List ảnh phụ

        if ("edit".equals(action) && idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                p = productDAO.getProduct(id);
                // Lấy thêm danh sách ảnh phụ
                if (p != null) {
                    listExtraImages = productImageDAO.getByProductId(id);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        req.setAttribute("product", p);
        req.setAttribute("extraImages", listExtraImages); // Đẩy ảnh phụ ra view
        req.setAttribute("listCategories", categoryDAO.getAll());
        req.setAttribute("listBrands", brandDAO.getAll());

        req.getRequestDispatcher("/admin/admin_add_product.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Product p = new Product();
        String uploadDir = req.getServletContext().getRealPath("/assets/images/products");

        try {
            String idStr = req.getParameter("product_id");
            int pid = (idStr == null || idStr.isEmpty()) ? 0 : Integer.parseInt(idStr);
            p.setProduct_id(pid);
            p.setProduct_name(req.getParameter("product_name"));
            p.setDescription(req.getParameter("description"));
            p.setPrice(parseDouble(req.getParameter("price")));
            p.setStock_quantity(parseInt(req.getParameter("stock_quantity")));
            p.setCategory_id(parseInt(req.getParameter("category_id")));
            p.setBrand_id(parseInt(req.getParameter("brand_id")));


            String mainImageUrl = handleFileUpload(req.getPart("imageFile"), uploadDir);
            if (mainImageUrl == null) {
                mainImageUrl = req.getParameter("image");
            }
            if (mainImageUrl == null && pid > 0) {
                Product oldP = productDAO.getProduct(pid);
                if(oldP != null) mainImageUrl = oldP.getImage();
            }
            p.setImage(mainImageUrl);

            if (p.getProduct_id() > 0) {
                productDAO.update(p);
                session.setAttribute("msg", "Cập nhật thành công!");
            } else {

                productDAO.insert(p);

            }

            // 1. Upload nhiều file
            Collection<Part> parts = req.getParts();
            int sortOrder = 1;

            // Xử lý các input file có name="extraImageFiles" (Input multiple)
            for (Part part : parts) {
                if ("extraImageFiles".equals(part.getName()) && part.getSize() > 0) {
                    String url = handleFileUpload(part, uploadDir);
                    if (url != null) {
                        ProductImage pi = new ProductImage(0, sortOrder++, url, p.getProduct_id());
                        productImageDAO.insert(pi);
                    }
                }
            }


            String[] extraUrls = req.getParameterValues("extraImageUrls");
            if (extraUrls != null) {
                for (String url : extraUrls) {
                    if (url != null && !url.trim().isEmpty()) {
                        ProductImage pi = new ProductImage(0, sortOrder++, url.trim(), p.getProduct_id());
                        productImageDAO.insert(pi);
                    }
                }
            }

            resp.sendRedirect(req.getContextPath() + "/admin/product-save?action=edit&id=" + p.getProduct_id());

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            req.setAttribute("product", p);
            req.setAttribute("listCategories", categoryDAO.getAll());
            req.setAttribute("listBrands", brandDAO.getAll());
            req.getRequestDispatcher("/admin/admin_add_product.jsp").forward(req, resp);
        }
    }


    private String handleFileUpload(Part part, String uploadDir) throws IOException {
        if (part == null || part.getSize() == 0 || part.getSubmittedFileName().isEmpty()) {
            return null;
        }


        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();


        String fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();
        String filePath = uploadDir + File.separator + fileName;


        part.write(filePath);


        return "assets/images/products/" + fileName;
    }

    private double parseDouble(String s) {
        try { return Double.parseDouble(s); } catch (Exception e) { return 0; }
    }
    private int parseInt(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return 0; }
    }
}