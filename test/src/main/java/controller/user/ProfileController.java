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
import dao.UserDAO;
import util.MD5;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

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
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                if (fileName != null && !fileName.isEmpty()) {
                    String newFileName = "avatar_" + currentUser.getUid() + "_" + System.currentTimeMillis() + "_" + fileName;

                    String uploadPath = getServletContext().getRealPath("") + File.separator + "img" + File.separator + "avatars";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();

                    filePart.write(uploadPath + File.separator + newFileName);
                    dao.updateAvatar(currentUser.getUid(), newFileName);

                    currentUser.setAvatar(newFileName);
                    session.setAttribute("user", currentUser);
                    request.setAttribute("msgInfo", "Doi anh dai dien thanh cong!");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("msgInfo", "Loi upload anh: " + e.getMessage());
            }
        } else if ("update-info".equals(action)) {
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            currentUser.setFullname(fullname);
            currentUser.setEmail(email);
            currentUser.setPhonenumber(phone);

            boolean isUpdated = dao.updateUserInfo(currentUser);

            if (isUpdated) {
                session.setAttribute("user", currentUser);
                request.setAttribute("msgInfo", "Cap nhat thong tin thanh cong!");
            } else {
                request.setAttribute("msgInfo", "Loi! Khong the cap nhat.");
            }
        } else if ("change-pass".equals(action)) {
            String oldPass = request.getParameter("old_pass");
            String newPass = request.getParameter("new_pass");
            String confirmPass = request.getParameter("confirm_pass");

            if (!newPass.equals(confirmPass)) {
                request.setAttribute("errPass", "Mat khau xac nhan khong khop!");
            } else {
                String oldPassHash = MD5.getMd5(oldPass);
                if (!oldPassHash.equals(currentUser.getPasswordHash())) {
                    request.setAttribute("errPass", "Mat khau cu khong dung!");
                } else {
                    String newPassHash = MD5.getMd5(newPass);
                    boolean isChanged = dao.changePassword(currentUser.getUsername(), newPassHash);
                    if (isChanged) {
                        currentUser.setPasswordHash(newPassHash);
                        session.setAttribute("user", currentUser);
                        request.setAttribute("msgPass", "Doi mat khau thanh cong!");
                    } else {
                        request.setAttribute("errPass", "Loi he thong! Vui long thu lai.");
                    }
                }
            }
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
