package controller;

import java.io.IOException;
import java.util.List;
import dao.UserDAO;
import model.user;
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
        String type = request.getParameter("type");
        String keyword = request.getParameter("search");
        UserDAO dao = new UserDAO();


        // --- 2. LẤY DANH SÁCH USER ---
        List<user> list;
        if (keyword != null && !keyword.trim().isEmpty()) {
            list = dao.searchUsers(keyword.trim());
            request.setAttribute("searchKeyword", keyword);
        } else {
            list = dao.getAllUsers();
        }
        
        // Lọc ẩn Admin
        if (list != null) {
            list.removeIf(u -> u.getIsAdmin() == 1);
        }

        request.setAttribute("listUsers", list);
        request.getRequestDispatcher("admin-users.jsp").forward(request, response);
    }
}