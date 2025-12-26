package controller;

import java.io.IOException;
import java.util.List;
import dao.ProductDAO;
import model.product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-products")
public class AdminProductController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // --- 1. XỬ LÝ GET: HIỂN THỊ DANH SÁCH & XÓA ---
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        ProductDAO dao = new ProductDAO();

        if ("delete".equals(type)) {
            // === XÓA SẢN PHẨM ===
            try {
                int pid = Integer.parseInt(request.getParameter("pid"));
                dao.deleteProduct(pid);
                // Xóa xong reload lại trang kèm thông báo
                response.sendRedirect("admin-products?msg=deleted");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin-products?msg=error");
            }
        } else {
            // === HIỂN THỊ DANH SÁCH (Mặc định) ===
            List<product> list = dao.getAllProducts();
            request.setAttribute("listP", list);
            request.getRequestDispatcher("admin-products.jsp").forward(request, response);
        }
    }

    // --- 2. XỬ LÝ POST: THÊM MỚI & CẬP NHẬT (SỬA) ---
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Lấy tham số "action" để biết là đang Thêm hay Sửa
        String action = request.getParameter("action"); 
        ProductDAO dao = new ProductDAO();

        try {
            // Lấy dữ liệu chung từ form (Cả thêm và sửa đều cần những trường này)
            String name = request.getParameter("name");
            
            String priceStr = request.getParameter("price");
            double price = (priceStr != null && !priceStr.isEmpty()) ? Double.parseDouble(priceStr) : 0;
            
            int cateId = Integer.parseInt(request.getParameter("cateId"));
            String color = request.getParameter("color");
            String size = request.getParameter("size");
            int stock = Integer.parseInt(request.getParameter("stock"));
            String image = request.getParameter("image");

            // --- TRƯỜNG HỢP 1: THÊM MỚI (ADD) ---
            if ("add".equals(action)) {
                // ID = 0 (hoặc số bất kỳ vì DB tự tăng), gọi hàm addProduct
                product p = new product(0, name, price, cateId, color, size, stock, image);
                boolean isAdded = dao.addProduct(p);
                
                if (isAdded) {
                    response.sendRedirect("admin-products?msg=added");
                } else {
                    response.sendRedirect("admin-products?msg=error_add");
                }
            } 
            // --- TRƯỜNG HỢP 2: CẬP NHẬT (UPDATE) ---
            else {
                // Sửa thì bắt buộc phải lấy PID
                int pid = Integer.parseInt(request.getParameter("pid"));
                
                product p = new product(pid, name, price, cateId, color, size, stock, image);
                dao.updateProduct(p);
                
                response.sendRedirect("admin-products?msg=updated");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-products?msg=error_data");
        }
    }
}