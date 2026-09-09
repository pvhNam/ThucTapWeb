package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.User;
import dao.LoyaltyDAO;
import dao.UserDAO;
import util.MD5;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login");
        } else {
            User currentUser = (User) session.getAttribute("user");
            request.setAttribute("membership", new LoyaltyDAO().getMembership(currentUser.getUid()));
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        if ("upload-avatar".equals(action)) {
            try {
                Part filePart = request.getPart("avatarFile");
                String contentType = filePart == null ? "" : String.valueOf(filePart.getContentType());
                String extension = switch (contentType) {
                    case "image/jpeg" -> ".jpg";
                    case "image/png" -> ".png";
                    case "image/webp" -> ".webp";
                    default -> "";
                };
                if (filePart == null || filePart.getSize() == 0 || filePart.getSize() > 10 * 1024 * 1024 || extension.isEmpty()) {
                    request.setAttribute("errInfo", "Vui lòng chọn ảnh JPG, PNG hoặc WEBP không quá 10 MB.");
                } else {
                    String newFileName = "avatar_" + currentUser.getUid() + "_" + UUID.randomUUID() + extension;

                    String uploadPath = getServletContext().getRealPath("") + File.separator + "img" + File.separator + "avatars";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists() && !uploadDir.mkdirs()) throw new IOException("Unable to create avatar directory");

                    filePart.write(uploadPath + File.separator + newFileName);
                    if (dao.updateAvatar(currentUser.getUid(), newFileName)) {
                        currentUser.setAvatar(newFileName);
                        session.setAttribute("user", currentUser);
                        request.setAttribute("msgInfo", "Đã cập nhật ảnh đại diện.");
                    } else {
                        request.setAttribute("errInfo", "Không thể lưu ảnh đại diện. Vui lòng thử lại.");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errInfo", "Không thể tải ảnh lên. Vui lòng chọn ảnh hợp lệ không quá 10 MB và thử lại.");
            }
        } else if ("update-info".equals(action)) {
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            User updatedUser = new User(currentUser.getUid(), currentUser.getUsername(), currentUser.getPasswordHash(),
                    email, fullname, phone, currentUser.getAvatar(), currentUser.getIsAdmin());
            boolean valid = fullname != null && !fullname.isBlank() && fullname.length() <= 100
                    && email != null && email.length() <= 100 && email.matches("[^\\s@]+@[^\\s@]+\\.[^\\s@]+")
                    && phone != null && !phone.isBlank() && phone.length() <= 20;
            boolean isUpdated = valid && dao.updateUserInfo(updatedUser);

            if (isUpdated) {
                currentUser = updatedUser;
                session.setAttribute("user", currentUser);
                request.setAttribute("msgInfo", "Đã cập nhật thông tin cá nhân.");
            } else {
                request.setAttribute("errInfo", valid ? "Không thể cập nhật thông tin. Vui lòng thử lại."
                        : "Vui lòng nhập đầy đủ họ tên, email hợp lệ và số điện thoại.");
            }
        } else if ("change-pass".equals(action)) {
            String oldPass = request.getParameter("old_pass");
            String newPass = request.getParameter("new_pass");
            String confirmPass = request.getParameter("confirm_pass");

            if (oldPass == null || newPass == null || newPass.isBlank() || !newPass.equals(confirmPass)) {
                request.setAttribute("errPass", "Vui lòng nhập đủ mật khẩu và xác nhận trùng khớp.");
            } else {
                String oldPassHash = MD5.getMd5(oldPass);
                if (!oldPassHash.equals(currentUser.getPasswordHash())) {
                    request.setAttribute("errPass", "Mật khẩu hiện tại không đúng.");
                } else {
                    String newPassHash = MD5.getMd5(newPass);
                    boolean isChanged = dao.changePassword(currentUser.getUsername(), newPassHash);
                    if (isChanged) {
                        currentUser.setPasswordHash(newPassHash);
                        session.setAttribute("user", currentUser);
                        request.setAttribute("msgPass", "Đã đổi mật khẩu thành công.");
                    } else {
                        request.setAttribute("errPass", "Không thể đổi mật khẩu. Vui lòng thử lại.");
                    }
                }
            }
        }

        request.setAttribute("membership", new LoyaltyDAO().getMembership(currentUser.getUid()));
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
