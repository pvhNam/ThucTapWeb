package controller.admin;

import java.io.IOException;
import java.util.List;
import dao.ProductDAO;
import model.Product;
import model.ProductVariant;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-variants")
public class AdminVariantController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        User currUser = (User) session.getAttribute("user");
        Boolean isHardcodedAdmin = (Boolean) session.getAttribute("isAdmin");
        int role = (currUser != null) ? currUser.getIsAdmin() : ((isHardcodedAdmin != null && isHardcodedAdmin) ? 1 : 0);

        if (role == 0) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Lấy ID sản phẩm từ URL
            int pid = Integer.parseInt(request.getParameter("pid"));
            ProductDAO dao = new ProductDAO();

            // Lấy thông tin sản phẩm
            Product p = dao.getProductById(pid);

            if (p != null) {
                // Lấy danh sách biến thể (màu/size) của sản phẩm này
                List<ProductVariant> variants = dao.getVariantsByProductId(pid);
                p.setVariants(variants);

                // Truyền dữ liệu sang giao diện mới
                request.setAttribute("product", p);
                request.setAttribute("variants", variants);
                request.getRequestDispatcher("/admin-variants.jsp").forward(request, response);
            } else {
                response.sendRedirect("admin-products?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-products?msg=error");
        }
    }
}