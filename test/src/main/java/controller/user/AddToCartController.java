package controller.user;

import java.io.IOException;
import model.Product;
import model.User;
import dao.CartDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add-to-cart")
public class AddToCartController extends HttpServlet {
    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User acc = (User) session.getAttribute("user");

        if (acc == null) {
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

        // Lấy thêm màu sắc và kích cỡ từ request
        String color = req.getParameter("color");
        String size = req.getParameter("size");
        if (color == null) color = "";
        if (size == null) size = "";

        ProductDAO productDAO = new ProductDAO();
        Product p = productDAO.getProductById(pid);
        if (p != null && quantity > p.getStockquantyti()) {
            session.setAttribute("voucherMsg", "Khong the them! Kho chi con " + p.getStockquantyti() + " san pham.");
            session.setAttribute("msgType", "error");
            resp.sendRedirect("cart");
            return;
        }

        // Gọi hàm addToCart với đầy đủ 5 tham số
        cartDAO.addToCart(acc.getUid(), pid, color, size, quantity);
        resp.sendRedirect("cart");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}