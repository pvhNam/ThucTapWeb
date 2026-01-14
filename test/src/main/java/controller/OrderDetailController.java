package controller;

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
        request.getRequestDispatcher("order-detail.jsp").forward(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy tham số action để biết người dùng muốn làm gì
            String action = request.getParameter("action");
            int orderId = Integer.parseInt(request.getParameter("id"));

            if ("cancel".equals(action)) {
                OrderDAO dao = new OrderDAO();
                Order order = dao.getOrderById(orderId);

                // Check kỹ lại trạng thái trước khi hủy
                if (order != null && "Đang xử lý".equals(order.getStatus())) {
                    dao.updateOrderStatus(orderId, "Đã hủy");
                }
            }

            // Xử lý xong thì load lại trang chi tiết (gọi lại hàm doGet) để thấy kết quả
            response.sendRedirect("order-detail?id=" + orderId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("order-history");
        }
    }
}