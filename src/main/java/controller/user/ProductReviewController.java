package controller.user;

import dao.ProductDAO;
import dao.ProductReviewDAO;
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

@WebServlet("/product-review")
public class ProductReviewController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int MAX_COMMENT_LENGTH = 1000;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer productId = parseInteger(request.getParameter("pid"));
        if (productId == null || productId <= 0) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String submittedToken = request.getParameter("csrfToken");
        String sessionToken = (String) session.getAttribute("reviewCsrfToken");
        if (sessionToken == null || submittedToken == null || !sessionToken.equals(submittedToken)) {
            redirectWithError(request, response, session, productId,
                    "Phiên gửi đánh giá đã hết hạn. Vui lòng thử lại.");
            return;
        }

        Integer rating = parseInteger(request.getParameter("rating"));
        if (rating == null || rating < 1 || rating > 5) {
            redirectWithError(request, response, session, productId,
                    "Vui lòng chọn số sao từ 1 đến 5.");
            return;
        }

        String comment = request.getParameter("comment");
        comment = comment == null ? "" : comment.trim();
        if (comment.length() > MAX_COMMENT_LENGTH) {
            redirectWithError(request, response, session, productId,
                    "Nhận xét không được vượt quá 1000 ký tự.");
            return;
        }
        if (comment.isEmpty()) {
            comment = null;
        }

        Product product = new ProductDAO().getProductById(productId);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        ProductReviewDAO reviewDao = new ProductReviewDAO();
        ProductReview existingReview = reviewDao.getReviewByUserAndProduct(currentUser.getUid(), productId);
        if (reviewDao.saveOrUpdateReview(currentUser.getUid(), productId, rating, comment)) {
            session.setAttribute("reviewSuccess", existingReview == null
                    ? "Cảm ơn bạn! Đánh giá đã được ghi nhận."
                    : "Đánh giá của bạn đã được cập nhật.");
        } else {
            session.setAttribute("reviewError", "Không thể lưu đánh giá lúc này. Vui lòng thử lại.");
        }

        redirectToReviews(request, response, productId);
    }

    private Integer parseInteger(String value) {
        try {
            return value == null ? null : Integer.valueOf(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response,
                                   HttpSession session, int productId, String message) throws IOException {
        session.setAttribute("reviewError", message);
        redirectToReviews(request, response, productId);
    }

    private void redirectToReviews(HttpServletRequest request, HttpServletResponse response, int productId)
            throws IOException {
        response.sendRedirect(response.encodeRedirectURL(
                request.getContextPath() + "/product-detail?pid=" + productId + "#reviews"));
    }
}
