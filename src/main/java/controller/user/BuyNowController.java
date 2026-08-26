package controller.user;

import java.io.IOException;
import java.util.List;

import dao.CartDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.CartItem;
import model.User;

@WebServlet("/buy-now")
public class BuyNowController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Yêu cầu đăng nhập nếu chưa có session
        if (currentUser == null) {
            resp.sendRedirect("login");
            return;
        }

        int pid = 0;
        int quantity = 1;
        try {
            pid = Integer.parseInt(req.getParameter("pid"));
            String qStr = req.getParameter("quantity");
            if (qStr != null && !qStr.isEmpty()) {
                quantity = Integer.parseInt(qStr);
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect("home");
            return;
        }

        // Lấy thêm tham số màu sắc và kích cỡ từ request
        String color = req.getParameter("color");
        String size = req.getParameter("size");
        color = color == null ? "" : color.trim();
        size = size == null ? "" : size.trim();

        ProductDAO productDAO = new ProductDAO();
        Product p = productDAO.getProductById(pid);
        if (p == null || quantity <= 0) {
            resp.sendRedirect("home");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        int currentQuantity = 0;
        List<CartItem> currentCart = cartDAO.getCartByUid(currentUser.getUid());
        for (CartItem item : currentCart) {
            String itemColor = item.getColor() == null ? "" : item.getColor();
            String itemSize = item.getSize() == null ? "" : item.getSize();
            if (item.getProduct().getPid() == pid && itemColor.equals(color) && itemSize.equals(size)) {
                currentQuantity = item.getQuantity();
                break;
            }
        }

        int availableStock = productDAO.getAvailableStock(pid, color, size);
        if (availableStock <= 0 || currentQuantity + quantity > availableStock) {
            session.setAttribute("toastMessage",
                    availableStock <= 0
                            ? "Phân loại size/màu này đã hết hàng hoặc không tồn tại."
                            : "Kho chỉ còn " + availableStock + " sản phẩm cho phân loại đã chọn.");
            session.setAttribute("toastType", "error");
            String referer = req.getHeader("referer");
            resp.sendRedirect(referer == null || referer.isBlank() ? "home" : referer);
            return;
        }

        // Cập nhật hàm addToCart với đủ 5 tham số
        cartDAO.addToCart(currentUser.getUid(), pid, color, size, quantity);

        // Mua ngay nên chuyển hướng thẳng tới trang thanh toán
        resp.sendRedirect("checkout");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect("home");
    }
}
