package controller.user;

import java.io.IOException;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Product;

@WebServlet("/collection")
public class CollectionController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        if (category == null || category.isEmpty()) {
            category = "all";
        }

        ProductDAO dao = new ProductDAO();
        List<Product> products = dao.getProductsByCategory(category);

        request.setAttribute("products", products);
        request.setAttribute("selectedCategory", category);

        request.getRequestDispatcher("/collection.jsp").forward(request, response);
    }
}
