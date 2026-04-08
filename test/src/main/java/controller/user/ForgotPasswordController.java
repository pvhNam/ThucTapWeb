package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.UserDAO;
import model.User;
import util.EmailUtil;
import java.io.IOException;
import java.util.Random;

@WebServlet("/forgotPassword")
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/user/forgot-password.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO dao = new UserDAO();
        User u = dao.checkEmailExist(email);

        if (u != null) {
            Random rand = new Random();
            int otpValue = 100000 + rand.nextInt(900000);

            String subject = "Ma xac thuc dat lai mat khau";
            String message = "Ma OTP cua ban la: " + otpValue;

            try {
                EmailUtil.sendEmail(email, subject, message);
            } catch (Exception e) {
                request.setAttribute("message", "Loi gui mail! Vui long thu lai.");
                request.getRequestDispatcher("/views/user/forgot-password.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("otp", otpValue);
            session.setAttribute("email", email);
            session.setAttribute("resetUsername", u.getUsername());

            request.setAttribute("message", "Ma OTP da duoc gui den email cua ban.");
            request.getRequestDispatcher("/views/user/verify-otp.jsp").forward(request, response);

        } else {
            request.setAttribute("message", "Email khong ton tai trong he thong!");
            request.getRequestDispatcher("/views/user/forgot-password.jsp").forward(request, response);
        }
    }
}
