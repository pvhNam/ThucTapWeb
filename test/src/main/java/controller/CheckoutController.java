package controller;

import java.io.IOException;
import java.util.List;

import dao.CartDAO;
import dao.ProductDAO;
import dao.VoucherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.cartItem;
import model.user;
import model.Voucher;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // GET: Nếu người dùng gõ /checkout trực tiếp -> Chuyển về giỏ hàng
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("cart");
    }

    // POST: Xử lý nút "THANH TOÁN" từ Cart
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Lấy giỏ hàng hiện tại
        CartDAO cartDao = new CartDAO();
        List<cartItem> cart = cartDao.getCartByUid(currentUser.getUid());

        if (cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        // --- BƯỚC QUAN TRỌNG: LƯU ĐƠN HÀNG & TRỪ KHO ---
        
        ProductDAO pDao = new ProductDAO();
        for (cartItem item : cart) {
            // A. Trừ số lượng tồn kho trong Database
            pDao.decreaseStock(item.getProduct().getPid(), item.getQuantity());
        }

        // B. Xử lý Voucher (Nếu có dùng)
        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");
        if (appliedVoucher != null) {
            VoucherDAO vDao = new VoucherDAO();
            // Đánh dấu mã này là đã sử dụng
            vDao.markVoucherUsed(currentUser.getUid(), appliedVoucher.getId());
            
            // Xóa khỏi session để lần mua sau không bị dính mã cũ
            session.removeAttribute("appliedVoucher");
        }

        // C. Xóa sạch giỏ hàng (Vì đã mua xong)
        cartDao.clearCart(currentUser.getUid());

        // D. Chuyển hướng đến trang Thành Công
        response.sendRedirect("order-success.jsp");
    }
}