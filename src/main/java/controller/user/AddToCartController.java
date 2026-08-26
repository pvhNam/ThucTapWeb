package controller.user;

import java.io.IOException;
import java.util.List;
import model.Product;
import model.CartItem;
import model.User;
import dao.CartDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;

@WebServlet("/add-to-cart")
public class AddToCartController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        boolean ajax = isAjax(req);

        User acc = (User) session.getAttribute("user");

        if (acc == null) {
            if (ajax) {
                writeJson(resp, HttpServletResponse.SC_UNAUTHORIZED, false,
                        "Vui lòng đăng nhập để thêm sản phẩm.", 0, true);
                return;
            }
            resp.sendRedirect("login");
            return;
        }
        int pid = 0;
        int quantity = 1;

        try {

            pid = Integer.parseInt(
                    req.getParameter("pid"));

            String qStr =
                    req.getParameter("quantity");

            if (qStr != null && !qStr.isEmpty()) {
                quantity = Integer.parseInt(qStr);
            }

        } catch (NumberFormatException e) {

            if (ajax) {
                writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, false,
                        "Thông tin sản phẩm không hợp lệ.", 0, false);
                return;
            }

            resp.sendRedirect("home");
            return;
        }

        String color = req.getParameter("color");
        String size = req.getParameter("size");

        color = color == null ? "" : color.trim();
        size = size == null ? "" : size.trim();

        ProductDAO productDAO = new ProductDAO();
        CartDAO cartDAO = new CartDAO();

        Product p = productDAO.getProductById(pid);

        if (p == null || quantity <= 0) {
            if (ajax) {
                writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, false,
                        "Sản phẩm hoặc số lượng không hợp lệ.", 0, false);
                return;
            }
            resp.sendRedirect("home");
            return;
        }

        List<CartItem> currentCart = cartDAO.getCartByUid(acc.getUid());
        int currentQuantity = 0;
        for (CartItem item : currentCart) {
            String itemColor = item.getColor() == null ? "" : item.getColor();
            String itemSize = item.getSize() == null ? "" : item.getSize();
            if (item.getProduct().getPid() == pid && itemColor.equals(color) && itemSize.equals(size)) {
                currentQuantity = item.getQuantity();
                break;
            }
        }

        int availableStock = productDAO.getAvailableStock(pid, color, size);
        if (availableStock <= 0) {
            String message = "Phân loại size/màu này đã hết hàng hoặc không tồn tại.";
            if (ajax) {
                writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, false,
                        message, currentCart.size(), false);
                return;
            }
            session.setAttribute("toastMessage", message);
            session.setAttribute("toastType", "error");
            redirectBack(req, resp);
            return;
        }

        if (currentQuantity + quantity > availableStock) {

            if (ajax) {
                writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, false,
                        "Bạn chỉ có thể thêm tối đa " + Math.max(0, availableStock - currentQuantity)
                                + " sản phẩm nữa.", currentCart.size(), false);
                return;
            }

            session.setAttribute(
                    "toastMessage",
                    "Không thể thêm! Kho chỉ còn "
                            + availableStock
                            + " sản phẩm cho phân loại đã chọn."
            );

            session.setAttribute(
                    "toastType",
                    "error"
            );

            redirectBack(req, resp);

            return;
        }

        cartDAO.addToCart(
                acc.getUid(),
                pid,
                color,
                size,
                quantity
        );

        int cartCount = cartDAO.getCartByUid(acc.getUid()).size();
        session.setAttribute("cartCount", cartCount);
        if (ajax) {
            writeJson(resp, HttpServletResponse.SC_OK, true,
                    "Đã thêm vào giỏ hàng.", cartCount, false);
            return;
        }

        session.setAttribute(
                "toastMessage",
                "Đã thêm vào giỏ hàng"
        );

        session.setAttribute(
                "toastType",
                "success"
        );

        redirectBack(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        doGet(req, resp);
    }

    private boolean isAjax(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        return "XMLHttpRequest".equalsIgnoreCase(requestedWith)
                || (accept != null && accept.contains("application/json"));
    }

    private void redirectBack(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String referer = request.getHeader("referer");
        response.sendRedirect(referer == null || referer.isBlank() ? "home" : referer);
    }

    private void writeJson(HttpServletResponse response, int status, boolean success,
                           String message, int cartCount, boolean loginRequired) throws IOException {
        JSONObject json = new JSONObject();
        json.put("success", success);
        json.put("message", message);
        json.put("cartCount", cartCount);
        json.put("loginRequired", loginRequired);
        if (loginRequired) json.put("redirect", "login");

        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());
    }
}
