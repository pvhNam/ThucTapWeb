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
        
        String type = request.getParameter("type");
        UserDAO dao = new UserDAO();

        // --- XỬ LÝ XÓA USER ---
        if ("delete".equals(type)) {
            String uidStr = request.getParameter("uid"); // Lấy tham số uid
            if (uidStr != null) {
                try {
                    int uid = Integer.parseInt(uidStr);
                    dao.deleteUser(uid);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            // Xóa xong reload lại trang
            response.sendRedirect("admin-users?msg=deleted");
            return;
        }

        // --- HIỂN THỊ DANH SÁCH ---
        List<user> list = dao.getAllUsers();
        request.setAttribute("listUsers", list);
        request.getRequestDispatcher("admin-users.jsp").forward(request, response);
    }
}