package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.CartDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.cartItem;
import model.product;
import model.user;

@WebServlet("/cart")
public class CartController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // --- GET: HIỂN THỊ GIỎ HÀNG ---
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");
        List<cartItem> cart = new ArrayList<>();

        // Kiểm tra xem có đang đăng nhập không
        if (currentUser != null) {
            // CÁCH 1: ĐÃ ĐĂNG NHẬP -> Lấy dữ liệu từ DATABASE
            CartDAO dao = new CartDAO();
            // LƯU Ý: Kiểm tra class User của bạn là getId() hay getUid()
            cart = dao.getCartByUid(currentUser.getUid()); 
        } else {
            // CÁCH 2: CHƯA ĐĂNG NHẬP -> Lấy dữ liệu từ SESSION
            cart = (List<cartItem>) session.getAttribute("cart");
            if (cart == null) cart = new ArrayList<>();
        }

        // Tính tổng tiền
        double subtotal = 0;
        for (cartItem item : cart) {
            subtotal += item.getTotalPrice();
        }

        // Đẩy dữ liệu sang JSP
        request.setAttribute("cartList", cart);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("totalCount", cart.size());
        
        request.getRequestDispatcher("cartitem.jsp").forward(request, response);
    }

    // --- POST: XỬ LÝ THÊM / SỬA / XÓA ---
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");
        
        String action = request.getParameter("action");
        int pid = 0;
        try {
            pid = Integer.parseInt(request.getParameter("pid"));
        } catch (NumberFormatException e) {
            // Xử lý lỗi nếu không parse được ID
        }

        // =========================================================
        // TRƯỜNG HỢP 1: NGƯỜI DÙNG ĐÃ ĐĂNG NHẬP (Lưu vào DB)
        // =========================================================
        if (currentUser != null) {
            CartDAO dao = new CartDAO();
            int uid = currentUser.getUid(); // Lấy ID của user hiện tại

            if ("add".equals(action)) {
                int quantity = 1;
                if (request.getParameter("quantity") != null)
                    quantity = Integer.parseInt(request.getParameter("quantity"));
                
                // Gọi DAO để thêm/cộng dồn vào DB
                dao.addToCart(uid, pid, quantity);
            } 
            else if ("remove".equals(action)) {
                dao.removeItem(uid, pid);
            }
            else if ("update".equals(action)) {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                if (quantity > 0) {
                    dao.updateQuantity(uid, pid, quantity);
                } else {
                    dao.removeItem(uid, pid);
                }
            }
        } 
        
        // =========================================================
        // TRƯỜNG HỢP 2: KHÁCH VÃNG LAI (Lưu vào Session)
        // =========================================================
        else {
            List<cartItem> cart = (List<cartItem>) session.getAttribute("cart");
            if (cart == null) cart = new ArrayList<>();

            if ("add".equals(action)) {
                int quantity = 1;
                if (request.getParameter("quantity") != null)
                    quantity = Integer.parseInt(request.getParameter("quantity"));

                boolean exist = false;
                for (cartItem item : cart) {
                    if (item.getProduct().getPid() == pid) {
                        item.setQuantity(item.getQuantity() + quantity);
                        exist = true;
                        break;
                    }
                }
                if (!exist) {
                    ProductDAO dao = new ProductDAO();
                    product p = dao.getProductById(pid);
                    if (p != null) cart.add(new cartItem(p, quantity));
                }
            } 
            else if ("remove".equals(action)) {
                for (int i = 0; i < cart.size(); i++) {
                    if (cart.get(i).getProduct().getPid() == pid) {
                        cart.remove(i);
                        break;
                    }
                }
            }
            else if ("update".equals(action)) {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                for (cartItem item : cart) {
                    if (item.getProduct().getPid() == pid) {
                        if (quantity > 0) item.setQuantity(quantity);
                        else cart.remove(item);
                        break;
                    }
                }
            }
            // Cập nhật lại session
            session.setAttribute("cart", cart);
        }

        // Quay lại trang giỏ hàng
        response.sendRedirect("cart");
    }
}