package controller.user;

import java.io.IOException;
import java.util.List;

import org.json.JSONObject;

import dao.CartDAO;
import dao.AddressDAO;
import dao.LoyaltyDAO;
import dao.OrderDAO;
import dao.VoucherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;
import model.Address;
import model.Membership;
import model.Order;
import model.User;
import model.Voucher;
import service.MomoService;
import service.OrderNotificationService;
import service.PricingService;
import service.VnpayService;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final long MOMO_MIN_AMOUNT = 1_000L;
    private static final long MOMO_MAX_AMOUNT = 50_000_000L;
    private static final long VNPAY_MAX_AMOUNT = 9_999_999_999L;

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
        for (CartItem item : cart) {
            int availableStock = item.getProduct() == null ? 0 : item.getProduct().getStockquantyti();
            if (item.getQuantity() <= 0 || item.getQuantity() > availableStock) {
                session.setAttribute("voucherMsg",
                        "Một phân loại trong giỏ đã hết hàng hoặc không đủ số lượng. Vui lòng kiểm tra lại.");
                session.setAttribute("msgType", "error");
                response.sendRedirect("cart");
                return;
            }
        }

        double subtotal = calculateSubtotal(cart);
        Voucher sessionVoucher = (Voucher) session.getAttribute("appliedVoucher");
        Voucher appliedVoucher = null;
        if (sessionVoucher != null) {
            appliedVoucher = new VoucherDAO().getAvailableVoucherForUserById(
                    currentUser.getUid(), sessionVoucher.getId());
            if (appliedVoucher == null) {
                session.removeAttribute("appliedVoucher");
                rejectCheckout(response, session, "Voucher da het han, da su dung hoac khong con trong vi.");
                return;
            }
            if (subtotal < appliedVoucher.getMinOrder()) {
                session.removeAttribute("appliedVoucher");
                rejectCheckout(response, session, "Don hang chua du dieu kien toi thieu cua voucher.");
                return;
            }
            session.setAttribute("appliedVoucher", appliedVoucher);
        }

        Membership membership = new LoyaltyDAO().getMembership(currentUser.getUid());
        PricingService.Quote quote = PricingService.calculate(
                subtotal, appliedVoucher, membership.getDiscountPercent());

        Address deliveryAddress = resolveSelectedAddress(session, currentUser.getUid());
        if (deliveryAddress == null) {
            rejectCheckout(response, session, "Vui long chon dia chi giao hang hop le.");
            return;
        }
        String address = formatAddress(deliveryAddress);
        String contactEmail = normalizeContact(currentUser.getEmail());
        String contactPhone = normalizeContact(deliveryAddress.getPhone());
        if (contactPhone == null) contactPhone = normalizeContact(currentUser.getPhonenumber());
        if (contactEmail == null && contactPhone == null) {
            rejectCheckout(response, session,
                    "Can co email hoac so dien thoai de nhan thong bao don hang. Vui long cap nhat ho so/dia chi.");
            return;
        }

        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.isBlank()) {
            paymentMethod = "COD";
        }

        if ("MOMO".equalsIgnoreCase(paymentMethod)) {
            handleMomoCheckout(request, response, session, currentUser.getUid(), cart, quote, address,
                    contactEmail, contactPhone);
            return;
        }

        if ("VNPAY".equalsIgnoreCase(paymentMethod)) {
            handleVnpayCheckout(request, response, session, currentUser.getUid(), cart, quote, address,
                    contactEmail, contactPhone);
            return;
        }

        handleDirectCheckout(response, session, currentUser, cartDao, cart, quote, address, paymentMethod,
                contactEmail, contactPhone);
    }

    private double calculateSubtotal(List<CartItem> cart) {
        double subtotal = 0;
        for (CartItem item : cart) {
            subtotal += item.getTotalPrice();
        }
        return subtotal;
    }

    private Address resolveSelectedAddress(HttpSession session, int userId) {
        AddressDAO addressDao = new AddressDAO();
        Object rawAddressId = session.getAttribute("selectedAddressId");
        int addressId = parseAddressId(rawAddressId);
        if (addressId > 0) {
            Address selectedAddress = addressDao.getAddressByIdAndUserId(addressId, userId);
            if (selectedAddress != null) {
                rememberSelectedAddress(session, selectedAddress);
                return selectedAddress;
            }
        }

        // Sessions created before selectedAddressId was introduced only contain the
        // formatted address. Resolve it back to an address owned by this user so an
        // already selected address does not unexpectedly block checkout.
        Object legacyAddress = session.getAttribute("selectedAddress");
        if (legacyAddress instanceof String formattedAddress && !formattedAddress.isBlank()) {
            for (Address candidate : addressDao.getAddressesByUserId(userId)) {
                if (formattedAddress.equals(formatAddress(candidate))) {
                    rememberSelectedAddress(session, candidate);
                    return candidate;
                }
            }
        }
        return null;
    }

    private int parseAddressId(Object rawAddressId) {
        if (rawAddressId instanceof Number number) {
            return Math.max(0, number.intValue());
        }
        try {
            return Math.max(0, Integer.parseInt(String.valueOf(rawAddressId)));
        } catch (Exception e) {
            return 0;
        }
    }

    private void rememberSelectedAddress(HttpSession session, Address address) {
        session.setAttribute("selectedAddressId", address.getId());
        session.setAttribute("selectedAddress", formatAddress(address));
        session.setAttribute("selectedContactPhone", address.getPhone());
    }

    private String formatAddress(Address address) {
        return address.getReceiverName() + " - " + address.getPhone() + " - "
                + address.getSpecificAddress() + ", " + address.getWard() + ", "
                + address.getDistrict() + ", " + address.getCity();
    }

    private String normalizeContact(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }

    private void rejectCheckout(HttpServletResponse response, HttpSession session, String message) throws IOException {
        session.setAttribute("voucherMsg", message);
        session.setAttribute("msgType", "error");
        response.sendRedirect("cart");
    }

    private void handleDirectCheckout(HttpServletResponse response, HttpSession session, User currentUser, CartDAO cartDao,
            List<CartItem> cart, PricingService.Quote quote, String address, String paymentMethod,
            String contactEmail, String contactPhone) throws IOException {
        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");
        OrderDAO orderDao = new OrderDAO();
        int newOrderId = orderDao.createOrderAndDecreaseStock(
                currentUser.getUid(), quote.getFinalTotal(), address, paymentMethod, cart,
                contactEmail, contactPhone, quote.getMemberDiscountPercent());

        if (newOrderId <= 0) {
            session.setAttribute("voucherMsg", "Dat hang that bai, vui long thu lai.");
            session.setAttribute("msgType", "error");
            response.sendRedirect("cart");
            return;
        }

        VoucherDAO vDao = new VoucherDAO();

        if (appliedVoucher != null) {
            vDao.markVoucherUsed(currentUser.getUid(), appliedVoucher.getId());
            session.removeAttribute("appliedVoucher");
            session.removeAttribute("voucherMsg");
        }

        cartDao.clearCart(currentUser.getUid());
        new OrderNotificationService().notifyOrderPlaced(orderDao.getOrderById(newOrderId));
        response.sendRedirect("order-success?id=" + newOrderId);
    }

    private void handleMomoCheckout(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            int userId, List<CartItem> cart, PricingService.Quote quote, String address,
            String contactEmail, String contactPhone) throws IOException {
        long momoAmount = Math.round(quote.getFinalTotal());
        if (momoAmount < MOMO_MIN_AMOUNT || momoAmount > MOMO_MAX_AMOUNT) {
            session.setAttribute("voucherMsg",
                    "So tien thanh toan MoMo phai tu 1.000 den 50.000.000 VND.");
            session.setAttribute("msgType", "error");
            response.sendRedirect("cart");
            return;
        }

        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");
        OrderDAO orderDao = new OrderDAO();
        int newOrderId = orderDao.createOrder(userId, quote.getFinalTotal(), address, "MOMO",
                Order.STATUS_PENDING_MOMO, cart, contactEmail, contactPhone, quote.getMemberDiscountPercent());

        if (newOrderId <= 0) {
            session.setAttribute("voucherMsg", "Khong the tao don hang cho thanh toan MoMo.");
            session.setAttribute("msgType", "error");
            response.sendRedirect("cart");
            return;
        }

        new OrderNotificationService().notifyOrderPlaced(orderDao.getOrderById(newOrderId));

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
            new OrderNotificationService().notifyStatusChanged(orderDao.getOrderById(newOrderId), null);
            session.setAttribute("voucherMsg", "Khong the khoi tao thanh toan MoMo. Vui long thu lai.");
            session.setAttribute("msgType", "error");
            response.sendRedirect("cart");
        }
    }

    private void handleVnpayCheckout(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            int userId, List<CartItem> cart, PricingService.Quote quote, String address,
            String contactEmail, String contactPhone) throws IOException {
        long vnpayAmount = Math.round(quote.getFinalTotal());
        if (vnpayAmount <= 0 || vnpayAmount > VNPAY_MAX_AMOUNT) {
            session.setAttribute("voucherMsg", "Số tiền thanh toán VNPay không hợp lệ.");
            session.setAttribute("msgType", "error");
            response.sendRedirect("cart");
            return;
        }

        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");
        VnpayService vnpayService;
        try {
            vnpayService = new VnpayService();
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("voucherMsg", "VNPay chưa được cấu hình đầy đủ trên máy chủ.");
            session.setAttribute("msgType", "error");
            response.sendRedirect("cart");
            return;
        }

        OrderDAO orderDao = new OrderDAO();
        int newOrderId = orderDao.createOrder(userId, quote.getFinalTotal(), address, "VNPAY",
                Order.STATUS_PENDING_VNPAY, cart, contactEmail, contactPhone, quote.getMemberDiscountPercent());

        if (newOrderId <= 0) {
            session.setAttribute("voucherMsg", "Không thể tạo đơn hàng chờ thanh toán VNPay.");
            session.setAttribute("msgType", "error");
            response.sendRedirect("cart");
            return;
        }

        new OrderNotificationService().notifyOrderPlaced(orderDao.getOrderById(newOrderId));

        try {
            int voucherId = appliedVoucher == null ? 0 : appliedVoucher.getId();
            String transactionReference = vnpayService.createTransactionReference(newOrderId, voucherId);
            String fallbackReturnUrl = buildBaseUrl(request) + "/vnpay-return";
            String locale = (String) session.getAttribute("lang");
            String paymentUrl = vnpayService.createPaymentUrl(
                    vnpayAmount,
                    transactionReference,
                    "Thanh toan don hang " + newOrderId,
                    fallbackReturnUrl,
                    getClientIp(request),
                    locale);

            response.sendRedirect(paymentUrl);
        } catch (Exception e) {
            e.printStackTrace();
            orderDao.updateOrderStatus(newOrderId, Order.STATUS_VNPAY_FAILED);
            new OrderNotificationService().notifyStatusChanged(orderDao.getOrderById(newOrderId), null);
            session.setAttribute("voucherMsg", "Không thể khởi tạo thanh toán VNPay. Vui lòng thử lại.");
            session.setAttribute("msgType", "error");
            response.sendRedirect("cart");
        }
    }

    private String buildBaseUrl(HttpServletRequest request) {
        String scheme = getForwardedScheme(request);
        StringBuilder baseUrl = new StringBuilder();
        baseUrl.append(scheme).append("://").append(request.getServerName());

        int serverPort = request.getServerPort();
        boolean defaultPort = ("http".equalsIgnoreCase(scheme) && serverPort == 80)
                || ("https".equalsIgnoreCase(scheme) && (serverPort == 80 || serverPort == 443));

        if (!defaultPort) {
            baseUrl.append(":").append(serverPort);
        }

        baseUrl.append(request.getContextPath());
        return baseUrl.toString();
    }

    private String getForwardedScheme(HttpServletRequest request) {
        String forwardedProto = request.getHeader("X-Forwarded-Proto");
        if (forwardedProto != null && !forwardedProto.isBlank()) {
            String firstValue = forwardedProto.split(",", 2)[0].trim();
            if ("http".equalsIgnoreCase(firstValue) || "https".equalsIgnoreCase(firstValue)) {
                return firstValue.toLowerCase(java.util.Locale.ROOT);
            }
        }
        return request.getScheme();
    }

    private String buildMomoOrderId(int internalOrderId) {
        return "FS" + internalOrderId + "_" + System.currentTimeMillis();
    }

    private String getClientIp(HttpServletRequest request) {
        String forwardedFor = request.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.isBlank()) {
            return forwardedFor;
        }
        String realIp = request.getHeader("X-Real-IP");
        return realIp == null || realIp.isBlank() ? request.getRemoteAddr() : realIp;
    }
}
