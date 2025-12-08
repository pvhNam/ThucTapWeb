package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout") // Đường dẫn này phải khớp với href trong file index.jsp
public class LogoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LogoutController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Lấy session hiện tại. 
        // Tham số 'false' nghĩa là: nếu chưa có session thì đừng tạo mới (trả về null).
        HttpSession session = request.getSession(false);
        
        // 2. Nếu session tồn tại, thực hiện hủy nó
        if (session != null) {
            session.invalidate(); // Lệnh này xóa sạch dữ liệu "user" đã lưu
        }
        
        
        // 3. Chuyển hướng về trang chủ
        // Sau khi redirect, trang index.jsp sẽ kiểm tra lại session -> thấy null -> hiện nút Đăng nhập
        response.sendRedirect("index.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}