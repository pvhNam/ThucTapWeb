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

@WebServlet(name = "EditAddressServlet", urlPatterns = {"/edit-address"})
public class EditAddressServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int addressId = parseAddressId(request.getParameter("id"));
        if (addressId <= 0) {
            response.sendRedirect("address-list");
            return;
        }

        AddressDAO addressDAO = new AddressDAO();
        Address address = addressDAO.getAddressByIdAndUserId(addressId, user.getUid());
        if (address == null) {
            response.sendRedirect("address-list");
            return;
        }

        request.setAttribute("editAddress", address);
        request.getRequestDispatcher("add-address.jsp").forward(request, response);
    }

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

        int addressId = parseAddressId(request.getParameter("id"));
        if (addressId <= 0) {
            response.sendRedirect("address-list");
            return;
        }

        String receiverName = request.getParameter("receiverName");
        String phone = request.getParameter("phone");
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");
        String specificAddress = request.getParameter("specificAddress");
        boolean isDefault = request.getParameter("isDefault") != null;

        Address address = new Address(
                addressId,
                user.getUid(),
                receiverName,
                phone,
                specificAddress,
                ward,
                district,
                city,
                isDefault
        );

        AddressDAO addressDAO = new AddressDAO();
        addressDAO.updateAddress(address);

        response.sendRedirect("address-list");
    }

    private int parseAddressId(String id) {
        try {
            return Integer.parseInt(id);
        } catch (NumberFormatException e) {
            return -1;
        }
    }
}
