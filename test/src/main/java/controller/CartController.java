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

@WebServlet("/cart") // URL mapping
public class CartController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // GET: Khi người dùng bấm vào icon giỏ hàng
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user"); // Lấy user từ session

        // --- [SỬA ĐỔI QUAN TRỌNG] ---
        // Kiểm tra: Nếu chưa đăng nhập (currentUser là null)
        if (currentUser == null) {
            // Chuyển hướng sang trang đăng nhập
            // Kèm tham số ?origin=cart để trang đăng nhập biết cần quay lại đây sau khi xong
            response.sendRedirect("signin.jsp?origin=cart");
            return; // Dừng code tại đây, không chạy tiếp phía dưới
        }
        // -----------------------------

        // Nếu đã đăng nhập, code sẽ chạy tiếp xuống dưới để lấy giỏ hàng từ DataStore
        List<cartItem> rawItems = DataStore.getUserCart(currentUser.getUid());

        // Logic cũ: Chuyển đổi sang DTO để hiển thị
        List<CartItemDTO> displayList = new ArrayList<>();
        double subtotal = 0;
        int totalCount = 0;

        for (cartItem item : rawItems) {
            product p = DataStore.getProductById(item.getPid());
            if (p != null) {
                CartItemDTO dto = new CartItemDTO(p, item.getQuantyti());
                displayList.add(dto);
                
                subtotal += dto.getTotalPrice();
                totalCount += item.getQuantyti();
            }
        }

        // Đẩy dữ liệu sang JSP
        request.setAttribute("cartList", displayList);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("totalCount", totalCount);
        
        request.getRequestDispatcher("cartitem.jsp").forward(request, response);
    }

    // POST: Khi bấm nút "Thêm vào giỏ" hoặc "Xóa"
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");
        
        // --- [SỬA ĐỔI] ---
        // Nếu chưa đăng nhập mà cố tình thêm giỏ hàng -> Cũng bắt đăng nhập luôn
        if (currentUser == null) {
            response.sendRedirect("signin.jsp?origin=cart");
            return;
        }
        // -----------------

        String action = request.getParameter("action"); 
        int pid = Integer.parseInt(request.getParameter("pid"));
        
        if ("add".equals(action)) {
            int quantity = 1;
            try {
                quantity = Integer.parseInt(request.getParameter("quantity"));
            } catch (NumberFormatException e) {}

            // Chỉ còn logic lưu vào DataStore (vì đã bắt buộc đăng nhập)
            DataStore.addItemToUserCart(currentUser.getUid(), pid, quantity);
        } 
        else if ("remove".equals(action)) {
            // Xóa khỏi DataStore
            DataStore.removeUserCartItem(currentUser.getUid(), pid);
        }

        // Quay lại trang giỏ hàng (sẽ kích hoạt doGet ở trên)
        response.sendRedirect("cart"); 
    }
}