package com.webthietbibep.controller;

import com.webthietbibep.model.Ecosystems;
import com.webthietbibep.services.EcoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "EcosystemServlet", value = "/ecos-list")
public class EcosystemServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       EcoService es = new EcoService();
        int lastId = 0;
        String lastIdParam = request.getParameter("lastId");
        if (lastIdParam != null && !lastIdParam.isEmpty()) {
            lastId = Integer.parseInt(lastIdParam);
        }
        int pageSize = 3;
       List<Ecosystems> listE = es.getListEco2(lastId, pageSize);
        int nextLastId = 0;
        if (listE != null && !listE.isEmpty()) {
            nextLastId = listE.get(listE.size() - 1).getId();
        }
       request.setAttribute("listE", listE);
        request.setAttribute("nextLastId", nextLastId);
       request.getRequestDispatcher("Ecosystem.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}