package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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

    // GET: Hiển thị giỏ hàng
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
     // --- BỔ SUNG: KIỂM TRA ĐĂNG NHẬP ---
        user currentUser = (user) session.getAttribute("user");
        if (currentUser == null) {
            // Nếu chưa đăng nhập -> Chuyển hướng sang trang Login 
            // Kèm tham số ?origin=cart để sau khi login xong tự quay lại đây
            response.sendRedirect("login.jsp?origin=cart");
            return; // Dừng xử lý, không chạy code bên dưới nữa
        }
        // Lấy giỏ hàng từ Session
        List<cartItem> cart = (List<cartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        // Tính tổng tiền
        double subtotal = 0;
        for (cartItem item : cart) {
            subtotal += item.getTotalPrice();
        }

        // Gửi dữ liệu sang trang JSP
        request.setAttribute("cartList", cart);
        request.setAttribute("subtotal", subtotal);
        
        // Chuyển hướng về trang giao diện giỏ hàng
        request.getRequestDispatcher("cartitem.jsp").forward(request, response);
    }

    // POST: Xử lý Thêm / Xóa / Cập nhật
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action"); // add, remove, update
        int pid = Integer.parseInt(request.getParameter("pid"));
        
        // Lấy giỏ hàng hiện tại
        List<cartItem> cart = (List<cartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        if ("add".equals(action)) {
            int quantity = 1;
            // Kiểm tra sản phẩm đã có trong giỏ chưa
            boolean exist = false;
            for (cartItem item : cart) {
                if (item.getProduct().getPid() == pid) {
                    item.setQuantity(item.getQuantity() + quantity);
                    exist = true;
                    break;
                }
            }
            
            // Nếu chưa có, gọi Database lấy thông tin sp và thêm mới
            if (!exist) {
                ProductDAO dao = new ProductDAO();
                product p = dao.getProductById(pid);
                if (p != null) {
                    cart.add(new cartItem(p, quantity));
                }
            }
        } 
        else if ("remove".equals(action)) {
            // Xóa sản phẩm khỏi list
            for (int i = 0; i < cart.size(); i++) {
                if (cart.get(i).getProduct().getPid() == pid) {
                    cart.remove(i);
                    break;
                }
            }
        }
        else if ("update".equals(action)) {
            // Cập nhật số lượng (ví dụ từ ô input số lượng trong giỏ)
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            for (cartItem item : cart) {
                if (item.getProduct().getPid() == pid) {
                    if (quantity > 0) {
                        item.setQuantity(quantity);
                    } else {
                        // Nếu số lượng về 0 thì xóa luôn
                        cart.remove(item);
                    }
                    break;
                }
            }
        }

        // Lưu ngược lại vào Session
        session.setAttribute("cart", cart);
        
        // Quay lại trang xem giỏ hàng
        response.sendRedirect("cart");
    }
}