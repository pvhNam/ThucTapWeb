package controller;

import java.io.IOException;
import dao.ProductDAO;
import model.product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-add-product")
public class AdminAddProductController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            // Lấy dữ liệu từ form
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            double price = (priceStr != null && !priceStr.isEmpty()) ? Double.parseDouble(priceStr) : 0;
            
            int cateId = Integer.parseInt(request.getParameter("cateId"));
            String color = request.getParameter("color");
            String size = request.getParameter("size");
            int stock = Integer.parseInt(request.getParameter("stock"));
            String image = request.getParameter("image");

            // Tạo đối tượng product
            product p = new product(0, name, price, cateId, color, size, stock, image);
            ProductDAO dao = new ProductDAO();
            
            // Gọi hàm thêm và kiểm tra kết quả
            boolean isAdded = dao.addProduct(p);
            
            if (isAdded) {
                // Chuyển hướng về trang DANH SÁCH SẢN PHẨM (Controller)
            	response.sendRedirect("admin-orders?msg=added_product");
            	} else {
                response.getWriter().write("<h3>Lỗi: Không thể lưu vào Database!</h3><p>Kiểm tra lại tên cột trong ProductDAO và Database.</p>");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi dữ liệu nhập vào: " + e.getMessage());
        }
    }
}