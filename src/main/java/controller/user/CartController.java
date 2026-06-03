package controller.user;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
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
import model.CartItem;
import model.Product;
import model.User;
import model.Voucher;

@WebServlet("/cart")
public class CartController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("remove".equals(action)) {
            int pid = 0;
            try { pid = Integer.parseInt(request.getParameter("pid")); } catch (Exception e) {}
            String color = request.getParameter("color");
            String size = request.getParameter("size");

            if (currentUser != null) {
                CartDAO dao = new CartDAO();
                dao.removeItem(currentUser.getUid(), pid, color, size);
            } else {
                List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
                if (cart != null) {
                    Iterator<CartItem> iterator = cart.iterator();
                    while (iterator.hasNext()) {
                        CartItem item = iterator.next();
                        boolean matchColor = (color == null && item.getColor() == null) || (color != null && color.equals(item.getColor()));
                        boolean matchSize = (size == null && item.getSize() == null) || (size != null && size.equals(item.getSize()));

                        if (item.getProduct().getPid() == pid && matchColor && matchSize) {
                            iterator.remove();
                            break;
                        }
                    }
                    session.setAttribute("cart", cart);
                }
            }
            response.sendRedirect("cart");
            return;
        }

        List<CartItem> cart = new ArrayList<>();
        List<Voucher> myVouchers = new ArrayList<>();

        if (currentUser != null) {
            CartDAO dao = new CartDAO();
            cart = dao.getCartByUid(currentUser.getUid());
            VoucherDAO vDao = new VoucherDAO();
            myVouchers = vDao.getVouchersByUid(currentUser.getUid());
        } else {
            cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) cart = new ArrayList<>();
        }

        double subtotal = 0;
        for (CartItem item : cart) subtotal += item.getTotalPrice();

        double discountAmount = 0;
        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");

        // ... (Giữ nguyên logic tính Voucher cũ của bạn) ...
        if (appliedVoucher != null) {
            if (cart.isEmpty()) {
                session.removeAttribute("appliedVoucher");
                session.removeAttribute("voucherMsg");
            } else if (subtotal < appliedVoucher.getMinOrder()) {
                session.removeAttribute("appliedVoucher");
                session.setAttribute("voucherMsg", "Ma " + appliedVoucher.getCode() + " da bi huy do don hang chua du " + (long) appliedVoucher.getMinOrder() + "d");
                session.setAttribute("msgType", "error");
            } else {
                if ("PERCENT".equals(appliedVoucher.getDiscountType())) discountAmount = subtotal * (appliedVoucher.getDiscountAmount() / 100.0);
                else discountAmount = appliedVoucher.getDiscountAmount();
            }
        }
        if (discountAmount > subtotal) discountAmount = subtotal;

        request.setAttribute("cartList", cart);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("finalTotal", subtotal - discountAmount);
        request.setAttribute("totalCount", cart.size());
        request.setAttribute("myVouchers", myVouchers);
        request.setAttribute("walletCount", myVouchers.size());

        request.getRequestDispatcher("/cartitem.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("apply_voucher".equals(action)) {
            String code = request.getParameter("voucherCode");
            if (code != null) code = code.trim().toUpperCase();

            VoucherDAO vDao = new VoucherDAO();
            Voucher v = vDao.getVoucherByCode(code);

            if (v == null) {
                session.setAttribute("voucherMsg", "Ma giam gia khong ton tai!");
                session.setAttribute("msgType", "error");
                session.removeAttribute("appliedVoucher");
            } else {
                boolean hasVoucher = vDao.checkUserHasVoucher(currentUser.getUid(), v.getId());
                if (hasVoucher) {
                    session.setAttribute("appliedVoucher", v);
                    session.setAttribute("voucherMsg", "Ap dung ma " + code + " thanh cong!");
                    session.setAttribute("msgType", "success");
                } else {
                    session.setAttribute("voucherMsg", "Ban chua luu ma nay trong vi! Hay luu truoc khi dung.");
                    session.setAttribute("msgType", "error");
                    session.removeAttribute("appliedVoucher");
                }
            }
            response.sendRedirect("cart");
            return;
        }

        if ("remove_voucher".equals(action)) {
            session.removeAttribute("appliedVoucher");
            session.setAttribute("voucherMsg", "Da go bo ma giam gia.");
            session.setAttribute("msgType", "info");
            response.sendRedirect("cart");
            return;
        }
        int pid = 0;
        try { if (request.getParameter("pid") != null) pid = Integer.parseInt(request.getParameter("pid")); } catch (Exception e) {}

        String color = request.getParameter("color");
        String size = request.getParameter("size");
        if(color == null) color = "";
        if(size == null) size = "";

        ProductDAO productDAO = new ProductDAO();

        if (currentUser != null) {
            CartDAO dao = new CartDAO();
            int uid = currentUser.getUid();

            if ("add".equals(action) || "buyNow".equals(action)) {
                String qParam = request.getParameter("quantity");
                int quantity = (qParam != null && !qParam.isEmpty()) ? Integer.parseInt(qParam) : 1;

                // Lưu vào DB kèm theo Màu và Size
                dao.addToCart(uid, pid, color, size, quantity);

                if ("buyNow".equals(action)) response.sendRedirect("checkout");
                else response.sendRedirect("cart"); // Thêm xong chuyển ra giỏ hàng
                return;

            } else if ("update_quantity".equals(action)) {
                int currentQty = 1;
                try { currentQty = Integer.parseInt(request.getParameter("quantity")); } catch (Exception e) {}
                String mod = request.getParameter("mod");
                int newQty = currentQty;
                if ("increase".equals(mod)) newQty++;
                else if ("decrease".equals(mod)) newQty--;

                if (newQty > 0) dao.updateQuantity(uid, pid, color, size, newQty);
                else dao.removeItem(uid, pid, color, size);
            }
        } else {
            // Dành cho khách chưa Login (Lưu vào session)
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) cart = new ArrayList<>();

            if ("add".equals(action) || "buyNow".equals(action)) {
                int quantity = Integer.parseInt(request.getParameter("quantity") != null ? request.getParameter("quantity") : "1");
                Product p = productDAO.getProductById(pid);
                boolean exists = false;
                for (CartItem item : cart) {
                    if (item.getProduct().getPid() == pid && item.getColor().equals(color) && item.getSize().equals(size)) {
                        item.setQuantity(item.getQuantity() + quantity);
                        exists = true; break;
                    }
                }
                if (!exists) cart.add(new CartItem(p, quantity, color, size));
                session.setAttribute("cart", cart);
                if ("buyNow".equals(action)) { response.sendRedirect("checkout"); return; }
            }
        }
        response.sendRedirect("cart");
    }
}