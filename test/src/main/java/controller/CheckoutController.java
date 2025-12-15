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
        
        // ================== ĐOẠN CẦN THÊM VÀO ==================
        // 1. Tính tổng tiền đơn hàng
        double totalMoney = 0;
        for (cartItem item : cart) {
            totalMoney += item.getTotalPrice(); // Giả sử model cartItem có hàm này
        }
        
        // Nếu có voucher thì trừ tiền voucher (logic đơn giản)
        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");
        if (appliedVoucher != null) {
            // Logic giảm giá của bạn (ví dụ giảm trực tiếp hoặc %)
            // totalMoney = totalMoney - giamGia;
        }

        // 2. Lấy địa chỉ từ form (người dùng nhập ở trang cart)
        String address = request.getParameter("address"); 
        if(address == null) address = "Địa chỉ mặc định"; // Xử lý nếu null

        // 3. LƯU VÀO DATABASE (Đây là bước bạn bị thiếu)
        dao.OrderDAO orderDao = new dao.OrderDAO();
        // Gọi hàm vừa viết ở Bước 1
        int newOrderId = orderDao.createOrder(currentUser.getUid(), totalMoney, address); 
        // =======================================================

        // 4. Trừ kho (Code cũ của bạn)
        ProductDAO pDao = new ProductDAO();
        for (cartItem item : cart) {
            // A. Trừ số lượng tồn kho trong Database
            pDao.decreaseStock(item.getProduct().getPid(), item.getQuantity());
            
            // (Nâng cao: Tại đây bạn nên lưu chi tiết đơn hàng vào bảng order_details dùng newOrderId)
        }

        // B. Xử lý Voucher (Code cũ của bạn - Giữ nguyên)
        if (appliedVoucher != null) {
            VoucherDAO vDao = new VoucherDAO();
            vDao.markVoucherUsed(currentUser.getUid(), appliedVoucher.getId());
            session.removeAttribute("appliedVoucher");
        }

        // C. Xóa sạch giỏ hàng (Code cũ của bạn - Giữ nguyên)
        cartDao.clearCart(currentUser.getUid());

        // D. Chuyển hướng
        response.sendRedirect("order-success.jsp");
}
}