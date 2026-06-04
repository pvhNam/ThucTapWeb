package controller.user;

import dao.AddressDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Address;
import model.User;

@WebServlet(name = "AddAddressServlet", urlPatterns = {"/add-address"})
public class AddAddressServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher("add-address.jsp").forward(request, response);
    }

    // Xử lý dữ liệu form gửi lên
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String receiverName = request.getParameter("receiverName");
        String phone = request.getParameter("phone");
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");
        String specificAddress = request.getParameter("specificAddress");
        boolean isDefault = request.getParameter("isDefault") != null; // checkbox

        Address newAddr = new Address(0, user.getUid(), receiverName, phone, specificAddress, ward, district, city, isDefault);

        AddressDAO addressDAO = new AddressDAO();
        addressDAO.insertAddress(newAddr);

        response.sendRedirect("address-list");
    }
}