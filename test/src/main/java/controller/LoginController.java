package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user;
import dao.UserDAO;
import util.MD5; 
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // XỬ LÝ ADMIN CỨNG
        if ("admin".equals(username) && "123".equals(password)) {
            HttpSession session = request.getSession();
            user adminUser = new user();
            adminUser.setFullname("Administrator");
            adminUser.setUid(0); 
            session.setAttribute("user", adminUser);
            session.setAttribute("isAdmin", true);
            response.sendRedirect("admin"); // Chuyển hướng trang admin
            return;
        }

        // XỬ LÝ USER
        
        // Mã hóa mật khẩu người dùng nhập vào
        String hashedPassword = MD5.getMd5(password);
        
        // Gọi DAO kiểm tra
        UserDAO dao = new UserDAO();
        user loginUser = dao.login(username, hashedPassword); // Truyền mật khẩu ĐÃ BĂM

        if (loginUser != null) {
            // Đăng nhập thành công
            HttpSession session = request.getSession();
            session.setAttribute("user", loginUser);
            response.sendRedirect("index.jsp");
        } else {
            // Đăng nhập thất bại
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}