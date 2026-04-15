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

    // Lấy danh sách đơn hàng của User (Cho trang Lịch sử mua hàng)
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
                o.setUserId(rs.getInt("user_id"));
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

    // Lấy TẤT CẢ đơn hàng (Cho trang Admin )
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

    // Lấy chi tiết 1 đơn hàng theo ID
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

    // TẠO ĐƠN HÀNG MỚI
    public int createOrder(int userId, double totalMoney, String address, String paymentMethod, List<cartItem> cart) {
        int orderId = 0;
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;

        try {
            conn = new DBConnect().getConnection(); 
            conn.setAutoCommit(false); 
            // Insert vào bảng ORDERS
            String sqlOrder = "INSERT INTO orders (user_id, total_money, address, status, created_at, payment_method) VALUES (?, ?, ?, 'Đang xử lý', NOW(), ?)";
            
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setDouble(2, totalMoney);
            psOrder.setString(3, address);
            psOrder.setString(4, paymentMethod);

            if (psOrder.executeUpdate() > 0) {
                ResultSet rsKeys = psOrder.getGeneratedKeys();
                if (rsKeys.next()) {
                    orderId = rsKeys.getInt(1); // Lấy ID đơn hàng vừa tạo
                }
            }
            // Insert chi tiết sản phẩm vào bảng ORDER_DETAILS
            if (orderId > 0 && cart != null) {
                String sqlDetail = "INSERT INTO order_details (order_id, product_id, price, quantity) VALUES (?, ?, ?, ?)";
                psDetail = conn.prepareStatement(sqlDetail);

                for (cartItem item : cart) {
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, item.getProduct().getPid());
                    psDetail.setDouble(3, item.getProduct().getPrice()); // Lưu giá tại thời điểm mua
                    psDetail.setInt(4, item.getQuantity());
                    psDetail.addBatch(); // Gom nhóm để chạy 1 lần cho nhanh
                }
                psDetail.executeBatch();
            }
            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback(); // Nếu có lỗi thì hoàn tác (không tạo đơn hàng lỗi)
            } catch (SQLException ex) { ex.printStackTrace(); }
            orderId = 0;
        } finally {
            // Đóng kết nối
            try {
                if (psOrder != null) psOrder.close();
                if (psDetail != null) psDetail.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Trả về trạng thái mặc định
                    conn.close();
                }
            } catch (Exception e) {}
        }
        return orderId;
    }

    // Cập nhật trạng thái đơn hàng (Dùng cho Admin: Giao hàng, Hủy...)
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

    // Lấy danh sách sản phẩm trong 1 đơn hàng (Để hiển thị trang chi tiết)
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
                // Tạo đối tượng Product
                product p = new product(rs.getInt("pid"), rs.getString("name"), rs.getDouble("price"),
                        rs.getInt("cateID"), rs.getString("color"), rs.getString("size"), rs.getInt("amount"),
                        rs.getString("img"));
                
                // Tạo đối tượng OrderDetail
                list.add(new OrderDetail(
                        rs.getInt("d.id"), 
                        rs.getInt("order_id"), 
                        rs.getInt("product_id"),
                        rs.getDouble("d.price"), 
                        rs.getInt("d.quantity"), 
                        p
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}