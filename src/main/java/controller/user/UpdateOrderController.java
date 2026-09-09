package controller.user;

import java.io.IOException;

import dao.OrderDAO;
import dao.LoyaltyDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.LoyaltyReward;
import service.OrderNotificationService;

@WebServlet("/update-order")
public class UpdateOrderController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            response.sendRedirect("login");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");
        OrderDAO dao = new OrderDAO();
        Order order = dao.getOrderById(orderId);

        if (order == null) {
            response.sendRedirect("admin-orders?msg=not-found");
            return;
        }

        String newStatus = null;
        if ("ship".equals(action) && order.isShippableStatus()) {
            newStatus = Order.STATUS_SHIPPING;
        } else if ("cancel".equals(action) && order.isAdminCancelableStatus()) {
            newStatus = Order.STATUS_CANCELLED;
        } else if ("success".equals(action) && order.isShippingStatus()) {
            newStatus = Order.STATUS_SUCCESS;
        }

        if (newStatus == null || !dao.updateOrderStatusIfCurrent(orderId, order.getStatus(), newStatus)) {
            response.sendRedirect("admin-orders?msg=invalid-status");
            return;
        }

        LoyaltyReward reward = Order.STATUS_SUCCESS.equals(newStatus)
                ? new LoyaltyDAO().processCompletedOrder(orderId)
                : null;
        Order updatedOrder = dao.getOrderById(orderId);
        new OrderNotificationService().notifyStatusChanged(updatedOrder, reward);

        response.sendRedirect("admin-orders?msg=updated");
    }
}
