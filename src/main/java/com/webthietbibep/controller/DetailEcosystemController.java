package com.webthietbibep.controller;

import com.webthietbibep.model.Ecosystems;
import com.webthietbibep.model.Product;
import com.webthietbibep.services.EcoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "DetailEcosystemController", value = "/detail-ecosystem")
public class DetailEcosystemController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        EcoService es = new EcoService();
        Ecosystems eco = es.getEcoById(id);
        List<Product> products = es.getListProductEco(id);
        int count = products.size();
        eco.setProducts(products);



        request.setAttribute("eco", eco);
        request.setAttribute("count", count);

        request.getRequestDispatcher("/detail-ecosys.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}