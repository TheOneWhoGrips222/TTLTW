package com.webthietbibep.controller;

import com.webthietbibep.model.Ecosystems;
import com.webthietbibep.model.Product;
import com.webthietbibep.services.EcosystemService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/ecosystems")
public class EcosystemController extends HttpServlet {

    private EcosystemService service = new EcosystemService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        if ("edit".equals(action)) {
            showEditForm(req, resp);
        } else if ("delete".equals(action)) {
            deleteEcosystem(req, resp);
        } else if ("remove_product".equals(action)) {
            removeProductFromEco(req, resp);
        } else if ("new".equals(action)) {
            req.getRequestDispatcher("/admin/ecosystem-form.jsp").forward(req, resp);
        } else {
            listEcosystems(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            if ("insert".equals(action)) {
                Ecosystems eco = new Ecosystems();
                eco.setName(req.getParameter("name"));
                eco.setImage(req.getParameter("image"));
                service.insert(eco);
                resp.sendRedirect(req.getContextPath() + "/admin/ecosystems?message=saved");

            } else if ("update".equals(action)) {
                Ecosystems eco = new Ecosystems();
                eco.setId(Integer.parseInt(req.getParameter("id")));
                eco.setName(req.getParameter("name"));
                eco.setImage(req.getParameter("image"));
                service.update(eco);
                resp.sendRedirect(req.getContextPath() + "/admin/ecosystems?message=updated");

            } else if ("add_product".equals(action)) {
                // Lấy ID của Hệ sinh thái
                int ecoId = Integer.parseInt(req.getParameter("ecosystem_id"));
                // Lấy ID của Sản phẩm muốn thêm (được set bởi Javascript)
                int prodId = Integer.parseInt(req.getParameter("product_id_to_add"));

                System.out.println("Controller: Nhận yêu cầu thêm ProdID=" + prodId + " vào EcoID=" + ecoId);

                service.addProductToEcosystem(ecoId, prodId);

                // Quay lại trang sửa để thấy kết quả
                resp.sendRedirect(req.getContextPath() + "/admin/ecosystems?action=edit&id=" + ecoId + "&msg=added");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/ecosystems?message=error");
        }
    }

    // --- CÁC HÀM PHỤ ---

    private void listEcosystems(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Ecosystems> list = service.getAll();
        req.setAttribute("ecosystems", list);
        req.getRequestDispatcher("/admin/ecosystem-list.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Ecosystems eco = service.getEcosystemById(id);
            if (eco != null) {
                List<Product> products = service.getProductsByEcosystemId(id);
                req.setAttribute("ecosystem", eco);
                req.setAttribute("products", products);
                req.getRequestDispatcher("/admin/ecosystem-form.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/ecosystems");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/ecosystems");
        }
    }

    private void deleteEcosystem(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            service.delete(id);
            resp.sendRedirect(req.getContextPath() + "/admin/ecosystems?message=deleted");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/ecosystems?message=error");
        }
    }

    private void removeProductFromEco(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int ecoId = Integer.parseInt(req.getParameter("id"));
            int prodId = Integer.parseInt(req.getParameter("pid"));
            service.removeProductFromEcosystem(ecoId, prodId);
            resp.sendRedirect(req.getContextPath() + "/admin/ecosystems?action=edit&id=" + ecoId + "&msg=removed");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/ecosystems?message=error");
        }
    }
}