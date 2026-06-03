package controller.user;

import java.io.IOException;

import dao.CartDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.User;

@WebServlet("/buy-now")
public class BuyNowController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Yêu cầu đăng nhập nếu chưa có session
        if (currentUser == null) {
            resp.sendRedirect("login");
            return;
        }

        int pid = 0;
        int quantity = 1;
        try {
            pid = Integer.parseInt(req.getParameter("pid"));
            String qStr = req.getParameter("quantity");
            if (qStr != null && !qStr.isEmpty()) {
                quantity = Integer.parseInt(qStr);
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect("home");
            return;
        }

        // Lấy thêm tham số màu sắc và kích cỡ từ request
        String color = req.getParameter("color");
        String size = req.getParameter("size");
        if (color == null) color = "";
        if (size == null) size = "";

        ProductDAO productDAO = new ProductDAO();
        Product p = productDAO.getProductById(pid);
        if (p == null) {
            resp.sendRedirect("home");
            return;
        }

        // Kiểm tra tồn kho
        if (quantity > p.getStockquantyti()) {
            quantity = p.getStockquantyti();
        }

        CartDAO cartDAO = new CartDAO();
        // Cập nhật hàm addToCart với đủ 5 tham số
        cartDAO.addToCart(currentUser.getUid(), pid, color, size, quantity);

        // Mua ngay nên chuyển hướng thẳng tới trang thanh toán
        resp.sendRedirect("checkout");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect("home");
    }
}