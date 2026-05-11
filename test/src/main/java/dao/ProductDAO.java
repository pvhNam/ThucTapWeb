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
        String sql = "SELECT * FROM product_variants WHERE product_id = ?";
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
                p.setVariants(getVariantsByProductId(p.getPid())); // Gán danh sách biến thể
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
                    p.setVariants(getVariantsByProductId(p.getPid())); // Gán danh sách biến thể
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
                    p.setVariants(getVariantsByProductId(p.getPid())); // Gán danh sách biến thể
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

    // Nhập hàng theo biến thể
    public boolean importStockVariant(int pid, String color, String size, int quantityToAdd) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Kiểm tra xem biến thể Màu/Size này đã có trong kho chưa
            String checkSql = "SELECT id FROM product_variants WHERE product_id = ? AND color = ? AND size = ?";
            ps = conn.prepareStatement(checkSql);
            ps.setInt(1, pid);
            ps.setString(2, color);
            ps.setString(3, size);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Nếu đã có -> Cộng dồn số lượng
                String updateVar = "UPDATE product_variants SET stock_quantity = stock_quantity + ? WHERE id = ?";
                PreparedStatement psUp = conn.prepareStatement(updateVar);
                psUp.setInt(1, quantityToAdd);
                psUp.setInt(2, rs.getInt("id"));
                psUp.executeUpdate();
                psUp.close();
            } else {
                // Nếu chưa có -> Thêm dòng mới
                String insertVar = "INSERT INTO product_variants (product_id, color, size, stock_quantity) VALUES (?, ?, ?, ?)";
                PreparedStatement psIn = conn.prepareStatement(insertVar);
                psIn.setInt(1, pid);
                psIn.setString(2, color);
                psIn.setString(3, size);
                psIn.setInt(4, quantityToAdd);
                psIn.executeUpdate();
                psIn.close();
            }

            // 2. Đồng bộ tổng số lượng vào bảng product chính
            String updateTotal = "UPDATE product SET amount = amount + ? WHERE pid = ?";
            PreparedStatement psTotal = conn.prepareStatement(updateTotal);
            psTotal.setInt(1, quantityToAdd);
            psTotal.setInt(2, pid);
            psTotal.executeUpdate();
            psTotal.close();

            conn.commit(); // Hoàn tất Transaction
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (Exception e) {}
        }
        return false;
    }

    // Trừ kho khi bán
    public void decreaseStock(int pid, int quantity) {
        String sql = "UPDATE product SET amount = amount - ? WHERE pid = ? AND amount >= ?";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, pid);
            ps.setInt(3, quantity);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public List<Product> getProductsByCategory(String categoryName) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.id as cid2, c.name as cname " +
                "FROM product p JOIN category c ON p.cateID = c.id ";

        if (categoryName != null && !categoryName.equals("all")) {
            sql += "WHERE c.name = ?";
        }

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (categoryName != null && !categoryName.equals("all")) {
                ps.setString(1, categoryName);
            }

            ResultSet rs = ps.executeQuery();
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

                Category c = new Category();
                c.setId(rs.getInt("cid2"));
                c.setName(rs.getString("cname"));
                p.setCategory(c);
                p.setVariants(getVariantsByProductId(p.getPid())); // Gán danh sách biến thể

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
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
}