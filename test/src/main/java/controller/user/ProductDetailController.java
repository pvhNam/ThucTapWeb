package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

import java.io.IOException;

import dao.ProductDAO;

@WebServlet("/product-detail")
public class ProductDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pidParam = request.getParameter("pid");
        if (pidParam == null || pidParam.isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        try {
            int pid = Integer.parseInt(pidParam);

            ProductDAO pDao = new ProductDAO();
            Product p = pDao.getProductById(pid);

            if (p == null) {
                response.sendRedirect("home");
            } else {
                request.setAttribute("p", p);
                request.getRequestDispatcher("/views/user/product-detail.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
