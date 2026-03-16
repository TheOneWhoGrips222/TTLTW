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
       List<Ecosystems> listE = es.getListEco();
       request.setAttribute("listE", listE);
       request.getRequestDispatcher("Ecosystem.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}