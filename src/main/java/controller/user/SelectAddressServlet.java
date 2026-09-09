package controller.user;

import java.io.IOException;
import dao.AddressDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Address;
import model.User;

@WebServlet(name = "SelectAddressServlet", urlPatterns = {"/select-address"})
public class SelectAddressServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        int addressId = parsePositiveInt(request.getParameter("addressId"));
        Address address = new AddressDAO().getAddressByIdAndUserId(addressId, currentUser.getUid());
        if (address != null) {
            String fullAddressInfo = address.getReceiverName() + " - " + address.getPhone() + " - "
                    + address.getSpecificAddress() + ", " + address.getWard() + ", "
                    + address.getDistrict() + ", " + address.getCity();
            session.setAttribute("selectedAddressId", address.getId());
            session.setAttribute("selectedAddress", fullAddressInfo);
            session.setAttribute("selectedContactPhone", address.getPhone());
        }

        response.sendRedirect("cart");
    }

    private int parsePositiveInt(String value) {
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : 0;
        } catch (Exception e) {
            return 0;
        }
    }
}
