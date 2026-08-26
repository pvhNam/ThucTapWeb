package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Category;
import model.Product;
import model.ProductVariant;

public class ProductDAO {

    // LẤY DANH SÁCH BIẾN THỂ (VARIANT) THEO SẢN PHẨM
    public List<ProductVariant> getVariantsByProductId(int pid) {
        List<ProductVariant> list = new ArrayList<>();
        String sql = "SELECT * FROM product_variants WHERE product_id = ? ORDER BY id";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pid);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new ProductVariant(rs.getInt("id"), rs.getInt("product_id"),
                        rs.getString("color"), rs.getString("size"), rs.getInt("stock_quantity")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // LẤY DANH SÁCH ẢNH PHỤ CỦA SẢN PHẨM
    public List<String> getExtraImages(int pid) {
        List<String> images = new ArrayList<>();
        String sql = "SELECT image_url FROM product_images WHERE product_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pid);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                images.add(rs.getString("image_url"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return images;
    }

    // Lấy tất cả sản phẩm
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product(rs.getInt("pid"), rs.getString("name"), rs.getDouble("price"), rs.getInt("cateID"),
                        rs.getString("color"), rs.getString("size"), rs.getInt("amount"), rs.getString("img"));
                p.setCostPrice(rs.getDouble("cost_price"));
                attachVariantsAndEffectiveStock(p);
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // TÌM KIẾM SẢN PHẨM THEO TÊN
    public List<Product> searchProduct(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE name LIKE ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%"); // Tìm gần đúng
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product(rs.getInt("pid"), rs.getString("name"), rs.getDouble("price"),
                            rs.getInt("cateID"), rs.getString("color"), rs.getString("size"), rs.getInt("amount"),
                            rs.getString("img"));
                    p.setCostPrice(rs.getDouble("cost_price"));
                    attachVariantsAndEffectiveStock(p);
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy sản phẩm theo ID
    public Product getProductById(int pid) {
        String sql = "SELECT * FROM product WHERE pid = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pid);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product(rs.getInt("pid"), rs.getString("name"), rs.getDouble("price"),
                            rs.getInt("cateID"), rs.getString("color"), rs.getString("size"), rs.getInt("amount"),
                            rs.getString("img"));
                    p.setCostPrice(rs.getDouble("cost_price"));

                    attachVariantsAndEffectiveStock(p);
                    p.setExtraImages(getExtraImages(p.getPid())); // Lấy ảnh phụ

                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm sản phẩm
    public boolean addProduct(Product p) {
        String sql = "INSERT INTO product (name, price, cateID, color, size, amount, img) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, p.getPdescription());
            ps.setDouble(2, p.getPrice());
            ps.setInt(3, p.getCid());
            ps.setString(4, p.getColor());
            ps.setString(5, p.getSize());
            ps.setInt(6, p.getStockquantyti());
            ps.setString(7, p.getImage());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public int addProductReturnId(Product p) {
        String sql = "INSERT INTO product (name, price, cateID, color, size, amount, img) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, p.getPdescription());
            ps.setDouble(2, p.getPrice());
            ps.setInt(3, p.getCid());
            ps.setString(4, p.getColor());
            ps.setString(5, p.getSize());
            ps.setInt(6, p.getStockquantyti());
            ps.setString(7, p.getImage());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Trả về ID vừa sinh ra
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    // Cập nhật sản phẩm
    public boolean updateProduct(Product p) {
        String sql = "UPDATE product SET name=?, price=?, cateID=?, color=?, size=?, amount=?, img=? WHERE pid=?";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, p.getPdescription());
            ps.setDouble(2, p.getPrice());
            ps.setInt(3, p.getCid());
            ps.setString(4, p.getColor());
            ps.setString(5, p.getSize());
            ps.setInt(6, p.getStockquantyti());
            ps.setString(7, p.getImage());
            ps.setInt(8, p.getPid());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // Cập nhật bộ ảnh phụ (Xóa ảnh cũ, thêm ảnh mới)
    public void updateExtraImages(int pid, String[] imageUrls) {
        try (Connection conn = DBConnect.getConnection()) {
            // 1. Xóa toàn bộ ảnh phụ cũ của SP này
            String sqlDelete = "DELETE FROM product_images WHERE product_id = ?";
            try (PreparedStatement psDel = conn.prepareStatement(sqlDelete)) {
                psDel.setInt(1, pid);
                psDel.executeUpdate();
            }

            // 2. Thêm danh sách ảnh mới vào
            if (imageUrls != null && imageUrls.length > 0) {
                String sqlInsert = "INSERT INTO product_images (product_id, image_url) VALUES (?, ?)";
                try (PreparedStatement psIn = conn.prepareStatement(sqlInsert)) {
                    for (String url : imageUrls) {
                        if (url != null && !url.trim().isEmpty()) {
                            psIn.setInt(1, pid);
                            psIn.setString(2, url.trim());
                            psIn.executeUpdate();
                        }
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Xóa sản phẩm
    public void deleteProduct(int pid) {
        String sql = "DELETE FROM product WHERE pid=?";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, pid);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Cập nhật số lượng của 1 biến thể cụ thể
    public boolean updateVariantQuantity(int variantId, int newQty) {
        String sqlUpdateVar = "UPDATE product_variants SET stock_quantity = ? WHERE id = ?";
        String sqlSyncTotal = "UPDATE product p SET amount = (SELECT SUM(stock_quantity) FROM product_variants WHERE product_id = p.pid) " +
                "WHERE pid = (SELECT product_id FROM product_variants WHERE id = ?)";
        try (Connection conn = DBConnect.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(sqlUpdateVar);
                 PreparedStatement ps2 = conn.prepareStatement(sqlSyncTotal)) {

                ps1.setInt(1, newQty);
                ps1.setInt(2, variantId);
                ps1.executeUpdate();

                ps2.setInt(1, variantId);
                ps2.executeUpdate();

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // Xóa một biến thể (màu/size) khỏi kho
    public boolean deleteVariant(int variantId) {
        String sqlGetPid = "SELECT product_id FROM product_variants WHERE id = ?";
        String sqlDelete = "DELETE FROM product_variants WHERE id = ?";
        String sqlSyncTotal = "UPDATE product SET amount = (SELECT COALESCE(SUM(stock_quantity), 0) FROM product_variants WHERE product_id = ?) WHERE pid = ?";

        try (Connection conn = DBConnect.getConnection()) {
            conn.setAutoCommit(false);
            int pid = -1;
            try (PreparedStatement psPid = conn.prepareStatement(sqlGetPid)) {
                psPid.setInt(1, variantId);
                ResultSet rs = psPid.executeQuery();
                if (rs.next()) pid = rs.getInt("product_id");
            }

            try (PreparedStatement psDel = conn.prepareStatement(sqlDelete);
                 PreparedStatement psSync = conn.prepareStatement(sqlSyncTotal)) {

                psDel.setInt(1, variantId);
                psDel.executeUpdate();

                if (pid != -1) {
                    psSync.setInt(1, pid);
                    psSync.setInt(2, pid);
                    psSync.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public List<Product> getProductsByCategory(String categoryName) {
        List<Product> list = new ArrayList<>();
        boolean useCategory = categoryName != null && !"all".equalsIgnoreCase(categoryName) && !categoryName.trim().isEmpty();
        String lower = categoryName != null ? categoryName.toLowerCase() : null;

        PreparedStatement ps = null;
        try (Connection conn = DBConnect.getConnection()) {
            String sql;
            if (!useCategory || "bộ sưu tập 2026".equalsIgnoreCase(lower) || "bo suu tap 2026".equalsIgnoreCase(lower)) {
                sql = "SELECT * FROM product";
                ps = conn.prepareStatement(sql);
            } else if ("áo nam".equalsIgnoreCase(lower) || "ao nam".equalsIgnoreCase(lower) || "áo".equalsIgnoreCase(lower) || "ao".equalsIgnoreCase(lower)) {
                sql = "SELECT * FROM product WHERE (LOWER(name) LIKE ? ) " +
                      "AND LOWER(name) NOT LIKE ?  AND LOWER(name) NOT LIKE ? AND LOWER(name) NOT LIKE ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, "%áo%");
                ps.setString(2, "%nữ%");
                ps.setString(3, "%ghim%");
                ps.setString(4, "%vớ%");
            } else if ("quần nam".equalsIgnoreCase(lower) || "quan nam".equalsIgnoreCase(lower)) {
                sql = "SELECT * FROM product WHERE (LOWER(name) LIKE ? OR LOWER(name) LIKE ?) AND LOWER(name) LIKE ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, "%quần%");
                ps.setString(2, "%quan%");
                ps.setString(3, "%nam%");
            } else if ("phụ kiện".equalsIgnoreCase(lower) || "phu kien".equalsIgnoreCase(lower)) {
                sql = "SELECT * FROM product WHERE NOT ( (LOWER(name) LIKE ? OR LOWER(name) LIKE ?) AND LOWER(name) LIKE ? ) " +
                      "AND NOT ( (LOWER(name) LIKE ? OR LOWER(name) LIKE ?) AND LOWER(name) LIKE ? )";
                ps = conn.prepareStatement(sql);
                ps.setString(1, "%áo%");
                ps.setString(2, "%ao%");
                ps.setString(3, "%nam%");
                ps.setString(4, "%quần%");
                ps.setString(5, "%quan%");
                ps.setString(6, "%nam%");
            } else {
                sql = "SELECT * FROM product WHERE LOWER(name) LIKE ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, "%" + lower + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product(
                            rs.getInt("pid"),
                            rs.getString("name"),
                            rs.getDouble("price"),
                            rs.getInt("cateID"),
                            rs.getString("color"),
                            rs.getString("size"),
                            rs.getInt("amount"),
                            rs.getString("img")
                    );
                    p.setCostPrice(rs.getDouble("cost_price"));
                    attachVariantsAndEffectiveStock(p);
                    list.add(p);
                }
            } finally {
                try { if (ps != null) ps.close(); } catch (Exception ex) {}
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Products created before variant inventory was introduced still use product.amount.
     * As soon as a product has variants, their sum is the authoritative stock value.
     */
    private void attachVariantsAndEffectiveStock(Product product) {
        List<ProductVariant> variants = getVariantsByProductId(product.getPid());
        product.setVariants(variants);
        if (!variants.isEmpty()) {
            int total = 0;
            for (ProductVariant variant : variants) {
                total += Math.max(0, variant.getStockQuantity());
            }
            product.setStockquantyti(total);
        }
    }

    /**
     * Returns stock for the exact selected size/color. For legacy products without
     * variants, product.amount remains the stock source. A missing product or an
     * invalid variant selection has zero available stock.
     */
    public int getAvailableStock(int pid, String color, String size) {
        String sql = "SELECT CASE "
                + "WHEN EXISTS (SELECT 1 FROM product_variants pv0 WHERE pv0.product_id = p.pid) "
                + "THEN COALESCE((SELECT SUM(pv.stock_quantity) FROM product_variants pv "
                + "WHERE pv.product_id = p.pid AND pv.color = ? AND pv.size = ?), 0) "
                + "ELSE GREATEST(COALESCE(p.amount, 0), 0) END AS available_stock "
                + "FROM product p WHERE p.pid = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, normalizeVariantValue(color));
            ps.setString(2, normalizeVariantValue(size));
            ps.setInt(3, pid);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Math.max(0, rs.getInt("available_stock"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private String normalizeVariantValue(String value) {
        return value == null ? "" : value.trim();
    }
}
