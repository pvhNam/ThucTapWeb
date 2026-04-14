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

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("remove".equals(action)) {
            if (currentUser == null) {
                response.sendRedirect("login");
                return;
            }
            int pid = 0;
            try { pid = Integer.parseInt(request.getParameter("pid")); } catch (Exception e) {}

            if (currentUser != null) {
                CartDAO dao = new CartDAO();
                dao.removeItem(currentUser.getUid(), pid);
            } else {
                List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
                if (cart != null) {
                    Iterator<CartItem> iterator = cart.iterator();
                    while (iterator.hasNext()) {
                        CartItem item = iterator.next();
                        if (item.getProduct().getPid() == pid) {
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
        for (CartItem item : cart) {
            subtotal += item.getTotalPrice();
        }

        double discountAmount = 0;
        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");

        if (appliedVoucher != null) {
            if (cart.isEmpty()) {
                session.removeAttribute("appliedVoucher");
                session.removeAttribute("voucherMsg");
            } else if (subtotal < appliedVoucher.getMinOrder()) {
                session.removeAttribute("appliedVoucher");
                session.setAttribute("voucherMsg", "Ma " + appliedVoucher.getCode() + " da bi huy do don hang chua du "
                        + (long) appliedVoucher.getMinOrder() + "d");
                session.setAttribute("msgType", "error");
            } else {
                if ("PERCENT".equals(appliedVoucher.getDiscountType())) {
                    discountAmount = subtotal * (appliedVoucher.getDiscountAmount() / 100.0);
                } else {
                    discountAmount = appliedVoucher.getDiscountAmount();
                }
            }
        }

        if (discountAmount > subtotal) discountAmount = subtotal;
        double finalTotal = subtotal - discountAmount;

        request.setAttribute("cartList", cart);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("finalTotal", finalTotal);
        request.setAttribute("totalCount", cart.size());
        request.setAttribute("myVouchers", myVouchers);
        request.setAttribute("walletCount", myVouchers.size());

        request.getRequestDispatcher("/cartitem.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

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
        try {
            if (request.getParameter("pid") != null)
                pid = Integer.parseInt(request.getParameter("pid"));
        } catch (Exception e) { e.printStackTrace(); }

        ProductDAO productDAO = new ProductDAO();

        if (currentUser != null) {
            CartDAO dao = new CartDAO();
            int uid = currentUser.getUid();

            if ("add".equals(action)) {
                String qParam = request.getParameter("quantity");
                int quantity = 1;
                if (qParam != null && !qParam.isEmpty()) {
                    quantity = Integer.parseInt(qParam);
                }
                Product p = productDAO.getProductById(pid);
                if (p != null && quantity > p.getStockquantyti()) {
                    session.setAttribute("voucherMsg", "Khong the them! Kho chi con " + p.getStockquantyti() + " san pham.");
                    session.setAttribute("msgType", "error");
                    response.sendRedirect("cart");
                    return;
                }
                dao.addToCart(uid, pid, quantity);

            } else if ("update_quantity".equals(action)) {
                int currentQty = 1;
                try { currentQty = Integer.parseInt(request.getParameter("quantity")); } catch (Exception e) {}

                String mod = request.getParameter("mod");
                int newQty = currentQty;

                if ("increase".equals(mod)) newQty++;
                else if ("decrease".equals(mod)) newQty--;

                Product p = productDAO.getProductById(pid);
                if (p != null && newQty > p.getStockquantyti()) {
                    session.setAttribute("voucherMsg", "So luong toi da la " + p.getStockquantyti());
                    session.setAttribute("msgType", "error");
                    newQty = p.getStockquantyti();
                }

                if (newQty > 0) {
                    dao.updateQuantity(uid, pid, newQty);
                } else {
                    dao.removeItem(uid, pid);
                }
            }
        } else {
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        response.sendRedirect("cart");
    }
}
