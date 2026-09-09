package controller.user;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import service.VnpayService;

@WebServlet("/vnpay-return")
public class VnpayReturnController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        try {
            Map<String, String> parameters = extractParameters(request);
            VnpayService vnpayService = new VnpayService();
            if (parameters == null || !vnpayService.isValidResponseSignature(parameters)) {
                redirectWithError(response, session, "Không xác thực được kết quả thanh toán VNPay.", 0);
                return;
            }

            int orderId = vnpayService.extractOrderId(parameters.get("vnp_TxnRef"));
            Order order = new OrderDAO().getOrderById(orderId);
            if (order == null || !"VNPAY".equalsIgnoreCase(order.getPaymentMethod())) {
                redirectWithError(response, session, "Không tìm thấy đơn hàng VNPay.", 0);
                return;
            }

            long callbackAmount = parseLong(parameters.get("vnp_Amount"));
            long expectedAmount = Math.multiplyExact(Math.round(order.getTotalMoney()), 100L);
            if (callbackAmount != expectedAmount) {
                redirectWithError(response, session, "Số tiền VNPay trả về không hợp lệ.", orderId);
                return;
            }

            boolean gatewaySuccess = "00".equals(parameters.get("vnp_ResponseCode"))
                    && "00".equals(parameters.get("vnp_TransactionStatus"));
            if (!gatewaySuccess) {
                String responseCode = parameters.getOrDefault("vnp_ResponseCode", "unknown");
                redirectWithError(response, session,
                        "Thanh toán VNPay không thành công (mã " + responseCode + ").", orderId);
                return;
            }

            if (Order.STATUS_PAID_PROCESSING.equals(order.getStatus())) {
                if (session != null) {
                    session.removeAttribute("appliedVoucher");
                    session.removeAttribute("voucherMsg");
                }
                response.sendRedirect("order-success?id=" + orderId);
                return;
            }

            if (session != null) {
                session.setAttribute("voucherMsg",
                        "VNPay đã nhận giao dịch. Đơn hàng đang chờ hệ thống xác nhận thanh toán.");
                session.setAttribute("msgType", "success");
            }
            response.sendRedirect("order-detail?id=" + orderId);
        } catch (Exception e) {
            e.printStackTrace();
            redirectWithError(response, session, "Không thể xử lý kết quả thanh toán VNPay.", 0);
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

    private void redirectWithError(HttpServletResponse response, HttpSession session, String message, int orderId)
            throws IOException {
        if (session != null) {
            session.setAttribute("voucherMsg", message);
            session.setAttribute("msgType", "error");
        }
        response.sendRedirect(orderId > 0 ? "order-detail?id=" + orderId : "cart");
    }
}
