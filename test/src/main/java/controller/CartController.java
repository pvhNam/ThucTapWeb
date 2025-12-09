package controller;

import java.io.IOException;
import java.util.ArrayList;
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
import model.product;
import model.user;
import model.Voucher;

@WebServlet("/cart")
public class CartController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // --- GET: HIỂN THỊ GIỎ HÀNG & TÍNH TIỀN ---
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");
        List<cartItem> cart = new ArrayList<>();
        int walletCount = 0; 

        // 1. LẤY GIỎ HÀNG
        if (currentUser != null) {
            CartDAO dao = new CartDAO();
            cart = dao.getCartByUid(currentUser.getUid());
            
            // Đếm voucher trong ví
            VoucherDAO vDao = new VoucherDAO();
            List<Voucher> myVouchers = vDao.getVouchersByUid(currentUser.getUid());
            walletCount = myVouchers.size();
        } else {
            cart = (List<cartItem>) session.getAttribute("cart");
            if (cart == null) cart = new ArrayList<>();
        }

        // 2. TÍNH TỔNG TIỀN HÀNG (Subtotal)
        double subtotal = 0;
        for (cartItem item : cart) {
            subtotal += item.getTotalPrice();
        }

        // 3. TÍNH GIẢM GIÁ (Discount)
        double discountAmount = 0;
        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");
        String voucherError = null; // Biến lưu lỗi voucher nếu có
        
        if (appliedVoucher != null) {
            // Kiểm tra: Nếu giỏ hàng trống thì bỏ voucher
            if(cart.isEmpty()) {
                session.removeAttribute("appliedVoucher");
            } 
            // Kiểm tra: Đơn hàng có đủ mức tối thiểu không
            else if (subtotal < appliedVoucher.getMinOrder()) {
                // Không đủ điều kiện -> Hủy mã tạm thời (không xóa khỏi session nhưng không tính tiền)
                // Hoặc xóa hẳn khỏi session tùy logic bạn muốn. Ở đây tôi sẽ xóa và báo lỗi.
                session.removeAttribute("appliedVoucher");
                voucherError = "Mã " + appliedVoucher.getCode() + " cần đơn tối thiểu " + (long)appliedVoucher.getMinOrder() + "đ";
            } 
            else {
                // Đủ điều kiện -> Tính tiền
                if ("PERCENT".equals(appliedVoucher.getDiscountType())) {
                    discountAmount = subtotal * (appliedVoucher.getDiscountAmount() / 100.0);
                } else {
                    discountAmount = appliedVoucher.getDiscountAmount();
                }
            }
        }
        
        // Không cho phép giảm quá tổng tiền
        if (discountAmount > subtotal) discountAmount = subtotal;
        double finalTotal = subtotal - discountAmount;

        // 4. ĐẨY DỮ LIỆU RA VIEW
        request.setAttribute("cartList", cart);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("finalTotal", finalTotal);
        request.setAttribute("totalCount", cart.size());
        request.setAttribute("walletCount", walletCount);
        if(voucherError != null) request.setAttribute("voucherError", voucherError);
        
        request.getRequestDispatcher("cartitem.jsp").forward(request, response);
    }

    // --- POST: XỬ LÝ HÀNH ĐỘNG ---
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");
        String action = request.getParameter("action");
        
        // === 1. XỬ LÝ ÁP DỤNG MÃ ===
        if ("apply_voucher".equals(action)) {
            String code = request.getParameter("voucherCode");
            if(code != null) code = code.trim().toUpperCase();

            VoucherDAO vDao = new VoucherDAO();
            Voucher v = vDao.getVoucherByCode(code);
            
            // Logic kiểm tra:
            // 1. Mã có tồn tại không?
            // 2. Nếu đăng nhập: User có sở hữu mã này trong ví không?
            // 3. (Tùy chọn) Nếu chưa đăng nhập: Có cho dùng mã chung không? (Ở đây bắt buộc đăng nhập để check ví)
            
            if (currentUser == null) {
                // Nếu chưa đăng nhập -> Chuyển hướng login
                response.sendRedirect("login.jsp");
                return;
            }

            if (v != null) {
                // Kiểm tra trong ví user có mã này không
                boolean hasVoucher = vDao.checkUserHasVoucher(currentUser.getUid(), v.getId());
                
                if (hasVoucher) {
                    session.setAttribute("appliedVoucher", v);
                } else {
                    session.removeAttribute("appliedVoucher");
                    session.setAttribute("flashMsg", "Bạn chưa lưu mã này trong ví hoặc mã đã dùng!");
                }
            } else {
                session.removeAttribute("appliedVoucher");
                session.setAttribute("flashMsg", "Mã giảm giá không tồn tại!");
            }
            response.sendRedirect("cart");
            return;
        }
        
        // === 2. XỬ LÝ HỦY MÃ ===
        if ("remove_voucher".equals(action)) {
            session.removeAttribute("appliedVoucher");
            response.sendRedirect("cart");
            return;
        }

        // === 3. CÁC CHỨC NĂNG GIỎ HÀNG CŨ (ADD/REMOVE/UPDATE) ===
        // (Giữ nguyên logic cũ của bạn để không ảnh hưởng chức năng thêm hàng)
        int pid = 0;
        try {
            if(request.getParameter("pid") != null)
                pid = Integer.parseInt(request.getParameter("pid"));
        } catch (Exception e) {}

        if (currentUser != null) {
            CartDAO dao = new CartDAO();
            int uid = currentUser.getUid();
            if ("add".equals(action)) {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                dao.addToCart(uid, pid, quantity);
            } else if ("remove".equals(action)) {
                dao.removeItem(uid, pid);
            } else if ("update".equals(action)) {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                if (quantity > 0) dao.updateQuantity(uid, pid, quantity);
                else dao.removeItem(uid, pid);
            }
        } else {
            List<cartItem> cart = (List<cartItem>) session.getAttribute("cart");
            if (cart == null) cart = new ArrayList<>();
            // ... Logic session cart cũ ...
            if ("add".equals(action)) {
                 int quantity = Integer.parseInt(request.getParameter("quantity"));
                 boolean exist = false;
                 for(cartItem item : cart) {
                     if(item.getProduct().getPid() == pid) {
                         item.setQuantity(item.getQuantity() + quantity);
                         exist = true; break;
                     }
                 }
                 if(!exist) {
                      ProductDAO pDao = new ProductDAO();
                      product p = pDao.getProductById(pid);
                      if(p!=null) cart.add(new cartItem(p, quantity));
                 }
            } else if ("remove".equals(action)) {
                 for(int i=0; i<cart.size(); i++) {
                     if(cart.get(i).getProduct().getPid() == pid) { cart.remove(i); break; }
                 }
            } else if ("update".equals(action)) {
                 int quantity = Integer.parseInt(request.getParameter("quantity"));
                 for(cartItem item : cart) {
                     if(item.getProduct().getPid() == pid) {
                         if(quantity > 0) item.setQuantity(quantity);
                         else cart.remove(item);
                         break;
                     }
                 }
            }
            session.setAttribute("cart", cart);
        }
        response.sendRedirect("cart");
    }
}