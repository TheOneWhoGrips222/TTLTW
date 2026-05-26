package com.webthietbibep.controller;

import com.webthietbibep.model.Combo;
import com.webthietbibep.services.ComboService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ListComboContronller", value = "/listcombo")
public class ListComboContronller extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ComboService cp = new ComboService();
        int lastId = 0;
        String lastIdParam = request.getParameter("lastId");
        if (lastIdParam != null && !lastIdParam.isEmpty()) {
            lastId = Integer.parseInt(lastIdParam);
        }
        int pageSize = 3;
        List<Combo> lisrC = cp.getListCombo(lastId, pageSize);

        if (lisrC != null) {
            for (Combo c : lisrC) {
                int curid = c.getId();
                c.setListadvance(cp.getListComboAdvance(curid));
            }
        }

        int nextLastId = 0;
        if (lisrC != null && !lisrC.isEmpty()) {
            nextLastId = lisrC.get(lisrC.size() - 1).getId();
        }

        request.setAttribute("listC", lisrC);
        request.setAttribute("nextLastId", nextLastId);
        request.getRequestDispatcher("giaiphapvacombo.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}