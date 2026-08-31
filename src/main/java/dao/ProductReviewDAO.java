package dao;

import model.Product;
import model.ProductReview;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductReviewDAO {

    public List<ProductReview> getReviewsByProductId(int productId) {
        List<ProductReview> reviews = new ArrayList<>();
        String sql = "SELECT pr.*, "
                + "COALESCE(NULLIF(TRIM(u.fullname), ''), u.username) AS display_name, u.avatar "
                + "FROM product_reviews pr "
                + "JOIN users u ON u.uid = pr.user_id "
                + "WHERE pr.product_id = ? "
                + "ORDER BY pr.updated_at DESC, pr.id DESC";

        try (Connection connection = DBConnect.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, productId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    reviews.add(mapReview(resultSet));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reviews;
    }

    public ProductReview getReviewByUserAndProduct(int userId, int productId) {
        String sql = "SELECT pr.*, "
                + "COALESCE(NULLIF(TRIM(u.fullname), ''), u.username) AS display_name, u.avatar "
                + "FROM product_reviews pr "
                + "JOIN users u ON u.uid = pr.user_id "
                + "WHERE pr.user_id = ? AND pr.product_id = ?";

        try (Connection connection = DBConnect.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, productId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapReview(resultSet);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean saveOrUpdateReview(int userId, int productId, int rating, String comment) {
        String sql = "INSERT INTO product_reviews (product_id, user_id, rating, comment) "
                + "VALUES (?, ?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE rating = VALUES(rating), comment = VALUES(comment), "
                + "updated_at = CURRENT_TIMESTAMP";

        try (Connection connection = DBConnect.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, productId);
            statement.setInt(2, userId);
            statement.setInt(3, rating);
            statement.setString(4, comment);
            statement.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Loads average rating and review count for all supplied products in one query.
     */
    public void populateRatingSummaries(List<Product> products) {
        if (products == null || products.isEmpty()) {
            return;
        }

        Map<Integer, Product> productsById = new HashMap<>();
        for (Product product : products) {
            product.setAverageRating(0);
            product.setReviewCount(0);
            productsById.put(product.getPid(), product);
        }

        String placeholders = String.join(",", Collections.nCopies(productsById.size(), "?"));
        String sql = "SELECT product_id, AVG(rating) AS average_rating, COUNT(*) AS review_count "
                + "FROM product_reviews WHERE product_id IN (" + placeholders + ") GROUP BY product_id";

        try (Connection connection = DBConnect.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            int index = 1;
            for (Integer productId : productsById.keySet()) {
                statement.setInt(index++, productId);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Product product = productsById.get(resultSet.getInt("product_id"));
                    if (product != null) {
                        product.setAverageRating(resultSet.getDouble("average_rating"));
                        product.setReviewCount(resultSet.getInt("review_count"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private ProductReview mapReview(ResultSet resultSet) throws SQLException {
        ProductReview review = new ProductReview();
        review.setId(resultSet.getInt("id"));
        review.setProductId(resultSet.getInt("product_id"));
        review.setUserId(resultSet.getInt("user_id"));
        review.setRating(resultSet.getInt("rating"));
        review.setComment(resultSet.getString("comment"));
        review.setUserDisplayName(resultSet.getString("display_name"));
        review.setUserAvatar(resultSet.getString("avatar"));
        review.setCreatedAt(resultSet.getTimestamp("created_at"));
        review.setUpdatedAt(resultSet.getTimestamp("updated_at"));
        return review;
    }
}
