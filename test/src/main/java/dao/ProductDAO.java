package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.product;

public class ProductDAO {

    // 1. Lấy tất cả sản phẩm
    public List<product> getAllProducts() {
        List<product> list = new ArrayList<>();
        String sql = "SELECT * FROM product";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new product(
                    rs.getInt("pid"),
                    rs.getString("name"),
                    rs.getDouble("price"),
                    rs.getInt("cateID"),
                    rs.getString("color"),
                    rs.getString("size"),
                    rs.getInt("amount"),
                    rs.getString("img")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy chi tiết sản phẩm
    public product getProductById(int pid) {
        String sql = "SELECT * FROM product WHERE pid = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pid);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new product(
                        rs.getInt("pid"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getInt("cateID"),
                        rs.getString("color"),
                        rs.getString("size"),
                        rs.getInt("amount"),
                        rs.getString("img")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


 // Trừ kho sau khi mua
    public void decreaseStock(int pid, int quantity) {
        String sql = "UPDATE product SET amount = amount - ? WHERE pid = ? AND amount >= ?";
        try {
            Connection conn = DBConnect.getConnection();
            java.sql.PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, pid);
            ps.setInt(3, quantity); // Đảm bảo không bị âm
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}