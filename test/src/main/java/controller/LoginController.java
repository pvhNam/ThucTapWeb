package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user;

import java.io.IOException;

/**
 * Servlet implementation class LoginController
 */
import dao.UserDAO; // Nhớ import DAO

@WebServlet("/login")
public class LoginController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String origin = request.getParameter("origin");

        // GỌI DAO ĐỂ KIỂM TRA TỪ DATABASE
        UserDAO dao = new UserDAO();
        user loginUser = dao.login(username, password); // Hàm này lấy từ Database thật

        if (loginUser != null) {
            // Đăng nhập thành công -> Lưu Session
            HttpSession session = request.getSession();
            session.setAttribute("user", loginUser);
            
            // Điều hướng
            if ("cart".equals(origin)) {
                response.sendRedirect("cart");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            // Đăng nhập thất bại
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}