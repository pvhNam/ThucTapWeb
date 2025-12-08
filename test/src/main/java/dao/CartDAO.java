package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.cartItem;
import model.product;

public class CartDAO {

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // 1. Lấy danh sách giỏ hàng của User từ Database
    public List<cartItem> getCartByUid(int uid) {
        List<cartItem> list = new ArrayList<>();
        // Join bảng cart với bảng product để lấy đầy đủ thông tin hiển thị
        String query = "SELECT c.quantity, p.* FROM cart c " +
                       "JOIN product p ON c.product_id = p.pid " +
                       "WHERE c.user_id = ?";
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, uid);
            rs = ps.executeQuery();
            while (rs.next()) {
                // Tạo đối tượng Product từ dữ liệu DB
                product p = new product(
                    rs.getInt("pid"),
                    rs.getString("name"), // Lưu ý: Tên cột phải khớp với DB của bạn (name/pdescription)
                    rs.getDouble("price"),
                    rs.getInt("cateID"),
                    rs.getString("color"),
                    rs.getString("size"),
                    rs.getInt("amount"),
                    rs.getString("img")
                );
                
                int quantity = rs.getInt("quantity");
                
                // Thêm vào list kết quả
                list.add(new cartItem(p, quantity));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Thêm sản phẩm vào giỏ (Logic: Có rồi thì cộng dồn, chưa có thì thêm mới)
    public void addToCart(int uid, int pid, int quantity) {
        String checkQuery = "SELECT quantity FROM cart WHERE user_id = ? AND product_id = ?";
        try {
            conn = DBConnect.getConnection();
            
            // Kiểm tra xem user này đã thêm sản phẩm này chưa
            ps = conn.prepareStatement(checkQuery);
            ps.setInt(1, uid);
            ps.setInt(2, pid);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // TRƯỜNG HỢP 1: Đã có -> Cộng dồn số lượng
                int oldQty = rs.getInt("quantity");
                int newQty = oldQty + quantity;
                
                String updateQuery = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
                PreparedStatement psUpdate = conn.prepareStatement(updateQuery);
                psUpdate.setInt(1, newQty);
                psUpdate.setInt(2, uid);
                psUpdate.setInt(3, pid);
                psUpdate.executeUpdate();
            } else {
                // TRƯỜNG HỢP 2: Chưa có -> Insert dòng mới
                String insertQuery = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
                PreparedStatement psInsert = conn.prepareStatement(insertQuery);
                psInsert.setInt(1, uid);
                psInsert.setInt(2, pid);
                psInsert.setInt(3, quantity);
                psInsert.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 3. Cập nhật số lượng (khi bấm nút + - trong giỏ hàng)
    public void updateQuantity(int uid, int pid, int quantity) {
        String query = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, quantity);
            ps.setInt(2, uid);
            ps.setInt(3, pid);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 4. Xóa sản phẩm khỏi giỏ
    public void removeItem(int uid, int pid) {
        String query = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, uid);
            ps.setInt(2, pid);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}