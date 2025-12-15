package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.product;

import java.io.IOException;

import dao.ProductDAO;

//Định nghĩa URL cho controller này
@WebServlet("/product-detail")
public class ProductDetailController extends HttpServlet {
 private static final long serialVersionUID = 1L;

 public ProductDetailController() {
     super();
 }

 protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     // 1. Lấy tham số pid từ URL
     String pidParam = request.getParameter("pid");
     
     // 2. Kiểm tra tham số đầu vào
     if (pidParam == null || pidParam.isEmpty()) {
         response.sendRedirect("index.jsp");
         return;
     }

     try {
         int pid = Integer.parseInt(pidParam);
         
         // 3. Gọi DAO để lấy dữ liệu
         ProductDAO pDao = new ProductDAO();
         product p = pDao.getProductById(pid); // Sử dụng method getProductById từ DAO [cite: 23]

         // 4. Kiểm tra sản phẩm có tồn tại không
         if (p == null) {
             // Nếu không tìm thấy sản phẩm, quay về trang chủ
             response.sendRedirect("index.jsp");
         } else {
             // 5. Đẩy dữ liệu sang JSP
             request.setAttribute("p", p); 
             
             // Forward (chuyển tiếp) sang trang giao diện
             request.getRequestDispatcher("product-detail.jsp").forward(request, response);
         }
         
     } catch (NumberFormatException e) {
         // Nếu pid không phải là số -> về trang chủ
         response.sendRedirect("index.jsp");
     }
 }

 protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     doGet(request, response);
 }
}