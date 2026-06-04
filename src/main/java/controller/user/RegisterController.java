package controller.user;

import java.io.IOException;
import dao.UserDAO;
import model.User;
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
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("user");
        String pass = request.getParameter("pass");
        String re_pass = request.getParameter("re_pass");
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");

        if (!pass.equals(re_pass)) {
            request.setAttribute("mess", "Mat khau nhap lai khong khop!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } else if (!pass.matches("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$")) {
            request.setAttribute("mess", "Mat khau phai co it nhat 8 ky tu, bao gom chu hoa, chu thuong va so!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } else {
            UserDAO dao = new UserDAO();
            User existing = dao.checkUserExist(username);

            if (existing == null) {
                String hashedPassword = MD5.getMd5(pass);
                dao.register(username, hashedPassword, email, fullname, phone);
                response.sendRedirect("login");
            } else {
                request.setAttribute("mess", "Ten dang nhap da ton tai!");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        }
    }
}
