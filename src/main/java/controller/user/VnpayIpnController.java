package controller.user;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import org.json.JSONObject;

import dao.CartDAO;
import dao.OrderDAO;
import dao.VoucherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;
import service.VnpayService;
import service.OrderNotificationService;

@WebServlet("/vnpay-ipn")
public class VnpayIpnController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        IpnResult result = processIpn(request);
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new JSONObject()
                .put("RspCode", result.responseCode)
                .put("Message", result.message)
                .toString());
    }

    private IpnResult processIpn(HttpServletRequest request) {
        try {
            Map<String, String> parameters = extractParameters(request);
            if (parameters == null) {
                return new IpnResult("97", "Invalid Checksum");
            }

            VnpayService vnpayService = new VnpayService();
            if (!vnpayService.isValidResponseSignature(parameters)) {
                return new IpnResult("97", "Invalid Checksum");
            }

            String transactionReference = parameters.get("vnp_TxnRef");
            int orderId = vnpayService.extractOrderId(transactionReference);
            if (orderId <= 0) {
                return new IpnResult("01", "Order not Found");
            }

            OrderDAO orderDao = new OrderDAO();
            Order order = orderDao.getOrderById(orderId);
            if (order == null || !"VNPAY".equalsIgnoreCase(order.getPaymentMethod())) {
                return new IpnResult("01", "Order not Found");
            }

            long callbackAmount = parseLong(parameters.get("vnp_Amount"));
            long expectedAmount = Math.multiplyExact(Math.round(order.getTotalMoney()), 100L);
            if (callbackAmount != expectedAmount) {
                return new IpnResult("04", "Invalid Amount");
            }

            if (!Order.STATUS_PENDING_VNPAY.equals(order.getStatus())) {
                return new IpnResult("02", "Order already confirmed");
            }

            boolean paymentSucceeded = "00".equals(parameters.get("vnp_ResponseCode"))
                    && "00".equals(parameters.get("vnp_TransactionStatus"));
            if (paymentSucceeded) {
                if (!orderDao.finalizeVnpayPayment(orderId)) {
                    return new IpnResult("99", "Unable to confirm order");
                }
                cleanupSuccessfulPayment(order, vnpayService.extractVoucherId(transactionReference));
                new OrderNotificationService().notifyStatusChanged(orderDao.getOrderById(orderId), null);
                return new IpnResult("00", "Confirm Success");
            }

            boolean updated = orderDao.updateOrderStatusIfCurrent(
                    orderId, Order.STATUS_PENDING_VNPAY, Order.STATUS_VNPAY_FAILED);
            if (updated) {
                new OrderNotificationService().notifyStatusChanged(orderDao.getOrderById(orderId), null);
            }
            return updated
                    ? new IpnResult("00", "Confirm Success")
                    : new IpnResult("02", "Order already confirmed");
        } catch (Exception e) {
            e.printStackTrace();
            return new IpnResult("99", "Unknown error");
        }
    }

    private Map<String, String> extractParameters(HttpServletRequest request) {
        Map<String, String> parameters = new LinkedHashMap<>();
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            if (!entry.getKey().startsWith("vnp_")) {
                continue;
            }
            String[] values = entry.getValue();
            if (values == null || values.length != 1) {
                return null;
            }
            parameters.put(entry.getKey(), values[0]);
        }
        return parameters;
    }

    private long parseLong(String value) {
        try {
            return Long.parseLong(value);
        } catch (Exception e) {
            return -1L;
        }
    }

    private void cleanupSuccessfulPayment(Order order, int voucherId) {
        new CartDAO().clearCart(order.getUserId());
        if (voucherId > 0) {
            new VoucherDAO().markVoucherUsed(order.getUserId(), voucherId);
        }
    }

    private static class IpnResult {
        private final String responseCode;
        private final String message;

        private IpnResult(String responseCode, String message) {
            this.responseCode = responseCode;
            this.message = message;
        }
    }
}
