package controller.user;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SelectAddressServlet", urlPatterns = {"/select-address"})
public class SelectAddressServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String fullAddressInfo = request.getParameter("fullAddressInfo");

        if (fullAddressInfo != null && !fullAddressInfo.trim().isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("selectedAddress", fullAddressInfo);
        }

        response.sendRedirect("cart");
    }
}