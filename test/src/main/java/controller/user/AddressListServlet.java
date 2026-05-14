package controller.user;

import dao.AddressDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Address;
import model.User;

@WebServlet(name = "AddressListServlet", urlPatterns = {"/address-list"})
public class AddressListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        AddressDAO addressDAO = new AddressDAO();
        List<Address> myAddresses = addressDAO.getAddressesByUserId(user.getUid()   );

        request.setAttribute("addressList", myAddresses);
        request.getRequestDispatcher("address-list.jsp").forward(request, response);
    }
}