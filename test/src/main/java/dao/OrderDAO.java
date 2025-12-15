package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Order;
// Import class kết nối DB của bạn ở đây

public class OrderDAO {
    
    // Hàm lấy danh sách đơn hàng của 1 user cụ thể
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC"; // Lấy đơn mới nhất lên đầu
        
        try {
            // Giả sử bạn có hàm lấy connection
            Connection conn = new DBConnect().getConnection(); // Thay bằng cách lấy connection của bạn
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setTotalMoney(rs.getDouble("total_money"));
                o.setAddress(rs.getString("address"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getDate("created_at"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public int createOrder(int userId, double totalMoney, String address) {
        int orderId = 0;
        String sql = "INSERT INTO orders (user_id, total_money, address, status, created_at) VALUES (?, ?, ?, 'Đang xử lý', NOW())";
        
        try {
            Connection conn = new DBConnect().getConnection();
            // RETURN_GENERATED_KEYS để lấy lại cái ID tự tăng của đơn hàng vừa tạo
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, userId);
            ps.setDouble(2, totalMoney);
            ps.setString(3, address);
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1); // Lấy ID của đơn hàng vừa chèn
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderId;
    }
}