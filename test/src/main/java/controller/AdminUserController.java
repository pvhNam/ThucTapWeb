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

        // Xóa User
        if ("delete".equals(type)) {
            String uidStr = request.getParameter("uid");
            if (uidStr != null) {
                try {
                    int uid = Integer.parseInt(uidStr);
                    dao.deleteUser(uid);
                } catch (NumberFormatException e) { e.printStackTrace(); }
            }
            response.sendRedirect("admin-users?msg=deleted");
            return;
        }

        // Lấy danh sách (Tìm kiếm hoặc Tất cả)
        List<user> list;
        if (keyword != null && !keyword.trim().isEmpty()) {
            list = dao.searchUsers(keyword.trim());
            request.setAttribute("searchKeyword", keyword);
        } else {
            list = dao.getAllUsers();
        }
        
        request.setAttribute("listUsers", list);
        request.getRequestDispatcher("admin-users.jsp").forward(request, response);
    }
}