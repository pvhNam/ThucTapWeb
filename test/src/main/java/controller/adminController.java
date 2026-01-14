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

@WebServlet("/admin")
public class adminController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        
        if (isAdmin == null || !isAdmin) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        OrderDAO dao = new OrderDAO();
        List<Order> list = dao.getAllOrders();

        double totalRevenue = 0;
        int countSuccess = 0;
        int countShipping = 0;
        int countProcessing = 0;
        int countCancel = 0;

        if (list != null) {
            for (Order o : list) {
                String s = o.getStatus();
                // Kiểm tra null để tránh lỗi
                if(s == null) s = ""; 
                s = s.toLowerCase(); // Chuyển về chữ thường để so sánh

                if (s.contains("thành công")) {
                    totalRevenue += o.getTotalMoney();
                    countSuccess++;
                } else if (s.contains("giao")) {
                    countShipping++;
                } else if (s.contains("hủy")) {
                    countCancel++;
                } else {
                    // Còn lại là Đang xử lý / Chờ xác nhận
                    countProcessing++;
                }
            }
        }
        request.setAttribute("listOrders", list); 
        
        request.setAttribute("totalOrders", (list != null) ? list.size() : 0);
        request.setAttribute("totalRevenue", totalRevenue);
        
        request.setAttribute("countSuccess", countSuccess);
        request.setAttribute("countShipping", countShipping);
        request.setAttribute("countProcessing", countProcessing);
        request.setAttribute("countCancel", countCancel);
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}