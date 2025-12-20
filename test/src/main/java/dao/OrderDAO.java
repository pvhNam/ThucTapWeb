package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetail;
import model.cartItem;
import model.product;

public class OrderDAO {
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // 1. Lấy danh sách đơn hàng của 1 User (Cho trang Lịch sử mua hàng)
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setTotalMoney(rs.getDouble("total_money"));
                o.setAddress(rs.getString("address"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getDate("created_at"));
                list.add(o);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Lấy TẤT CẢ đơn hàng (Cho trang Admin)
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        // Kết nối bảng users để lấy tên người mua
        // Cột tên trong bảng users của bạn là 'fullname'
        String sql = "SELECT o.*, u.fullname, u.phonenumber FROM orders o " +
                     "JOIN users u ON o.user_id = u.uid " +
                     "ORDER BY o.created_at DESC"; 
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setTotalMoney(rs.getDouble("total_money"));
                o.setAddress(rs.getString("address"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getDate("created_at"));
                
                // Lấy tên và SĐT khách hàng
                o.setUserName(rs.getString("fullname")); 
                o.setPhoneNumber(rs.getString("phonenumber"));
                
                list.add(o);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 3. Lấy thông tin 1 đơn hàng cụ thể theo ID (Để hiện lên trang chi tiết)
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.fullname, u.phonenumber FROM orders o " +
                     "JOIN users u ON o.user_id = u.uid " +
                     "WHERE o.id = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setTotalMoney(rs.getDouble("total_money"));
                o.setAddress(rs.getString("address"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getDate("created_at"));
                
                o.setUserName(rs.getString("fullname"));
                o.setPhoneNumber(rs.getString("phonenumber"));
                
                return o;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 4. TẠO ĐƠN HÀNG MỚI (Sửa lỗi: Thêm tham số List<cartItem> cart)
    public int createOrder(int userId, double totalMoney, String address, List<cartItem> cart) {
        int orderId = 0;
        try {
            conn = new DBConnect().getConnection();
            
            // A. Lưu bảng ORDERS
            String sqlOrder = "INSERT INTO orders (user_id, total_money, address, status, created_at) VALUES (?, ?, ?, 'Đang xử lý', NOW())";
            ps = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, userId);
            ps.setDouble(2, totalMoney);
            ps.setString(3, address);
            
            if (ps.executeUpdate() > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1); // Lấy ID vừa tạo
                }
            }

            // B. Lưu bảng ORDER_DETAILS (QUAN TRỌNG: Đây là phần bị thiếu trong code cũ của bạn)
            if (orderId > 0 && cart != null) {
                String sqlDetail = "INSERT INTO order_details (order_id, product_id, price, quantity) VALUES (?, ?, ?, ?)";
                ps = conn.prepareStatement(sqlDetail);
                
                for (cartItem item : cart) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, item.getProduct().getPid());
                    ps.setDouble(3, item.getProduct().getPrice());
                    ps.setInt(4, item.getQuantity());
                    ps.addBatch(); // Gom lệnh
                }
                ps.executeBatch(); // Chạy 1 lần
            }
            
        } catch (Exception e) { e.printStackTrace(); }
        return orderId;
    }

    // 5. Cập nhật trạng thái đơn hàng (Cho nút Duyệt/Hủy của Admin)
    public void updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 6. Lấy chi tiết sản phẩm của 1 đơn hàng (Cho trang Xem chi tiết)
    public List<OrderDetail> getDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, p.* FROM order_details d " +
                     "JOIN product p ON d.product_id = p.pid " +
                     "WHERE d.order_id = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            while(rs.next()) {
                product p = new product(
                    rs.getInt("pid"), rs.getString("name"), rs.getDouble("price"),
                    rs.getInt("cateID"), rs.getString("color"), rs.getString("size"),
                    rs.getInt("amount"), rs.getString("img")
                );
                // Giả sử bảng order_details có cột: id, order_id, product_id, price, quantity
                list.add(new OrderDetail(
                    rs.getInt("d.id"), rs.getInt("order_id"), rs.getInt("product_id"),
                    rs.getDouble("d.price"), rs.getInt("d.quantity"), p
                ));
            }
        } catch(Exception e) { e.printStackTrace(); }
        return list;
    }
}