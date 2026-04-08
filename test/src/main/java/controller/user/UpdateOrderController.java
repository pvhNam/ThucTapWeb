package controller.user;

import java.io.IOException;
import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

        if ("ship".equals(action)) {
            dao.updateOrderStatus(orderId, "Dang giao hang");
        } else if ("cancel".equals(action)) {
            dao.updateOrderStatus(orderId, "Da huy");
        } else if ("success".equals(action)) {
            dao.updateOrderStatus(orderId, "Giao thanh cong");
        }

        response.sendRedirect("admin-orders");
    }
}
