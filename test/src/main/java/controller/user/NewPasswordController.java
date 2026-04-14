package controller.user;

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

        if (newPassword == null || confPassword == null) {
            request.setAttribute("message", "Vui long nhap mat khau!");
            request.getRequestDispatcher("/new_password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confPassword)) {
            request.setAttribute("message", "Mat khau xac nhan khong khop!");
            request.getRequestDispatcher("/new_password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.matches("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$")) {
            request.setAttribute("message", "Mat khau yeu! Can 8 ky tu, 1 chu hoa, 1 thuong va 1 so.");
            request.getRequestDispatcher("/new_password.jsp").forward(request, response);
            return;
        }

        String hashedPassword = MD5.getMd5(newPassword);
        UserDAO dao = new UserDAO();
        boolean isUpdated = dao.changePassword(username, hashedPassword);

        if (isUpdated) {
            session.removeAttribute("otp");
            session.removeAttribute("resetUsername");
            request.setAttribute("error", "Doi mat khau thanh cong! Hay dang nhap lai.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("message", "Loi he thong, vui long thu lai sau.");
            request.getRequestDispatcher("/new_password.jsp").forward(request, response);
        }
    }
}
