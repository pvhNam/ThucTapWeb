package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.UserDAO;
import util.MD5; // Import MD5
import java.io.IOException;

@WebServlet("/newPassword")
public class NewPasswordController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String newPassword = request.getParameter("password");
		String confPassword = request.getParameter("confPassword");
		HttpSession session = request.getSession();
		String username = (String) session.getAttribute("resetUsername");

		if (newPassword != null && confPassword != null && newPassword.equals(confPassword)) {
			
            // Mã hóa mật khẩu mới trước khi lưu
            String hashedPassword = MD5.getMd5(newPassword);

			UserDAO dao = new UserDAO();
			// Hàm changePassword của bạn đã có sẵn trong file UserDAO.java
			boolean isUpdated = dao.changePassword(username, hashedPassword); 

			if (isUpdated) {
				// Xóa session OTP để bảo mật
				session.removeAttribute("otp");
				session.removeAttribute("resetUsername");
                
                // Chuyển về login
                request.setAttribute("error", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập."); 
                // Dùng key "error" để hiện thông báo xanh ở trang login (cần sửa css login chút nếu muốn màu xanh)
                // hoặc dùng sendRedirect nếu không cần báo
				request.getRequestDispatcher("login.jsp").forward(request, response);
			} else {
				request.setAttribute("message", "Lỗi hệ thống, không thể đổi mật khẩu.");
				request.getRequestDispatcher("new_password.jsp").forward(request, response);
			}
		} else {
			request.setAttribute("message", "Mật khẩu xác nhận không khớp!");
			request.getRequestDispatcher("new_password.jsp").forward(request, response);
		}
	}
}