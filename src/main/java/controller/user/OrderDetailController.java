package controller.user;

import java.io.IOException;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.User;
import service.OrderNotificationService;

@WebServlet("/order-detail")
public class OrderDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("order-history");
            return;
        }
        try {
            Order order = new OrderDAO().getOrderById(Integer.parseInt(idParam));
            boolean adminOrStaff = currentUser.getIsAdmin() > 0;
            if (order == null || (!adminOrStaff && order.getUserId() != currentUser.getUid())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", new OrderDAO().getDetails(order.getId()));
        } catch (NumberFormatException e) {
            response.sendRedirect("order-history");
            return;
        }
        request.getRequestDispatcher("/order-detail.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);
            User currentUser = session == null ? null : (User) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect("login");
                return;
            }
            String action = request.getParameter("action");
            int orderId = Integer.parseInt(request.getParameter("id"));

            if ("cancel".equals(action)) {
                OrderDAO dao = new OrderDAO();
                Order order = dao.getOrderById(orderId);

                if (order != null && order.getUserId() == currentUser.getUid() && canCancel(order.getStatus())
                        && dao.updateOrderStatusIfCurrent(orderId, order.getStatus(), Order.STATUS_CANCELLED)) {
                    new OrderNotificationService().notifyStatusChanged(dao.getOrderById(orderId), null);
                }
            }

            response.sendRedirect("order-detail?id=" + orderId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("order-history");
        }
    }

    private boolean canCancel(String status) {
        return Order.STATUS_PROCESSING.equals(status);
    }
}
