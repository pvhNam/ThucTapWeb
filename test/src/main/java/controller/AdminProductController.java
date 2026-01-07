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
                response.sendRedirect("admin-products?msg=deleted");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin-products?msg=error");
            }
        } else {
            // === HIỂN THỊ DANH SÁCH ===
            List<product> list = dao.getAllProducts();
            request.setAttribute("listP", list);
            request.getRequestDispatcher("admin-products.jsp").forward(request, response);
        }
    }

    // --- 2. XỬ LÝ POST: THÊM, SỬA, NHẬP HÀNG ---
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action"); 
        ProductDAO dao = new ProductDAO();

        try {
            // --- CHỨC NĂNG 1: NHẬP HÀNG (IMPORT STOCK) ---
            if ("import_stock".equals(action)) {
                int pid = Integer.parseInt(request.getParameter("pid"));
                int quantityToAdd = Integer.parseInt(request.getParameter("quantityAdded"));
                
                if (quantityToAdd > 0) {
                    dao.importStock(pid, quantityToAdd);
                    response.sendRedirect("admin-products?msg=imported");
                } else {
                    response.sendRedirect("admin-products?msg=error_quantity");
                }
                return; // Kết thúc xử lý
            }

            // --- LẤY DỮ LIỆU CHUNG (CHO THÊM & SỬA) ---
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            double price = (priceStr != null && !priceStr.isEmpty()) ? Double.parseDouble(priceStr) : 0;
            
            int cateId = Integer.parseInt(request.getParameter("cateId"));
            String color = request.getParameter("color");
            String size = request.getParameter("size");
            String image = request.getParameter("image");
            
            // Số lượng tồn kho (Dùng cho tạo mới hoặc sửa tay)
            int stock = 0;
            try {
                stock = Integer.parseInt(request.getParameter("stock"));
            } catch(Exception e) { stock = 0; }

            // --- CHỨC NĂNG 2: THÊM MỚI (ADD) ---
            if ("add".equals(action)) {
                product p = new product(0, name, price, cateId, color, size, stock, image);
                boolean isAdded = dao.addProduct(p);
                
                if (isAdded) {
                    response.sendRedirect("admin-products?msg=added");
                } else {
                    response.sendRedirect("admin-products?msg=error_add");
                }
            } 
            // --- CHỨC NĂNG 3: CẬP NHẬT THÔNG TIN (UPDATE) ---
            else if ("update".equals(action)) {
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