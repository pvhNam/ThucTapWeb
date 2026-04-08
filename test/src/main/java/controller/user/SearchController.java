package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

import java.io.IOException;
import java.util.List;

import dao.ProductDAO;

@WebServlet("/search")
public class SearchController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            String txtSearch = request.getParameter("txt");
            if (txtSearch != null) txtSearch = txtSearch.trim();

            ProductDAO dao = new ProductDAO();
            List<Product> list;
            if (txtSearch == null || txtSearch.isEmpty()) {
                list = dao.getAllProducts();
            } else {
                list = dao.searchProduct(txtSearch);
            }

            request.setAttribute("listP", list);
            request.setAttribute("txt", txtSearch);
            request.setAttribute("tag", "about");

            request.getRequestDispatcher("/views/user/about.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
