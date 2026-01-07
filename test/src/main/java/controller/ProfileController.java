package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.user;
import dao.UserDAO;
import util.MD5; // [QUAN TRỌNG]: Phải có dòng này để dùng được MD5
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
        } else {
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }

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

        // ------------------------------------------
        // TRƯỜNG HỢP 1: UPLOAD ẢNH ĐẠI DIỆN
        // ------------------------------------------
        if ("upload-avatar".equals(action)) {
            try {
                Part filePart = request.getPart("avatarFile");
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                if (fileName != null && !fileName.isEmpty()) {
                    // Tạo tên file duy nhất
                    String newFileName = "avatar_" + currentUser.getUid() + "_" + System.currentTimeMillis() + "_" + fileName;
                    
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "img" + File.separator + "avatars";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();
                    
                    filePart.write(uploadPath + File.separator + newFileName);
                    
                    dao.updateAvatar(currentUser.getUid(), newFileName);
                    
                    currentUser.setAvatar(newFileName);
                    session.setAttribute("user", currentUser);
                    
                    request.setAttribute("msgInfo", "Đổi ảnh đại diện thành công!");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("msgInfo", "Lỗi upload ảnh: " + e.getMessage());
            }
        } 
        // ------------------------------------------
        // TRƯỜNG HỢP 2: CẬP NHẬT THÔNG TIN CÁ NHÂN
        // ------------------------------------------
        else if ("update-info".equals(action)) {
            String username = request.getParameter("username"); // Thường username không cho sửa, nhưng nếu form gửi lên thì cứ lấy
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            // Lưu ý: Nếu logic của bạn không cho đổi username thì đừng set lại username
            currentUser.setFullname(fullname);
            currentUser.setEmail(email);
            currentUser.setPhonenumber(phone);

            boolean isUpdated = dao.updateUserInfo(currentUser);

            if (isUpdated) {
                session.setAttribute("user", currentUser);
                request.setAttribute("msgInfo", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("msgInfo", "Lỗi! Không thể cập nhật.");
            }
        } 
        // ------------------------------------------
        // TRƯỜNG HỢP 3: ĐỔI MẬT KHẨU (ĐÃ SỬA LỖI)
        // ------------------------------------------
        else if ("change-pass".equals(action)) {
            String oldPass = request.getParameter("old_pass");
            String newPass = request.getParameter("new_pass");
            String confirmPass = request.getParameter("confirm_pass");

            // Kiểm tra mật khẩu xác nhận trước
            if (!newPass.equals(confirmPass)) {
                request.setAttribute("errPass", "Mật khẩu xác nhận không khớp!");
            } else {
                // [QUAN TRỌNG]: Mã hóa mật khẩu cũ người dùng nhập vào để so sánh
                String oldPassHash = MD5.getMd5(oldPass);

                // currentUser.getPassword() trả về mật khẩu đã mã hóa (từ DB)
                // Lưu ý: Nếu hàm get mật khẩu trong file user.java tên khác (ví dụ getPasswordHash), hãy sửa lại dòng dưới đây
                if (!oldPassHash.equals(currentUser.getPasswordHash())) { 
                    request.setAttribute("errPass", "Mật khẩu cũ không đúng!");
                } else {
                    // [QUAN TRỌNG]: Mã hóa mật khẩu mới trước khi lưu xuống DB
                    String newPassHash = MD5.getMd5(newPass);
                    
                    boolean isChanged = dao.changePassword(currentUser.getUsername(), newPassHash);
                    if (isChanged) {
                        // Cập nhật lại mật khẩu mới (đã hash) vào session
                        currentUser.setPasswordHash(newPassHash); 
                        session.setAttribute("user", currentUser);
                        request.setAttribute("msgPass", "Đổi mật khẩu thành công!");
                    } else {
                        request.setAttribute("errPass", "Lỗi hệ thống! Vui lòng thử lại.");
                    }
                }
            }
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}