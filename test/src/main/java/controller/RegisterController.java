package controller;

import java.io.IOException;
import dao.UserDAO;
import model.user;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Lấy dữ liệu từ form register.jsp
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        String re_pass = request.getParameter("re_pass");
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");

        if(!pass.equals(re_pass)) {
            // Mật khẩu nhập lại không khớp
            request.setAttribute("mess", "Mật khẩu không khớp!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else {
            UserDAO dao = new UserDAO();
            user u = dao.checkUserExist(user); // Kiểm tra xem user đã có chưa
            
            if(u == null) {
                // Chưa có -> Cho phép đăng ký -> LƯU VÀO DB
                dao.register(user, pass, email, fullname, phone);
                
                // Đăng ký xong chuyển về trang đăng nhập
                response.sendRedirect("login.jsp");
            } else {
                // Đã tồn tại -> Báo lỗi
                request.setAttribute("mess", "Tên đăng nhập đã tồn tại!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        }
    }
}