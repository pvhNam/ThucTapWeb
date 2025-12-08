package controller;

import java.io.IOException;
import java.util.List;

import dao.CartDAO;
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

    // GET: Hiển thị trang thanh toán (checkout.jsp)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy giỏ hàng để hiển thị số tiền tạm tính
        CartDAO cartDao = new CartDAO();
        List<cartItem> cart = cartDao.getCartByUid(currentUser.getUid());
        
        double subtotal = 0;
        for (cartItem item : cart) {
            subtotal += item.getTotalPrice();
        }

        request.setAttribute("subtotal", subtotal);
        request.setAttribute("cartList", cart);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    // POST: Xử lý nút "ĐẶT HÀNG"
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Lấy thông tin từ form checkout
        String address = request.getParameter("address");
        String note = request.getParameter("note");
        String voucherCode = request.getParameter("voucherCode"); // Mã voucher người dùng nhập/chọn

        // 2. Tính tổng tiền hàng
        CartDAO cartDao = new CartDAO();
        List<cartItem> cart = cartDao.getCartByUid(currentUser.getUid());
        double totalAmount = 0;
        for (cartItem item : cart) {
            totalAmount += item.getTotalPrice();
        }

        // 3. Xử lý Voucher (Nếu có)
        VoucherDAO vDao = new VoucherDAO();
        double discount = 0;
        Voucher usedVoucher = null;

        if (voucherCode != null && !voucherCode.isEmpty()) {
            // Lấy thông tin voucher
            usedVoucher = vDao.getVoucherByCode(voucherCode);
            
            // Kiểm tra xem người dùng CÓ voucher này trong ví không và chưa dùng
            boolean hasVoucher = vDao.checkUserHasVoucher(currentUser.getUid(), usedVoucher.getId());
            
            if (usedVoucher != null && hasVoucher) {
                // Tính toán giảm giá
                if ("PERCENT".equals(usedVoucher.getDiscountType())) {
                    discount = totalAmount * (usedVoucher.getDiscountAmount() / 100);
                } else {
                    discount = usedVoucher.getDiscountAmount();
                }
            }
        }

        double finalTotal = totalAmount - discount;
        if (finalTotal < 0) finalTotal = 0;

        // 4. LƯU ĐƠN HÀNG VÀO DATABASE (OrderDAO)
        // (Phần này bạn cần có OrderDAO, giả sử hàm createOrder trả về true nếu thành công)
        // boolean orderSuccess = new OrderDAO().createOrder(currentUser.getUid(), finalTotal, address, note);
        boolean orderSuccess = true; // Giả lập là lưu thành công

        if (orderSuccess) {
            // === QUAN TRỌNG: NẾU ĐÃ DÙNG VOUCHER, HÃY XÓA NÓ KHỎI VÍ ===
            if (usedVoucher != null) {
                // Gọi hàm đánh dấu đã dùng hoặc xóa hẳn
                vDao.markVoucherUsed(currentUser.getUid(), usedVoucher.getId());
            }

            // Xóa giỏ hàng sau khi mua thành công
            // cartDao.clearCart(currentUser.getUid());

            // Chuyển hướng đến trang thông báo thành công
            response.sendRedirect("order-success.jsp");
        } else {
            request.setAttribute("error", "Đặt hàng thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}