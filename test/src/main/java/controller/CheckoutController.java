package controller;

import java.io.IOException;
import java.util.List;

import dao.CartDAO;
import dao.ProductDAO;
import dao.VoucherDAO;
import dao.OrderDAO; 
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

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Truy cập trực tiếp link checkout thì đẩy về giỏ hàng
        response.sendRedirect("cart");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Lấy giỏ hàng
        CartDAO cartDao = new CartDAO();
        List<cartItem> cart = cartDao.getCartByUid(currentUser.getUid());

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        // 3. Tính tổng tiền
        double totalMoney = 0;
        for (cartItem item : cart) {
            totalMoney += item.getTotalPrice();
        }

        // 4. Áp dụng Voucher (nếu có)
        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");
        if (appliedVoucher != null) {
            if ("PERCENT".equals(appliedVoucher.getDiscountType())) {
                totalMoney = totalMoney * (1.0 - (appliedVoucher.getDiscountAmount() / 100.0));
            } else {
                totalMoney = totalMoney - appliedVoucher.getDiscountAmount();
            }
            
            // Đảm bảo không bị âm
            if (totalMoney < 0) totalMoney = 0;
        }

        // 5. Lấy địa chỉ giao hàng
        String address = request.getParameter("address");
        if (address == null || address.trim().isEmpty()) {
            address = "Địa chỉ mặc định"; 
        }

        // --- [MỚI] 6. Lấy Hình thức thanh toán từ Form ---
        String paymentMethod = request.getParameter("paymentMethod");
        // Mặc định là COD nếu không chọn hoặc lỗi
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            paymentMethod = "COD"; 
        }

        // 7. Lưu Đơn Hàng vào Database
        OrderDAO orderDao = new OrderDAO();
        // Gọi hàm createOrder mới đã cập nhật ở bước trước (thêm tham số paymentMethod)
        int newOrderId = orderDao.createOrder(currentUser.getUid(), totalMoney, address, paymentMethod, cart);

        if (newOrderId > 0) {
            // 8. Nếu tạo đơn thành công -> Trừ kho, Xóa voucher, Xóa giỏ
            ProductDAO pDao = new ProductDAO();
            VoucherDAO vDao = new VoucherDAO();

            for (cartItem item : cart) {
                // Trừ số lượng tồn kho
                pDao.decreaseStock(item.getProduct().getPid(), item.getQuantity());
            }

            // Đánh dấu Voucher đã dùng (nếu có)
            if (appliedVoucher != null) {
                vDao.markVoucherUsed(currentUser.getUid(), appliedVoucher.getId());
                session.removeAttribute("appliedVoucher");
                session.removeAttribute("voucherMsg");
            }

            // Xóa sạch giỏ hàng
            cartDao.clearCart(currentUser.getUid());

            // Chuyển hướng đến trang thành công
            response.sendRedirect("order-success.jsp?id=" + newOrderId);
        } else {
            // Trường hợp lỗi database
            request.setAttribute("error", "Đặt hàng thất bại, vui lòng thử lại!");
            request.getRequestDispatcher("cart").forward(request, response);
        }
    }
}