package controller;

import java.io.IOException;
import dao.UserDAO;
import model.user;
import util.MD5;
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
        
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        String re_pass = request.getParameter("re_pass");
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");

        // 1. Kiểm tra mật khẩu nhập lại
        if(!pass.equals(re_pass)) {
            request.setAttribute("mess", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } 
        // 2. [MỚI] Kiểm tra độ mạnh mật khẩu (Regex)
        // Giải thích regex:
        // (?=.*[0-9]): Chứa ít nhất 1 số
        // (?=.*[a-z]): Chứa ít nhất 1 chữ thường
        // (?=.*[A-Z]): Chứa ít nhất 1 chữ hoa
        // .{8,}: Độ dài tối thiểu 8 ký tự
        else if (!pass.matches("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$")) {
            request.setAttribute("mess", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
        else {
            UserDAO dao = new UserDAO();
            user u = dao.checkUserExist(user);
            
            if(u == null) {
                // Mã hóa và lưu
                String hashedPassword = MD5.getMd5(pass);
                dao.register(user, hashedPassword, email, fullname, phone);
                response.sendRedirect("login.jsp");
            } else {
                request.setAttribute("mess", "Tên đăng nhập đã tồn tại!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        }
    }
}