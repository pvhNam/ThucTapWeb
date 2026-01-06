package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/validateOtp")
public class ValidateOtpController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int value = Integer.parseInt(request.getParameter("otp"));
		HttpSession session = request.getSession();
		Integer otp = (Integer) session.getAttribute("otp");

		if (otp != null && value == otp) {
			// OTP đúng -> Cho phép đổi mật khẩu
			request.setAttribute("email", session.getAttribute("email"));
			request.getRequestDispatcher("new_password.jsp").forward(request, response);
		} else {
			// OTP sai
			request.setAttribute("message", "Mã OTP không chính xác!");
			request.getRequestDispatcher("verify_otp.jsp").forward(request, response);
		}
	}
}