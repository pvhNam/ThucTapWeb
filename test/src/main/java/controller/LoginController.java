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

        if ("admin".equals(username) && "123".equals(password)) {
            HttpSession session = request.getSession();
            user adminUser = new user();
            adminUser.setFullname("Administrator");
            adminUser.setUsername("admin");
            adminUser.setUid(0); 
            adminUser.setIsAdmin(1);
            
            session.setAttribute("user", adminUser);
            session.setAttribute("isAdmin", true);
            response.sendRedirect("admin"); 
            return;
        }

        // XỬ LÝ ĐĂNG NHẬP TỪ DATABASE (Khách hàng & Nhân viên)
        String hashedPassword = MD5.getMd5(password);
        UserDAO dao = new UserDAO();
        user loginUser = dao.login(username, hashedPassword);

        if (loginUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", loginUser);

            
            int role = loginUser.getIsAdmin();
            if (role == 1 || role == 2) {
                // Nếu là Admin hoặc Nhân viên thì vào trang quản trị
                session.setAttribute("isAdmin", true);
                response.sendRedirect("admin");
            } else {
                // Nếu là khách hàng bình thường
                session.setAttribute("isAdmin", false);
                response.sendRedirect("index.jsp");
            }

            response.sendRedirect("home");

        } else {
            // Đăng nhập thất bại
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}