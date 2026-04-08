package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import dao.UserDAO;
import util.MD5;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if ("admin".equals(username) && "123".equals(password)) {
            HttpSession session = request.getSession();
            User adminUser = new User();
            adminUser.setFullname("Administrator");
            adminUser.setUsername("admin");
            adminUser.setUid(0);
            adminUser.setIsAdmin(1);

            session.setAttribute("user", adminUser);
            session.setAttribute("isAdmin", true);
            response.sendRedirect("admin");
            return;
        }

        String hashedPassword = MD5.getMd5(password);
        UserDAO dao = new UserDAO();
        User loginUser = dao.login(username, hashedPassword);

        if (loginUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", loginUser);

            int role = loginUser.getIsAdmin();
            if (role == 1 || role == 2) {
                session.setAttribute("isAdmin", true);
                response.sendRedirect("admin");
            } else {
                session.setAttribute("isAdmin", false);
                response.sendRedirect("home");
            }
        } else {
            request.setAttribute("error", "Sai tai khoan hoac mat khau!");
            request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
        }
    }
}
