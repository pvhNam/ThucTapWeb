package controller.user;

import java.io.IOException;
import java.util.List;
import dao.OrderDAO;
import model.Order;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/order-history")
public class OrderHistoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        OrderDAO orderDao = new OrderDAO();
        List<Order> listOrders = orderDao.getOrdersByUserId(currentUser.getUid());
        request.setAttribute("listOrders", listOrders);
        request.getRequestDispatcher("/views/user/order-history.jsp").forward(request, response);
    }
}
