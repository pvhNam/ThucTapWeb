package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user;
import dao.UserDAO;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Hiển thị trang profile
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
        } else {
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }

    //Xử lý cập nhật
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        if ("update-info".equals(action)) {
            // 1. Xử lý cập nhật thông tin cá nhân
        	String username = request.getParameter("username");
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            // Cập nhật object
            currentUser.setUsername(username);
            currentUser.setFullname(fullname);
            currentUser.setEmail(email);
            currentUser.setPhonenumber(phone);

            // Gọi DAO update
            boolean isUpdated = dao.updateUserInfo(currentUser);

            if (isUpdated) {
                // Cập nhật lại session
                session.setAttribute("user", currentUser);
                request.setAttribute("msgInfo", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("msgInfo", "Lỗi! Không thể cập nhật.");
            }

        } else if ("change-pass".equals(action)) {
            // Xử lý đổi mật khẩu
            String oldPass = request.getParameter("old_pass");
            String newPass = request.getParameter("new_pass");
            String confirmPass = request.getParameter("confirm_pass");

            // Kiểm tra mật khẩu cũ
            if (!oldPass.equals(currentUser.getPasswordHash())) {
                request.setAttribute("errPass", "Mật khẩu cũ không đúng!");
            } else if (!newPass.equals(confirmPass)) {
                request.setAttribute("errPass", "Mật khẩu xác nhận không khớp!");
            } else {
                // Đổi pass trong DB
                boolean isChanged = dao.changePassword(currentUser.getUsername(), newPass);
                if (isChanged) {
                    currentUser.setPasswordHash(newPass);
                    session.setAttribute("user", currentUser);
                    request.setAttribute("msgPass", "Đổi mật khẩu thành công!");
                } else {
                    request.setAttribute("errPass", "Lỗi hệ thống! Vui lòng thử lại.");
                }
            }
        }

        // Forward lại trang profile để hiện thông báo
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}