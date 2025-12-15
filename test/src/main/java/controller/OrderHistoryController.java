package controller;

import java.io.IOException;
import java.util.List;
import dao.OrderDAO;
import model.Order;
import model.user;
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
        
        // 1. Kiểm tra session xem user đã đăng nhập chưa
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");

        if (currentUser == null) {
            // Chưa đăng nhập thì đá về trang login
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Gọi DAO để lấy danh sách đơn hàng của user này
        OrderDAO orderDao = new OrderDAO();
        List<Order> listOrders = orderDao.getOrdersByUserId(currentUser.getUid());

        // 3. Đẩy dữ liệu sang trang JSP
        request.setAttribute("listOrders", listOrders);
        request.getRequestDispatcher("order-history.jsp").forward(request, response);
    }
}