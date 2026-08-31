package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.ProductReview;
import model.User;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

import dao.ProductDAO;
import dao.ProductReviewDAO;

@WebServlet("/product-detail")
public class ProductDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đảm bảo encoding để hỗ trợ UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String pidParam = request.getParameter("pid");
        if (pidParam == null || pidParam.isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        try {
            int pid = Integer.parseInt(pidParam);

            ProductDAO pDao = new ProductDAO();
            ProductReviewDAO reviewDao = new ProductReviewDAO();
            Product p = pDao.getProductById(pid);

            if (p == null) {
                // Nếu không tìm thấy sản phẩm, quay về home
                response.sendRedirect("home");
                return;
            }

            reviewDao.populateRatingSummaries(Collections.singletonList(p));

            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            String csrfToken = (String) session.getAttribute("reviewCsrfToken");
            if (csrfToken == null) {
                csrfToken = UUID.randomUUID().toString();
                session.setAttribute("reviewCsrfToken", csrfToken);
            }

            List<ProductReview> reviews = reviewDao.getReviewsByProductId(pid);
            int[] ratingCounts = new int[6];
            int reviewsWithComment = 0;
            for (ProductReview review : reviews) {
                if (review.getRating() >= 1 && review.getRating() <= 5) {
                    ratingCounts[review.getRating()]++;
                }
                if (review.getComment() != null && !review.getComment().isBlank()) {
                    reviewsWithComment++;
                }
            }

            request.setAttribute("reviews", reviews);
            request.setAttribute("ratingCounts", ratingCounts);
            request.setAttribute("reviewsWithComment", reviewsWithComment);
            request.setAttribute("currentReview",
                    currentUser == null ? null : reviewDao.getReviewByUserAndProduct(currentUser.getUid(), pid));
            request.setAttribute("reviewCsrfToken", csrfToken);
            moveFlashMessage(session, request, "reviewSuccess");
            moveFlashMessage(session, request, "reviewError");

            // Chuyển dữ liệu sang view (JSP) — JSP chỉ hiển thị, không xử lý logic
            request.setAttribute("p", p);
            request.getRequestDispatcher("/product-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    private void moveFlashMessage(HttpSession session, HttpServletRequest request, String attributeName) {
        Object message = session.getAttribute(attributeName);
        if (message != null) {
            request.setAttribute(attributeName, message);
            session.removeAttribute(attributeName);
        }
    }
}
