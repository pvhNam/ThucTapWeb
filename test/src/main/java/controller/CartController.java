package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


import dao.DataStore;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItemDTO;
import model.cartItem;
import model.product;
import model.user;

@WebServlet("/cart") // URL mapping cho controller này
public class CartController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // GET: Dùng để HIỂN THỊ trang giỏ hàng
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user"); // Lấy user từ session

        List<cartItem> rawItems = new ArrayList<>();

        // LOGIC: Lấy danh sách item thô
        if (currentUser != null) {
            // 1. Nếu ĐÃ ĐĂNG NHẬP -> Lấy từ "Database" (DataStore)
            rawItems = DataStore.getUserCart(currentUser.getUid());
        } else {
            // 2. Nếu CHƯA ĐĂNG NHẬP -> Lấy từ Session (Giỏ hàng tạm)
            if (session.getAttribute("cart_guest") != null) {
                rawItems = (List<cartItem>) session.getAttribute("cart_guest");
            }
        }

        // LOGIC: Chuyển đổi sang DTO (Kèm thông tin Product đầy đủ) để hiển thị
        List<CartItemDTO> displayList = new ArrayList<>();
        double subtotal = 0;
        int totalCount = 0;

        for (cartItem item : rawItems) {
            product p = DataStore.getProductById(item.getPid());
            if (p != null) {
                CartItemDTO dto = new CartItemDTO(p, item.getQuantyti());
                displayList.add(dto);
                
                // Tính tổng tiền (Mặc định tính hết, nếu có tích chọn JS sẽ xử lý lại ở front-end)
                subtotal += dto.getTotalPrice();
                totalCount += item.getQuantyti();
            }
        }

        // Đẩy dữ liệu sang JSP
        request.setAttribute("cartList", displayList);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("totalCount", totalCount);
        
        // Chuyển hướng đến trang giao diện
        request.getRequestDispatcher("cartitem.jsp").forward(request, response);
    }

    // POST: Dùng để THÊM, SỬA, XÓA sản phẩm
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");
        
        String action = request.getParameter("action"); // add, remove, update
        int pid = Integer.parseInt(request.getParameter("pid"));
        
        if ("add".equals(action)) {
            int quantity = 1;
            try {
                quantity = Integer.parseInt(request.getParameter("quantity"));
            } catch (NumberFormatException e) {}

            if (currentUser != null) {
                // CASE 1: Đã đăng nhập -> Lưu vào DB (DataStore)
                DataStore.addItemToUserCart(currentUser.getUid(), pid, quantity);
            } else {
                // CASE 2: Chưa đăng nhập -> Lưu vào Session
                List<cartItem> guestCart = (List<cartItem>) session.getAttribute("cart_guest");
                if (guestCart == null) guestCart = new ArrayList<>();
                
                boolean exists = false;
                for (cartItem item : guestCart) {
                    if (item.getPid() == pid) {
                        item.setQuantyti(item.getQuantyti() + quantity);
                        exists = true;
                        break;
                    }
                }
                if (!exists) {
                    // Tạo ID tạm cho guest
                    guestCart.add(new cartItem(guestCart.size() + 1, pid, quantity));
                }
                session.setAttribute("cart_guest", guestCart);
            }
        } 
        else if ("remove".equals(action)) {
            if (currentUser != null) {
                DataStore.removeUserCartItem(currentUser.getUid(), pid);
            } else {
                List<cartItem> guestCart = (List<cartItem>) session.getAttribute("cart_guest");
                if (guestCart != null) {
                    guestCart.removeIf(item -> item.getPid() == pid);
                }
            }
        }

        // Sau khi xử lý xong, quay lại trang giỏ hàng
        response.sendRedirect("cart"); 
    }
}