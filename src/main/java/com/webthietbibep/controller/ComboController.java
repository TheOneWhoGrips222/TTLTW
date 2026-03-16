package com.webthietbibep.controller;

import com.webthietbibep.model.Combo;
import com.webthietbibep.services.ComboService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ComboController ", value = "/combo")
public class ComboController extends HttpServlet {
    @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id =  Integer.parseInt(request.getParameter("id"));
       ComboService cp = new ComboService();
        Combo cb = cp.getCombo(id);

        cb.setProducts(cp.getListComboProduct(id));

        request.setAttribute("c", cb);

        request.getRequestDispatcher("chitietCombo.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }


}