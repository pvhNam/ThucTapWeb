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
                list.add(new product(rs.getInt("pid"), rs.getString("name"), rs.getDouble("price"), rs.getInt("cateID"),
                        rs.getString("color"), rs.getString("size"), rs.getInt("amount"), rs.getString("img")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy sản phẩm theo ID
    public product getProductById(int pid) {
        String sql = "SELECT * FROM product WHERE pid = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pid);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new product(rs.getInt("pid"), rs.getString("name"), rs.getDouble("price"),
                            rs.getInt("cateID"), rs.getString("color"), rs.getString("size"), rs.getInt("amount"),
                            rs.getString("img"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. THÊM SẢN PHẨM MỚI
 // Trong file: dao/ProductDAO.java

 // Sửa lại hàm addProduct
 public boolean addProduct(product p) {
     // Thêm cột cost_price vào câu lệnh INSERT
     String sql = "INSERT INTO product (name, price, cateID, color, size, amount, img, cost_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

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
         
         // --- XỬ LÝ YÊU CẦU 1: GIÁ NHẬP = 50% GIÁ BÁN ---
         double importPrice = p.getPrice() * 0.5; 
         ps.setDouble(8, importPrice);
         // -----------------------------------------------

         int row = ps.executeUpdate();
         return row > 0;
     } catch (Exception e) {
         System.out.println("Lỗi SQL: " + e.getMessage());
         e.printStackTrace();
     }
     return false;
 }

    // 4. CẬP NHẬT THÔNG TIN SẢN PHẨM (Không cộng dồn, chỉ ghi đè)
    public boolean updateProduct(product p) {
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. XÓA SẢN PHẨM
    public void deleteProduct(int pid) {
        String sql = "DELETE FROM product WHERE pid=?";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, pid);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    
 // Trừ tồn kho (Thêm hàm này vào cuối file ProductDAO.java)
    public void decreaseStock(int pid, int quantity) {
        String sql = "UPDATE product SET amount = amount - ? WHERE pid = ? AND amount >= ?";
        try {
            java.sql.Connection conn = DBConnect.getConnection();
            java.sql.PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, pid);
            ps.setInt(3, quantity);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
 // Trong file: dao/ProductDAO.java

 // Sửa lại hàm importStock
 public boolean importStock(int pid, int quantityToAdd) {
     Connection conn = null;
     PreparedStatement psUpdate = null;
     PreparedStatement psHistory = null;
     
     try {
         conn = DBConnect.getConnection();
         conn.setAutoCommit(false); // Bật Transaction để đảm bảo an toàn

         // 1. Cập nhật số lượng tồn kho (Cộng dồn)
         String sqlUpdate = "UPDATE product SET amount = amount + ? WHERE pid = ?";
         psUpdate = conn.prepareStatement(sqlUpdate);
         psUpdate.setInt(1, quantityToAdd);
         psUpdate.setInt(2, pid);
         psUpdate.executeUpdate();

         // 2. Lấy giá vốn hiện tại (để lưu vào lịch sử)
         // Giả sử giá nhập = 50% giá bán hiện tại (như logic bạn yêu cầu)
         double currentImportPrice = 0;
         product p = getProductById(pid);
         if (p != null) {
             currentImportPrice = p.getPrice() * 0.5;
         }

         // 3. Ghi vào bảng lịch sử nhập hàng (import_history)
         String sqlHistory = "INSERT INTO import_history (product_id, quantity, import_price, created_at) VALUES (?, ?, ?, NOW())";
         psHistory = conn.prepareStatement(sqlHistory);
         psHistory.setInt(1, pid);
         psHistory.setInt(2, quantityToAdd);
         psHistory.setDouble(3, currentImportPrice); // Lưu giá nhập
         psHistory.executeUpdate();

         conn.commit(); // Xác nhận thành công
         return true;

     } catch (Exception e) {
         e.printStackTrace();
         try { if (conn != null) conn.rollback(); } catch (Exception ex) {}
     } finally {
         // Đóng kết nối
         try { if(psUpdate!=null) psUpdate.close(); if(psHistory!=null) psHistory.close(); if(conn!=null) conn.close(); } catch(Exception e){}
     }
     return false;
 }
}