package controller.user;

import java.io.IOException;
import java.util.List;

import org.json.JSONObject;

import dao.CartDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import dao.VoucherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;
import model.Order;
import model.User;
import model.Voucher;
import service.MomoService;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final long MOMO_MIN_AMOUNT = 1_000L;
    private static final long MOMO_MAX_AMOUNT = 50_000_000L;

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

        double totalMoney = calculateTotal(cart, (Voucher) session.getAttribute("appliedVoucher"));
        String address = request.getParameter("address");
        if (address == null || address.trim().isEmpty()) {
            address = "Dia chi mac dinh";
        }

        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.isBlank()) {
            paymentMethod = "COD";
        }

        if ("MOMO".equalsIgnoreCase(paymentMethod)) {
            handleMomoCheckout(request, response, session, currentUser.getUid(), cart, totalMoney, address);
            return;
        }

        handleDirectCheckout(response, session, currentUser, cartDao, cart, totalMoney, address, paymentMethod);
    }

    private double calculateTotal(List<CartItem> cart, Voucher appliedVoucher) {
        double totalMoney = 0;
        for (CartItem item : cart) {
            totalMoney += item.getTotalPrice();
        }

        if (appliedVoucher != null) {
            if ("PERCENT".equals(appliedVoucher.getDiscountType())) {
                totalMoney = totalMoney * (1.0 - (appliedVoucher.getDiscountAmount() / 100.0));
            } else {
                totalMoney = totalMoney - appliedVoucher.getDiscountAmount();
            }
        }

        if (totalMoney < 0) {
            totalMoney = 0;
        }
        return totalMoney;
    }

    private void handleDirectCheckout(HttpServletResponse response, HttpSession session, User currentUser, CartDAO cartDao,
            List<CartItem> cart, double totalMoney, String address, String paymentMethod) throws IOException {
        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");
        OrderDAO orderDao = new OrderDAO();
        int newOrderId = orderDao.createOrder(currentUser.getUid(), totalMoney, address, paymentMethod, cart);

        if (newOrderId <= 0) {
            session.setAttribute("voucherMsg", "Dat hang that bai, vui long thu lai.");
            session.setAttribute("msgType", "error");
            response.sendRedirect("cart");
            return;
        }

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
    }

    private void handleMomoCheckout(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            int userId, List<CartItem> cart, double totalMoney, String address) throws IOException {
        long momoAmount = Math.round(totalMoney);
        if (momoAmount < MOMO_MIN_AMOUNT || momoAmount > MOMO_MAX_AMOUNT) {
            session.setAttribute("voucherMsg",
                    "So tien thanh toan MoMo phai tu 1.000 den 50.000.000 VND.");
            session.setAttribute("msgType", "error");
            response.sendRedirect("cart");
            return;
        }

        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");
        OrderDAO orderDao = new OrderDAO();
        int newOrderId = orderDao.createOrder(userId, totalMoney, address, "MOMO",
                Order.STATUS_PENDING_MOMO, cart);

        if (newOrderId <= 0) {
            session.setAttribute("voucherMsg", "Khong the tao don hang cho thanh toan MoMo.");
            session.setAttribute("msgType", "error");
            response.sendRedirect("cart");
            return;
        }

        try {
            MomoService momoService = new MomoService();
            JSONObject extraData = new JSONObject();
            extraData.put("internalOrderId", newOrderId);
            extraData.put("voucherId", appliedVoucher != null ? appliedVoucher.getId() : 0);

            String callbackUrl = buildBaseUrl(request) + "/momo-callback";
            String orderInfo = "Thanh toan don hang #" + newOrderId;
            String momoOrderId = buildMomoOrderId(newOrderId);
            String payUrl = momoService.createPayment(
                    momoAmount,
                    momoOrderId,
                    orderInfo,
                    callbackUrl,
                    callbackUrl,
                    momoService.encodeExtraData(extraData));

            response.sendRedirect(payUrl);
        } catch (Exception e) {
            e.printStackTrace();
            orderDao.updateOrderStatus(newOrderId, Order.STATUS_MOMO_FAILED);
            session.setAttribute("voucherMsg", "Khong the khoi tao thanh toan MoMo. Vui long thu lai.");
            session.setAttribute("msgType", "error");
            response.sendRedirect("cart");
        }
    }

    private String buildBaseUrl(HttpServletRequest request) {
        StringBuilder baseUrl = new StringBuilder();
        baseUrl.append(request.getScheme()).append("://").append(request.getServerName());

        int serverPort = request.getServerPort();
        boolean defaultPort = ("http".equalsIgnoreCase(request.getScheme()) && serverPort == 80)
                || ("https".equalsIgnoreCase(request.getScheme()) && serverPort == 443);

        if (!defaultPort) {
            baseUrl.append(":").append(serverPort);
        }

        baseUrl.append(request.getContextPath());
        return baseUrl.toString();
    }

    private String buildMomoOrderId(int internalOrderId) {
        return "FS" + internalOrderId + "_" + System.currentTimeMillis();
    }
}
