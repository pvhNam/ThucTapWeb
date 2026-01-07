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

    // 1. Lấy danh sách đơn hàng của User
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy TẤT CẢ đơn hàng (Admin)
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.fullname, u.phonenumber FROM orders o " 
                   + "JOIN users u ON o.user_id = u.uid "
                   + "ORDER BY o.created_at DESC";
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
                o.setUserName(rs.getString("fullname"));
                o.setPhoneNumber(rs.getString("phonenumber"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Lấy chi tiết 1 đơn hàng
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.fullname, u.phonenumber FROM orders o " 
                   + "JOIN users u ON o.user_id = u.uid "
                   + "WHERE o.id = ?";
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 4. TẠO ĐƠN HÀNG MỚI (Dùng Transaction để an toàn dữ liệu)
    public int createOrder(int userId, double totalMoney, String address, List<cartItem> cart) {
        int orderId = 0;
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;

        try {
            conn = new DBConnect().getConnection();
            // BẮT ĐẦU TRANSACTION
            conn.setAutoCommit(false); 

            // Bước 1: Insert vào bảng ORDERS
            String sqlOrder = "INSERT INTO orders (user_id, total_money, address, status, created_at) VALUES (?, ?, ?, 'Đang xử lý', NOW())";
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setDouble(2, totalMoney);
            psOrder.setString(3, address);

            if (psOrder.executeUpdate() > 0) {
                ResultSet rsKeys = psOrder.getGeneratedKeys();
                if (rsKeys.next()) {
                    orderId = rsKeys.getInt(1);
                }
            }

            // Bước 2: Insert vào bảng ORDER_DETAILS
            if (orderId > 0 && cart != null) {
                String sqlDetail = "INSERT INTO order_details (order_id, product_id, price, quantity) VALUES (?, ?, ?, ?)";
                psDetail = conn.prepareStatement(sqlDetail);

                for (cartItem item : cart) {
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, item.getProduct().getPid());
                    psDetail.setDouble(3, item.getProduct().getPrice());
                    psDetail.setInt(4, item.getQuantity());
                    psDetail.addBatch(); // Gom nhóm
                }
                psDetail.executeBatch(); // Chạy 1 lần
            }

            // CAM KẾT GIAO DỊCH (Lưu vào DB)
            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback(); // Nếu lỗi thì hoàn tác
            } catch (SQLException ex) { ex.printStackTrace(); }
            orderId = 0;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
        return orderId;
    }

    // 5. Cập nhật trạng thái
    public void updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 6. Lấy danh sách sản phẩm trong đơn hàng
    public List<OrderDetail> getDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, p.* FROM order_details d " 
                   + "JOIN product p ON d.product_id = p.pid "
                   + "WHERE d.order_id = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            while (rs.next()) {
                product p = new product(rs.getInt("pid"), rs.getString("name"), rs.getDouble("price"),
                        rs.getInt("cateID"), rs.getString("color"), rs.getString("size"), rs.getInt("amount"),
                        rs.getString("img"));
                list.add(new OrderDetail(rs.getInt("d.id"), rs.getInt("order_id"), rs.getInt("product_id"),
                        rs.getDouble("d.price"), rs.getInt("d.quantity"), p));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}