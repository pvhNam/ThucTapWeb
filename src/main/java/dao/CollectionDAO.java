package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import model.CollectionTheme;
import model.Product;

public class CollectionDAO {
    private Connection connection() throws SQLException {
        Connection connection = DBConnect.getConnection();
        if (connection == null) throw new SQLException("Database connection unavailable");
        return connection;
    }

    public Map<String, Integer> getCounts() throws SQLException {
        Map<String, Integer> counts = new LinkedHashMap<>();
        for (CollectionTheme theme : CollectionTheme.all()) counts.put(theme.getSlug(), 0);
        try (Connection connection = connection();
             PreparedStatement statement = connection.prepareStatement(
                     "SELECT pc.theme_slug, COUNT(*) AS total FROM product_collections pc "
                     + "JOIN product p ON p.pid = pc.product_id GROUP BY pc.theme_slug");
             ResultSet result = statement.executeQuery()) {
            while (result.next()) counts.put(result.getString("theme_slug"), result.getInt("total"));
        }
        return counts;
    }

    public List<Product> getProducts(CollectionTheme theme) throws SQLException {
        String sql = "SELECT p.* FROM product p WHERE EXISTS (SELECT 1 FROM product_collections pc "
                + "WHERE pc.product_id = p.pid" + (theme == null ? "" : " AND pc.theme_slug = ?")
                + ") ORDER BY p.pid DESC";
        List<Product> products = new ArrayList<>();
        try (Connection connection = connection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            if (theme != null) statement.setString(1, theme.getSlug());
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) products.add(new Product(result.getInt("pid"), result.getString("name"),
                        result.getDouble("price"), result.getInt("cateID"), result.getString("color"),
                        result.getString("size"), result.getInt("amount"), result.getString("img")));
            }
        }
        return products;
    }

    public Map<Integer, Set<String>> getAssignments() throws SQLException {
        Map<Integer, Set<String>> assignments = new LinkedHashMap<>();
        try (Connection connection = connection();
             PreparedStatement statement = connection.prepareStatement("SELECT product_id, theme_slug FROM product_collections");
             ResultSet result = statement.executeQuery()) {
            while (result.next()) assignments.computeIfAbsent(result.getInt("product_id"), key -> new LinkedHashSet<>())
                    .add(result.getString("theme_slug"));
        }
        return assignments;
    }

    public static Set<String> validateThemes(String[] values) {
        Set<String> themes = new LinkedHashSet<>();
        if (values == null) return themes;
        for (String value : values) {
            CollectionTheme theme = CollectionTheme.fromSlug(value);
            if (theme == null) throw new IllegalArgumentException("Invalid collection theme");
            themes.add(theme.getSlug());
        }
        return themes;
    }

    public void replaceThemes(int productId, String[] values) throws SQLException {
        Set<String> themes = validateThemes(values);
        if (productId <= 0) throw new IllegalArgumentException("Invalid product");
        try (Connection connection = connection()) {
            connection.setAutoCommit(false);
            try {
                // Serialize changes to the same product; a failed save preserves its previous assignments.
                try (PreparedStatement lock = connection.prepareStatement("SELECT pid FROM product WHERE pid = ? FOR UPDATE")) {
                    lock.setInt(1, productId);
                    try (ResultSet result = lock.executeQuery()) {
                        if (!result.next()) throw new IllegalArgumentException("Product no longer exists");
                    }
                }
                try (PreparedStatement delete = connection.prepareStatement("DELETE FROM product_collections WHERE product_id = ?")) {
                    delete.setInt(1, productId);
                    delete.executeUpdate();
                }
                try (PreparedStatement insert = connection.prepareStatement("INSERT INTO product_collections (product_id, theme_slug) VALUES (?, ?)")) {
                    for (String theme : themes) {
                        insert.setInt(1, productId);
                        insert.setString(2, theme);
                        insert.addBatch();
                    }
                    insert.executeBatch();
                }
                connection.commit();
            } catch (SQLException | RuntimeException error) {
                connection.rollback();
                throw error;
            }
        }
    }
}
