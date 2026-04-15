package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.CartItem;
import model.Order;
import model.OrderDetail;
import model.Product;

public class OrderDAO {

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

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
                list.add(mapOrder(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

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
                return mapOrder(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int createOrder(int userId, double totalMoney, String address, String paymentMethod, List<CartItem> cart) {
        return createOrder(userId, totalMoney, address, paymentMethod, Order.STATUS_PROCESSING, cart);
    }

    public int createOrder(int userId, double totalMoney, String address, String paymentMethod, String status,
            List<CartItem> cart) {
        int orderId = 0;
        Connection connection = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;

        try {
            connection = new DBConnect().getConnection();
            connection.setAutoCommit(false);

            String sqlOrder = "INSERT INTO orders (user_id, total_money, address, status, created_at, payment_method) "
                    + "VALUES (?, ?, ?, ?, NOW(), ?)";

            psOrder = connection.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setDouble(2, totalMoney);
            psOrder.setString(3, address);
            psOrder.setString(4, status);
            psOrder.setString(5, paymentMethod);

            if (psOrder.executeUpdate() > 0) {
                try (ResultSet rsKeys = psOrder.getGeneratedKeys()) {
                    if (rsKeys.next()) {
                        orderId = rsKeys.getInt(1);
                    }
                }
            }

            if (orderId > 0 && cart != null && !cart.isEmpty()) {
                String sqlDetail = "INSERT INTO order_details (order_id, product_id, price, quantity) VALUES (?, ?, ?, ?)";
                psDetail = connection.prepareStatement(sqlDetail);

                for (CartItem item : cart) {
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, item.getProduct().getPid());
                    psDetail.setDouble(3, item.getProduct().getPrice());
                    psDetail.setInt(4, item.getQuantity());
                    psDetail.addBatch();
                }
                psDetail.executeBatch();
            }

            connection.commit();
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            orderId = 0;
        } finally {
            try {
                if (psOrder != null) {
                    psOrder.close();
                }
                if (psDetail != null) {
                    psDetail.close();
                }
                if (connection != null) {
                    connection.setAutoCommit(true);
                    connection.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return orderId;
    }

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

    public boolean updateOrderStatusIfCurrent(int orderId, String currentStatus, String newStatus) {
        String sql = "UPDATE orders SET status = ? WHERE id = ? AND status = ?";
        try (Connection connection = DBConnect.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, newStatus);
            statement.setInt(2, orderId);
            statement.setString(3, currentStatus);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

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
                Product p = new Product(
                        rs.getInt("pid"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getInt("cateID"),
                        rs.getString("color"),
                        rs.getString("size"),
                        rs.getInt("amount"),
                        rs.getString("img"));

                list.add(new OrderDetail(
                        rs.getInt("d.id"),
                        rs.getInt("order_id"),
                        rs.getInt("product_id"),
                        rs.getDouble("d.price"),
                        rs.getInt("d.quantity"),
                        p));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Order mapOrder(ResultSet resultSet) throws SQLException {
        Order order = new Order();
        order.setId(resultSet.getInt("id"));
        order.setUserId(resultSet.getInt("user_id"));
        order.setTotalMoney(resultSet.getDouble("total_money"));
        order.setAddress(resultSet.getString("address"));
        order.setStatus(resultSet.getString("status"));
        order.setCreatedAt(resultSet.getDate("created_at"));
        order.setPaymentMethod(resultSet.getString("payment_method"));

        try {
            order.setUserName(resultSet.getString("fullname"));
        } catch (SQLException ignored) {
        }

        try {
            order.setPhoneNumber(resultSet.getString("phonenumber"));
        } catch (SQLException ignored) {
        }

        return order;
    }
}
