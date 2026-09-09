package controller.admin;

import dao.CollectionDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import model.CollectionTheme;
import model.Product;
import model.User;

@WebServlet("/admin-collections")
public class AdminCollectionController extends HttpServlet {
    private boolean authorize(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        boolean allowed = user != null ? user.getIsAdmin() == 1
                : session != null && Boolean.TRUE.equals(session.getAttribute("isAdmin"));
        if (!allowed) response.sendError(HttpServletResponse.SC_FORBIDDEN);
        return allowed;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authorize(request, response)) return;
        HttpSession session = request.getSession();
        if (session.getAttribute("collectionCsrf") == null) session.setAttribute("collectionCsrf", UUID.randomUUID().toString());
        String search = request.getParameter("search");
        request.setAttribute("searchKeyword", search);
        request.setAttribute("themes", CollectionTheme.all());
        try {
            CollectionDAO dao = new CollectionDAO();
            Map<Integer, Set<String>> assignments = dao.getAssignments();
            ProductDAO productDAO = new ProductDAO();
            List<Product> products = search == null || search.isBlank()
                    ? productDAO.getAllProducts() : productDAO.searchProduct(search.trim());
            for (Product product : products) product.setCollectionThemes(assignments.getOrDefault(product.getPid(), Set.of()));
            request.setAttribute("products", products);
            request.setAttribute("collectionCounts", dao.getCounts());
        } catch (SQLException error) {
            getServletContext().log("Unable to load collection management", error);
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            request.setAttribute("collectionUnavailable", true);
        }
        request.getRequestDispatcher("/WEB-INF/views/admin-collections.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!authorize(request, response)) return;
        request.setCharacterEncoding("UTF-8");
        Object token = request.getSession().getAttribute("collectionCsrf");
        if (token == null || !token.equals(request.getParameter("csrf"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        String message;
        int productId;
        try {
            productId = Integer.parseInt(request.getParameter("pid"));
            new CollectionDAO().replaceThemes(productId, request.getParameterValues("themes"));
            message = "saved";
        } catch (IllegalArgumentException error) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        } catch (SQLException error) {
            getServletContext().log("Unable to save product collections", error);
            message = "error";
            productId = 0;
        }
        String search = request.getParameter("search");
        response.sendRedirect(request.getContextPath() + "/admin-collections?msg=" + message
                + "&search=" + URLEncoder.encode(search == null ? "" : search, StandardCharsets.UTF_8)
                + (productId > 0 ? "#product-" + productId : ""));
    }
}
