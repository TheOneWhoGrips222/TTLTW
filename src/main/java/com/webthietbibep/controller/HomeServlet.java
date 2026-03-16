package com.webthietbibep.controller;

import com.webthietbibep.dao.ProductCommentDAO;
import com.webthietbibep.model.*;
import com.webthietbibep.services.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", value = "/Home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductService ps = new ProductService();
        BrandService bs = new BrandService();
        EcoService es = new EcoService();
        TesService ts = new TesService();
        BannerService bns = new BannerService();
        ComboService cs = new ComboService();
        CategoryService css = new CategoryService();
        ArcticleService as = new ArcticleService();
        ProductCommentDAO commentDAO = new ProductCommentDAO();


        List<Product> listP = ps.getBestSeller();
        List<Category> topCategories = css.getTopCategories();
        List<Brand> topBrands = bs.getTopBrands();
        List<Brand> listB = bs.getListBrand();
        List<Ecosystems> listE = es.getListEco();
        List<Testimonial> listT = ts.getListTes();
        List<Banner> listBN = bns.getListBanner();
        List<Combo> listC = cs.getListBaseCombo();
        List<Category> listCate = css.getTopCategories();

        List<ProductComment> homeComments = commentDAO.getLatestForHome(5);

        request.setAttribute("listP", listP);
        request.setAttribute("topCategories", topCategories);
        request.setAttribute("topBrands", topBrands);
        request.setAttribute("listB", listB);
        request.setAttribute("listE", listE);
        request.setAttribute("listT", listT);
        request.setAttribute("listBN", listBN);
        request.setAttribute("listC", listC);

        request.setAttribute("listA", as.getNewArticle());
        request.setAttribute("homeComments", homeComments);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }


}