    package com.webthietbibep.controller;

    import com.webthietbibep.dao.UserAddressDAO;
    import com.webthietbibep.model.User;
    import com.webthietbibep.model.UserAddress;
    import com.webthietbibep.services.GhnLookupService;
    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.HttpServlet;
    import jakarta.servlet.http.HttpServletRequest;
    import jakarta.servlet.http.HttpServletResponse;

    import java.io.IOException;

    @WebServlet("/addresses")
    public class UserAddressServlet extends HttpServlet {

        private final UserAddressDAO dao = new UserAddressDAO();

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp)
                throws ServletException, IOException {

            User user = (User) req.getSession().getAttribute("user");
            if (user == null) {
                resp.sendRedirect("login");
                return;
            }

            req.setAttribute("addresses", dao.findByUserId(user.getUser_id()));
            req.getRequestDispatcher("/address.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {

            req.setCharacterEncoding("UTF-8");
            resp.setCharacterEncoding("UTF-8");
            User user = (User) req.getSession().getAttribute("user");
            if (user == null) {
                resp.sendRedirect("login");
                return;
            }

            UserAddress a = new UserAddress();
            a.setUser_id(user.getUser_id());
            a.setReceiver_name(req.getParameter("receiver_name"));
            a.setPhone(req.getParameter("phone"));
            a.setAddress_detail(req.getParameter("address_detail"));
            a.setWard(req.getParameter("ward"));
            a.setDistrict(req.getParameter("district"));
            a.setProvince(req.getParameter("province"));
            a.setIs_default("on".equals(req.getParameter("is_default")));

            try {

                GhnLookupService lookup =
                        new GhnLookupService();

                System.out.println(
                        "DISTRICT = " + a.getDistrict());

                System.out.println(
                        "WARD = " + a.getWard());

                int districtId =
                        lookup.findDistrictIdByName(
                                a.getDistrict());

                System.out.println(
                        "FOUND DISTRICT ID = "
                                + districtId);

                String wardCode =
                        lookup.findWardCodeByName(
                                districtId,
                                a.getWard());

                System.out.println(
                        "FOUND WARD CODE = "
                                + wardCode);

                a.setDistrict_id(districtId);
                a.setWard_code(wardCode);

            }
            catch(Exception e){

                System.out.println(
                        "LOOKUP ERROR:");

                e.printStackTrace();
            }
            dao.insert(a);
            resp.sendRedirect("addresses");
        }
    }

