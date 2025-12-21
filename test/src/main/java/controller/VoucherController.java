package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user;
import model.Voucher;
import dao.VoucherDAO;
import java.io.IOException;

@WebServlet("/voucher")
public class VoucherController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Nhận dữ liệu
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");
        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
            response.getWriter().write("LOGIN_REQUIRED");
            return;
        }
        VoucherDAO vDao = new VoucherDAO();

        if ("save".equals(action)) {
            String code = request.getParameter("code");
            Voucher v = vDao.getVoucherByCode(code);

            if (v != null) {
                boolean saved = vDao.saveVoucherToWallet(currentUser.getUid(), v.getId());
                if (saved) {
                    response.getWriter().write("SUCCESS");
                } else {
                    response.getWriter().write("EXISTED"); // Đã có trong ví
                }
            } else {
                response.getWriter().write("INVALID"); // Mã không tồn tại
            }
        }
    }
}