package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.product;

public class ProductDAO {

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
 // --- THÊM HÀM MỚI NÀY ---
    // Hàm mới: Lấy 1 sản phẩm theo ID
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
}
