package com.webthietbibep.controller;

import com.webthietbibep.model.Promotion;
import com.webthietbibep.services.PromotionService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PromotionController", value = "/Promotion")
public class PromotionController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PromotionService ps = new PromotionService();
        List<Promotion> listP = ps.getListPromotion();

        request.setAttribute("listP", listP);
        request.getRequestDispatcher("khuyenmai.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}