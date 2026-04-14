package controller.admin;

import java.io.IOException;
import java.util.List;
import dao.ProductDAO;
import model.Product;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-products")
public class AdminProductController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        User currUser = (User) session.getAttribute("user");
        Boolean isHardcodedAdmin = (Boolean) session.getAttribute("isAdmin");
        int role = (currUser != null) ? currUser.getIsAdmin() : ((isHardcodedAdmin != null && isHardcodedAdmin) ? 1 : 0);

        if (role == 0) {
            response.sendRedirect("login");
            return;
        }

        String type = request.getParameter("type");
        String keyword = request.getParameter("search");
        ProductDAO dao = new ProductDAO();

        if ("delete".equals(type)) {
            if (role == 2) {
                response.sendRedirect("admin-products?msg=error_permission");
                return;
            }
            try {
                int pid = Integer.parseInt(request.getParameter("pid"));
                dao.deleteProduct(pid);
                response.sendRedirect("admin-products?msg=deleted");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin-products?msg=error");
            }
        } else {
            List<Product> list;
            if (keyword != null && !keyword.trim().isEmpty()) {
                list = dao.searchProduct(keyword.trim());
                request.setAttribute("searchKeyword", keyword);
            } else {
                list = dao.getAllProducts();
            }

            request.setAttribute("listProducts", list);
            request.setAttribute("listP", list);
            request.getRequestDispatcher("/admin-products.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        User currUser = (User) session.getAttribute("user");
        Boolean isHardcodedAdmin = (Boolean) session.getAttribute("isAdmin");
        int role = (currUser != null) ? currUser.getIsAdmin() : ((isHardcodedAdmin != null && isHardcodedAdmin) ? 1 : 0);

        if (role == 2) {
            response.sendRedirect("admin-products?msg=error_permission");
            return;
        }

        String action = request.getParameter("action");
        ProductDAO dao = new ProductDAO();

        try {
            if ("import".equals(action)) {
                int pid = Integer.parseInt(request.getParameter("pid"));
                int addQty = Integer.parseInt(request.getParameter("addQty"));
                if (dao.importStock(pid, addQty)) {
                    response.sendRedirect("admin-products?msg=imported");
                } else {
                    response.sendRedirect("admin-products?msg=error_import");
                }
                return;
            }

            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            double price = (priceStr != null && !priceStr.isEmpty()) ? Double.parseDouble(priceStr) : 0;
            int cateId = Integer.parseInt(request.getParameter("cateId"));
            String color = request.getParameter("color");
            String size = request.getParameter("size");
            String image = request.getParameter("image");
            int stock = 0;
            try { stock = Integer.parseInt(request.getParameter("stock")); } catch (Exception e) {}

            if ("add".equals(action)) {
                Product p = new Product(0, name, price, cateId, color, size, stock, image);
                if (dao.addProduct(p)) response.sendRedirect("admin-products?msg=added");
                else response.sendRedirect("admin-products?msg=error_add");
            } else if ("update".equals(action)) {
                int pid = Integer.parseInt(request.getParameter("pid"));
                Product p = new Product(pid, name, price, cateId, color, size, stock, image);
                dao.updateProduct(p);
                response.sendRedirect("admin-products?msg=updated");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-products?msg=error_data");
        }
    }
}
