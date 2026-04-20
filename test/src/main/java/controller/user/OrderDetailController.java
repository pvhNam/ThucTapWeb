package controller.user;

import java.io.IOException;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;

@WebServlet("/order-detail")
public class OrderDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("order-history");
            return;
        }
        request.getRequestDispatcher("/order-detail.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String action = request.getParameter("action");
            int orderId = Integer.parseInt(request.getParameter("id"));

            if ("cancel".equals(action)) {
                OrderDAO dao = new OrderDAO();
                Order order = dao.getOrderById(orderId);

                if (order != null && canCancel(order.getStatus())) {
                    dao.updateOrderStatus(orderId, Order.STATUS_CANCELLED);
                }
            }

            response.sendRedirect("order-detail?id=" + orderId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("order-history");
        }
    }

    private boolean canCancel(String status) {
        return Order.STATUS_PROCESSING.equals(status) || Order.STATUS_PENDING_MOMO.equals(status);
    }
}
