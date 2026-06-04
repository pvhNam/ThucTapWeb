package controller.user;

import java.io.IOException;

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
import model.Order;
import model.OrderDetail;
import service.MomoService;

@WebServlet("/momo-callback")
public class MomoCallbackController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CallbackResult result = handleCallback(request);
        HttpSession session = request.getSession(false);

        if (!result.valid) {
            if (session != null) {
                session.setAttribute("voucherMsg", "Khong xac thuc duoc ket qua thanh toan MoMo.");
                session.setAttribute("msgType", "error");
            }
            response.sendRedirect("cart");
            return;
        }

        if (result.success) {
            if (session != null) {
                session.removeAttribute("appliedVoucher");
                session.removeAttribute("voucherMsg");
            }
            response.sendRedirect("order-success?id=" + result.orderId);
            return;
        }

        if (session != null) {
            session.setAttribute("voucherMsg", "Thanh toan MoMo khong thanh cong. Don hang da duoc cap nhat.");
            session.setAttribute("msgType", "error");
        }

        if (result.orderId > 0) {
            response.sendRedirect("order-detail?id=" + result.orderId);
        } else {
            response.sendRedirect("cart");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CallbackResult result = handleCallback(request);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (!result.valid) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"message\":\"invalid callback\"}");
            return;
        }

        response.setStatus(HttpServletResponse.SC_NO_CONTENT);
    }

    private CallbackResult handleCallback(HttpServletRequest request) {
        CallbackResult result = new CallbackResult();

        try {
            JSONObject payload = readPayload(request);
            MomoService momoService = new MomoService();

            if (!momoService.isValidCallbackSignature(payload)) {
                return result;
            }

            JSONObject extraData = momoService.decodeExtraData(payload.optString("extraData", ""));
            int orderId = resolveInternalOrderId(payload, extraData);
            if (orderId <= 0) {
                return result;
            }

            OrderDAO orderDao = new OrderDAO();
            Order order = orderDao.getOrderById(orderId);
            if (order == null || !"MOMO".equalsIgnoreCase(order.getPaymentMethod())) {
                return result;
            }

            long callbackAmount = payload.optLong("amount", -1L);
            if (Math.round(order.getTotalMoney()) != callbackAmount) {
                return result;
            }

            result.valid = true;
            result.orderId = orderId;

            if (Order.STATUS_PAID_PROCESSING.equals(order.getStatus())) {
                result.success = true;
                return result;
            }

            String resultCode = payload.optString("resultCode", "");
            if ("0".equals(resultCode)) {
                boolean locked = orderDao.updateOrderStatusIfCurrent(orderId, Order.STATUS_PENDING_MOMO,
                        Order.STATUS_PAID_PROCESSING);
                if (locked) {
                    finalizeSuccessfulPayment(order, extraData);
                }

                Order refreshedOrder = orderDao.getOrderById(orderId);
                result.success = refreshedOrder != null
                        && Order.STATUS_PAID_PROCESSING.equals(refreshedOrder.getStatus());
                return result;
            }

            orderDao.updateOrderStatusIfCurrent(orderId, Order.STATUS_PENDING_MOMO, Order.STATUS_MOMO_FAILED);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    private JSONObject readPayload(HttpServletRequest request) throws IOException {
        String contentType = request.getContentType();
        if (contentType != null && contentType.toLowerCase().contains("application/json")) {
            StringBuilder body = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                body.append(line);
            }
            if (body.length() > 0) {
                return new JSONObject(body.toString());
            }
        }

        JSONObject payload = new JSONObject();
        request.getParameterMap().forEach((key, values) -> {
            if (values != null && values.length > 0) {
                payload.put(key, values[0]);
            }
        });
        return payload;
    }

    private int resolveInternalOrderId(JSONObject payload, JSONObject extraData) {
        int internalOrderId = extraData.optInt("internalOrderId", 0);
        if (internalOrderId > 0) {
            return internalOrderId;
        }

        String partnerOrderId = payload.optString("orderId", "");
        if (partnerOrderId.matches("\\d+")) {
            return Integer.parseInt(partnerOrderId);
        }

        if (partnerOrderId.startsWith("FS")) {
            int separatorIndex = partnerOrderId.indexOf('_');
            String rawInternalId = separatorIndex > 2
                    ? partnerOrderId.substring(2, separatorIndex)
                    : partnerOrderId.substring(2);

            if (rawInternalId.matches("\\d+")) {
                return Integer.parseInt(rawInternalId);
            }
        }

        return 0;
    }

    private void finalizeSuccessfulPayment(Order order, JSONObject extraData) {
        OrderDAO orderDao = new OrderDAO();
        ProductDAO productDao = new ProductDAO();
        CartDAO cartDao = new CartDAO();
        VoucherDAO voucherDao = new VoucherDAO();

        for (OrderDetail item : orderDao.getDetails(order.getId())) {
            productDao.decreaseStock(item.getProduct().getPid(), item.getQuantity());
        }

        cartDao.clearCart(order.getUserId());

        int voucherId = extraData.optInt("voucherId", 0);
        if (voucherId > 0) {
            voucherDao.markVoucherUsed(order.getUserId(), voucherId);
        }
    }

    private static class CallbackResult {
        private boolean valid;
        private boolean success;
        private int orderId;
    }
}
