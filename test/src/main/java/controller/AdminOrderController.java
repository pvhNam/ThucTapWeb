package controller;

import java.io.IOException;
import java.util.List;
import dao.OrderDAO;
import model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-orders")
public class AdminOrderController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Kiểm tra quyền Admin (Dựa vào cờ isAdmin đã set ở LoginController)
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        
        if (isAdmin == null || !isAdmin) {
            // Không phải admin thì đá về trang login
            response.sendRedirect("login.jsp");
            return;
        }

        // Gọi DAO lấy tất cả đơn hàng
        OrderDAO orderDao = new OrderDAO();
        List<Order> listOrders = orderDao.getAllOrders();

        request.setAttribute("listOrders", listOrders);
        request.getRequestDispatcher("admin-orders.jsp").forward(request, response);
    }
}