package controller.admin;

import java.io.IOException;
import java.util.List;
import dao.OrderDAO;
import model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-orders")
public class AdminOrderController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        OrderDAO orderDao = new OrderDAO();
        List<Order> listOrders = orderDao.getAllOrders();

        request.setAttribute("listOrders", listOrders);
        request.getRequestDispatcher("/views/admin/orders.jsp").forward(request, response);
    }
}
