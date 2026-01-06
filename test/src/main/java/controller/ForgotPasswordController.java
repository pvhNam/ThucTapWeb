package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.UserDAO;
import model.user;
import util.EmailUtil;
import java.io.IOException;
import java.util.Random;

@WebServlet("/forgotPassword")
public class ForgotPasswordController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
		UserDAO dao = new UserDAO();
		user u = dao.checkEmailExist(email);

		if (u != null) {
			// 1. Tạo mã OTP 6 số
			Random rand = new Random();
			int otpValue = 100000 + rand.nextInt(900000); // 100000 -> 999999

			// 2. Gửi Email
			String subject = "Mã xác thực đặt lại mật khẩu";
			String message = "Mã OTP của bạn là: " + otpValue;
			
			try {
				EmailUtil.sendEmail(email, subject, message);
			} catch (Exception e) {
				request.setAttribute("message", "Lỗi gửi mail! Vui lòng thử lại.");
				request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
				return;
			}

			// 3. Lưu OTP và thông tin user vào Session để check ở bước sau
			HttpSession session = request.getSession();
			session.setAttribute("otp", otpValue); 
			session.setAttribute("email", email);
			session.setAttribute("resetUsername", u.getUsername()); // Lưu username để đổi pass

			// 4. Chuyển sang trang nhập OTP
			request.setAttribute("message", "Mã OTP đã được gửi đến email của bạn.");
			request.getRequestDispatcher("verify_otp.jsp").forward(request, response);
			
		} else {
			request.setAttribute("message", "Email không tồn tại trong hệ thống!");
			request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
		}
	}
}