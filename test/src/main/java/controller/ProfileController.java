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

    // Xử lý cập nhật (Thông tin, Mật khẩu, Avatar)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");
        
        // Nếu chưa đăng nhập thì đá về trang login
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
                    // Tạo tên file duy nhất để tránh trùng lặp
                    String newFileName = "avatar_" + currentUser.getUid() + "_" + System.currentTimeMillis() + "_" + fileName;
                    
                    // Đường dẫn lưu file: WebContent/img/avatars
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "img" + File.separator + "avatars";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir(); // Tạo thư mục nếu chưa có
                    
                    // Ghi file
                    filePart.write(uploadPath + File.separator + newFileName);
                    
                    // 1. Cập nhật Database
                    dao.updateAvatar(currentUser.getUid(), newFileName);
                    
                    // 2. Cập nhật Session (Quan trọng: để Header đổi ảnh ngay lập tức)
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
            String username = request.getParameter("username");
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            currentUser.setUsername(username);
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
        // TRƯỜNG HỢP 3: ĐỔI MẬT KHẨU
        // ------------------------------------------
        else if ("change-pass".equals(action)) {
            String oldPass = request.getParameter("old_pass");
            String newPass = request.getParameter("new_pass");
            String confirmPass = request.getParameter("confirm_pass");

            // Lưu ý: Nếu bạn đã dùng MD5 ở bước trước, hãy nhớ mã hóa oldPass và newPass trước khi so sánh/lưu
            // Ở đây tôi viết logic so sánh chuỗi hash trong object user (đã hash từ lúc login)
            
            if (!oldPass.equals(currentUser.getPasswordHash())) { 
                // Nếu bạn dùng MD5: if (!MD5.getMd5(oldPass).equals(currentUser.getPasswordHash()))
                request.setAttribute("errPass", "Mật khẩu cũ không đúng!");
            } else if (!newPass.equals(confirmPass)) {
                request.setAttribute("errPass", "Mật khẩu xác nhận không khớp!");
            } else {
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

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}