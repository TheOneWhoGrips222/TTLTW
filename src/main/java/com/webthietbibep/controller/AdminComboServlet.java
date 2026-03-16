package com.webthietbibep.controller;

import com.webthietbibep.dao.ComboDao;
import com.webthietbibep.dao.ProductDAO;
import com.webthietbibep.model.Combo;
import com.webthietbibep.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminComboServlet", urlPatterns = {"/admin/combos"})
public class AdminComboServlet extends HttpServlet {

    private ComboDao comboDao = new ComboDao();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        List<Product> listProducts = productDAO.getListProduct();
        request.setAttribute("listProducts", listProducts);

        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Combo combo = comboDao.getCombo(id);
                List<Integer> selectedProductIds = comboDao.getProductIdsByComboId(id);
                request.setAttribute("combo", combo);
                request.setAttribute("selectedProductIds", selectedProductIds);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.getRequestDispatcher("/admin/admin_combo_form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("save".equals(action)) {
            try {
                String idStr = request.getParameter("id");
                String name = request.getParameter("name");
                String tag = request.getParameter("tag");
                String content = request.getParameter("content");
                String image = request.getParameter("image");
                String gift = request.getParameter("gift");

                double basePrice = Double.parseDouble(request.getParameter("baseprice"));
                double discountPrice = Double.parseDouble(request.getParameter("discountprice"));
                int stock = Integer.parseInt(request.getParameter("stock_quantity"));

                byte isActive = (byte) (request.getParameter("is_active") != null ? 1 : 0);

                String[] productIds = request.getParameterValues("product_ids");

                Combo combo = new Combo();
                combo.setName(name);
                combo.setTag(tag);
                combo.setContent(content);
                combo.setImage(image);
                combo.setGift(gift);
                combo.setBaseprice(basePrice);
                combo.setDiscountprice(discountPrice);
                combo.setStock_quantity(stock);
                combo.setIs_active(isActive);

                if (idStr == null || idStr.equals("0") || idStr.isEmpty()) {
                    comboDao.insert(combo, productIds);
                    request.getSession().setAttribute("msg", "Thêm Combo thành công!");
                } else {
                    combo.setId(Integer.parseInt(idStr));
                    comboDao.update(combo, productIds);
                    request.getSession().setAttribute("msg", "Cập nhật Combo thành công!");
                }

                response.sendRedirect(request.getContextPath() + "/admin/combo-list");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi: " + e.getMessage());
                doGet(request, response);
            }
        }
    }
}