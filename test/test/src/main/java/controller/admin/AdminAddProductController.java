package controller.admin;

import java.io.IOException;
import dao.ProductDAO;
import model.Product;
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
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            double price = (priceStr != null && !priceStr.isEmpty()) ? Double.parseDouble(priceStr) : 0;

            int cateId = Integer.parseInt(request.getParameter("cateId"));
            String color = request.getParameter("color");
            String size = request.getParameter("size");
            int stock = Integer.parseInt(request.getParameter("stock"));
            String image = request.getParameter("image");

            Product p = new Product(0, name, price, cateId, color, size, stock, image);
            ProductDAO dao = new ProductDAO();

            boolean isAdded = dao.addProduct(p);

            if (isAdded) {
                response.sendRedirect("admin-products?msg=added_product");
            } else {
                response.getWriter().write("<h3>Lỗi: Không thể lưu vào Database!</h3>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi dữ liệu nhập vào: " + e.getMessage());
        }
    }
}
