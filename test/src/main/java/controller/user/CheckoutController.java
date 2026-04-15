package controller.user;

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
import model.CartItem;
import model.User;
import model.Voucher;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("cart");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        CartDAO cartDao = new CartDAO();
        List<CartItem> cart = cartDao.getCartByUid(currentUser.getUid());

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        double totalMoney = 0;
        for (CartItem item : cart) {
            totalMoney += item.getTotalPrice();
        }

        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");
        if (appliedVoucher != null) {
            if ("PERCENT".equals(appliedVoucher.getDiscountType())) {
                totalMoney = totalMoney * (1.0 - (appliedVoucher.getDiscountAmount() / 100.0));
            } else {
                totalMoney = totalMoney - appliedVoucher.getDiscountAmount();
            }
            if (totalMoney < 0) totalMoney = 0;
        }

        String address = request.getParameter("address");
        if (address == null || address.trim().isEmpty()) {
            address = "Dia chi mac dinh";
        }

        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            paymentMethod = "COD";
        }

        OrderDAO orderDao = new OrderDAO();
        int newOrderId = orderDao.createOrder(currentUser.getUid(), totalMoney, address, paymentMethod, cart);

        if (newOrderId > 0) {
            ProductDAO pDao = new ProductDAO();
            VoucherDAO vDao = new VoucherDAO();

            for (CartItem item : cart) {
                pDao.decreaseStock(item.getProduct().getPid(), item.getQuantity());
            }

            if (appliedVoucher != null) {
                vDao.markVoucherUsed(currentUser.getUid(), appliedVoucher.getId());
                session.removeAttribute("appliedVoucher");
                session.removeAttribute("voucherMsg");
            }

            cartDao.clearCart(currentUser.getUid());
            response.sendRedirect("order-success?id=" + newOrderId);
        } else {
            request.setAttribute("error", "Dat hang that bai, vui long thu lai!");
            request.getRequestDispatcher("cart").forward(request, response);
        }
    }
}
