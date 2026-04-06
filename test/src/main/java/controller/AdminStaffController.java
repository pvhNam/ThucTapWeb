package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user;

import java.io.IOException;
import java.util.List;

import dao.UserDAO;

/**
 * Servlet implementation class AdminStaffController
 */
@WebServlet("/admin-staffs")
public class AdminStaffController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        user currUser = (user) session.getAttribute("user");
        Boolean isHardcodedAdmin = (Boolean) session.getAttribute("isAdmin");
        int role = (currUser != null) ? currUser.getIsAdmin() : ((isHardcodedAdmin != null && isHardcodedAdmin) ? 1 : 0);

        if (role == 0) { response.sendRedirect("login.jsp"); return; }

        UserDAO dao = new UserDAO();
        String type = request.getParameter("type");

        // --- TÍNH NĂNG XÓA NHÂN VIÊN ---
        if ("delete".equals(type)) {
            if (role != 1) { // Chỉ Admin mới được xóa
                response.sendRedirect("admin-staffs?msg=error_permission");
                return;
            }
            int uid = Integer.parseInt(request.getParameter("uid"));
            dao.deleteUser(uid); 
            response.sendRedirect("admin-staffs?msg=deleted");
            return;
        }

       
        if ("changepass".equals(type)) {
            if (role != 1) { response.sendRedirect("admin-staffs?msg=error_permission"); return; }
            String uname = request.getParameter("uname");
            String newPass = util.MD5.getMd5(request.getParameter("newpass"));
            dao.changePassword(uname, newPass);
            response.sendRedirect("admin-staffs?msg=pass_changed");
            return;
        }

        List<user> list = dao.getAllUsers();
        if (list != null) {
            list.removeIf(u -> u.getIsAdmin() != 2);
        }
        request.setAttribute("listStaffs", list);
        request.getRequestDispatcher("admin-staffs.jsp").forward(request, response);
    }
}
