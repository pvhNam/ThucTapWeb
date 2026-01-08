package controller;

import java.io.IOException;
import java.util.List;
import dao.OrderDAO;
import dao.UserDAO;
import model.Order;
import model.user;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-user-detail")
public class AdminUserDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String uidStr = request.getParameter("uid");
        if(uidStr == null || uidStr.isEmpty()) {
            response.sendRedirect("admin-users");
            return;
        }

        try {
            int uid = Integer.parseInt(uidStr);
            
            UserDAO uDao = new UserDAO();
            user u = uDao.getUserById(uid);
            
            OrderDAO oDao = new OrderDAO();
            // Hàm getOrdersByUserId đã có sẵn trong OrderDAO bạn gửi trước đây
            List<Order> orders = oDao.getOrdersByUserId(uid); 
            
            if(u != null) {
                request.setAttribute("userInfo", u);
                request.setAttribute("userOrders", orders);
                request.getRequestDispatcher("admin-user-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect("admin-users");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-users");
        }
    }
}