package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.UserDAO;
import util.MD5;
import java.io.IOException;

@WebServlet("/newPassword")
public class NewPasswordController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String newPassword = request.getParameter("password");
		String confPassword = request.getParameter("confPassword");
		HttpSession session = request.getSession();
		String username = (String) session.getAttribute("resetUsername");

        // Kiểm tra null trước để tránh lỗi NullPointerException
        if (newPassword == null || confPassword == null) {
            request.setAttribute("message", "Vui lòng nhập mật khẩu!");
			request.getRequestDispatcher("new_password.jsp").forward(request, response);
            return;
        }

        // 1. Kiểm tra khớp mật khẩu
		if (!newPassword.equals(confPassword)) {
            request.setAttribute("message", "Mật khẩu xác nhận không khớp!");
			request.getRequestDispatcher("new_password.jsp").forward(request, response);
            return;
        }

        // 2. [MỚI] Kiểm tra độ mạnh mật khẩu
        // Bạn có thể thêm ký tự đặc biệt bằng cách thêm (?=.*[@#$%^&+=]) vào regex
        if (!newPassword.matches("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$")) {
            request.setAttribute("message", "Mật khẩu yếu! Cần 8 ký tự, 1 chữ hoa, 1 thường và 1 số.");
			request.getRequestDispatcher("new_password.jsp").forward(request, response);
            return;
        }

        // Nếu mọi thứ OK -> Mã hóa và lưu
        String hashedPassword = MD5.getMd5(newPassword);
        UserDAO dao = new UserDAO();
        boolean isUpdated = dao.changePassword(username, hashedPassword); 

        if (isUpdated) {
            session.removeAttribute("otp");
            session.removeAttribute("resetUsername");
            request.setAttribute("error", "Đổi mật khẩu thành công! Hãy đăng nhập lại."); 
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("message", "Lỗi hệ thống, vui lòng thử lại sau.");
            request.getRequestDispatcher("new_password.jsp").forward(request, response);
        }
	}
}