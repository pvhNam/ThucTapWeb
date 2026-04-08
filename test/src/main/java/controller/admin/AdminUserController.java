package controller.admin;

import java.io.IOException;
import java.util.List;
import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-users")
public class AdminUserController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String keyword = request.getParameter("search");
        UserDAO dao = new UserDAO();

        List<User> list;
        if (keyword != null && !keyword.trim().isEmpty()) {
            list = dao.searchUsers(keyword.trim());
        } else {
            list = dao.getAllUsers();
        }

        if (list != null) {
            list.removeIf(u -> u.getIsAdmin() != 0);
        }

        request.setAttribute("listUsers", list);
        request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
    }
}
