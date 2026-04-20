package controller.admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;

@WebServlet("/admin-orders")
public class AdminOrderController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        OrderDAO orderDao = new OrderDAO();
        List<Order> allOrders = orderDao.getAllOrders();

        String filter = request.getParameter("filter");
        List<Order> listOrders = allOrders;

        if (filter != null && !filter.isEmpty()) {
            listOrders = new ArrayList<>();
            for (Order order : allOrders) {
                boolean match = false;
                switch (filter) {
                case "processing":
                    match = order.isProcessingStatus();
                    break;
                case "shipping":
                    match = order.isShippingStatus();
                    break;
                case "cancel":
                    match = order.isCancelledStatus();
                    break;
                case "success":
                    match = order.isSuccessStatus();
                    break;
                default:
                    break;
                }

                if (match) {
                    listOrders.add(order);
                }
            }
        }

        request.setAttribute("filter", filter);
        request.setAttribute("listOrders", listOrders);
        request.getRequestDispatcher("/admin-orders.jsp").forward(request, response);
    }
}
