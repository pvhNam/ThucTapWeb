package controller.user;

import java.io.IOException;

import dao.CollectionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Product;
import model.CollectionTheme;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/collection")
public class CollectionController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        if (category == null || category.isBlank()) {
            category = "all";
        }
        CollectionTheme selected = CollectionTheme.fromSlug(category);
        if (!"all".equalsIgnoreCase(category) && selected == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        request.setAttribute("themes", CollectionTheme.all());
        request.setAttribute("selectedTheme", selected);
        request.setAttribute("selectedCategory", selected == null ? "all" : selected.getSlug());
        try {
            CollectionDAO dao = new CollectionDAO();
            Map<String, Integer> counts = dao.getCounts();
            List<Product> products = dao.getProducts(selected);
            request.setAttribute("collectionCounts", counts);
            request.setAttribute("products", products);
        } catch (SQLException error) {
            getServletContext().log("Unable to load collections", error);
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            request.setAttribute("collectionUnavailable", true);
        }

        request.getRequestDispatcher("/collection.jsp").forward(request, response);
    }
}
