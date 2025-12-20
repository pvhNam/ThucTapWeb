package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user;
import dao.UserDAO;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // --- 1. KIỂM TRA ADMIN (THÊM ĐOẠN NÀY) ---
        if ("admin".equals(username) && "123".equals(password)) {
            HttpSession session = request.getSession();
            
            // Tạo user ảo cho admin
            user adminUser = new user();
            adminUser.setFullname("Administrator"); // Hoặc setUsername tùy model
            adminUser.setUid(0); // ID đặc biệt
            
            session.setAttribute("user", adminUser);
            session.setAttribute("isAdmin", true); // Cờ đánh dấu đây là Admin
            
            // Chuyển hướng sang trang quản lý
            response.sendRedirect("admin-orders");
            return;
        }

        // --- 2. LOGIC ĐĂNG NHẬP THƯỜNG (CODE CŨ GIỮ NGUYÊN) ---
        UserDAO dao = new UserDAO();
        user loginUser = dao.login(username, password);

        if (loginUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", loginUser);
            // ... (Logic điều hướng cũ) ...
            response.sendRedirect("index.jsp");
        } else {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}