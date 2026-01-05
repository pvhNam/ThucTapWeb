package controller;

import java.io.IOException;
import dao.UserDAO;
import model.user;
import util.MD5; // Import class MD5
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Lấy dữ liệu từ form
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        String re_pass = request.getParameter("re_pass");
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");

        // Kiểm tra mật khẩu nhập lại
        if(!pass.equals(re_pass)) {
            request.setAttribute("mess", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else {
            UserDAO dao = new UserDAO();
            user u = dao.checkUserExist(user); // Kiểm tra user tồn tại
            
            if(u == null) {
                // User chưa tồn tại -> Tiến hành đăng ký
                
                // --- BƯỚC QUAN TRỌNG: MÃ HÓA PASSWORD ---
                String hashedPassword = MD5.getMd5(pass);
                
                // Lưu vào DB với mật khẩu đã mã hóa
                dao.register(user, hashedPassword, email, fullname, phone);
                
                // Chuyển về trang login
                response.sendRedirect("login.jsp");
            } else {
                // User đã tồn tại -> Báo lỗi
                request.setAttribute("mess", "Tên đăng nhập đã tồn tại!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        }
    }
}