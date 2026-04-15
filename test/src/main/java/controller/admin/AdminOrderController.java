package controller.admin;

import java.io.IOException;
import java.util.ArrayList;
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
        List<Order> allOrders = orderDao.getAllOrders();

        String filter = request.getParameter("filter");
        List<Order> listOrders;

        if (filter != null && !filter.isEmpty()) {
            listOrders = new ArrayList<>();
            for (Order o : allOrders) {
                String s = (o.getStatus() != null) ? o.getStatus().toLowerCase() : "";
                boolean match = false;
                switch (filter) {
                    case "processing": match = s.contains("xử lý"); break;
                    case "shipping":   match = s.contains("giao") && !s.contains("thành công"); break;
                    case "cancel":     match = s.contains("hủy") || s.contains("huy"); break;
                    case "success":    match = s.contains("thành công"); break;
                }
                if (match) listOrders.add(o);
            }
        } else {
            listOrders = allOrders;
        }

        request.setAttribute("filter", filter);
        request.setAttribute("listOrders", listOrders);
        request.getRequestDispatcher("/admin-orders.jsp").forward(request, response);
    }
}
