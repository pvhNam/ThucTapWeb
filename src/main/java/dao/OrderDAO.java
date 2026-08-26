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
        return createOrderInternal(userId, totalMoney, address, paymentMethod, status, cart, false);
    }

    public int createOrderAndDecreaseStock(int userId, double totalMoney, String address, String paymentMethod,
            List<CartItem> cart) {
        return createOrderInternal(userId, totalMoney, address, paymentMethod,
                Order.STATUS_PROCESSING, cart, true);
    }

    private int createOrderInternal(int userId, double totalMoney, String address, String paymentMethod, String status,
            List<CartItem> cart, boolean decreaseStock) {
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
                String sqlDetail = "INSERT INTO order_details "
                        + "(order_id, product_id, price, quantity, color, size) VALUES (?, ?, ?, ?, ?, ?)";
                psDetail = connection.prepareStatement(sqlDetail);

                for (CartItem item : cart) {
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, item.getProduct().getPid());
                    psDetail.setDouble(3, item.getProduct().getPrice());
                    psDetail.setInt(4, item.getQuantity());
                    psDetail.setString(5, normalizeVariantValue(item.getColor()));
                    psDetail.setString(6, normalizeVariantValue(item.getSize()));
                    psDetail.addBatch();
                }
                psDetail.executeBatch();

                if (decreaseStock) {
                    for (CartItem item : cart) {
                        decreaseStock(connection, item.getProduct().getPid(), item.getColor(), item.getSize(),
                                item.getQuantity());
                    }
                }
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

    /**
     * Completes a MoMo order and decreases every selected variant in one transaction.
     * Repeated callbacks are idempotent and do not decrease inventory twice.
     */
    public boolean finalizeMomoPayment(int orderId) {
        Connection connection = null;
        try {
            connection = DBConnect.getConnection();
            connection.setAutoCommit(false);

            String currentStatus = null;
            try (PreparedStatement lockOrder = connection.prepareStatement(
                    "SELECT status FROM orders WHERE id = ? FOR UPDATE")) {
                lockOrder.setInt(1, orderId);
                try (ResultSet orderResult = lockOrder.executeQuery()) {
                    if (orderResult.next()) {
                        currentStatus = orderResult.getString("status");
                    }
                }
            }

            if (Order.STATUS_PAID_PROCESSING.equals(currentStatus)) {
                connection.commit();
                return true;
            }
            if (!Order.STATUS_PENDING_MOMO.equals(currentStatus)) {
                connection.rollback();
                return false;
            }

            List<StockLine> stockLines = new ArrayList<>();
            try (PreparedStatement details = connection.prepareStatement(
                    "SELECT product_id, quantity, color, size FROM order_details WHERE order_id = ? ORDER BY id")) {
                details.setInt(1, orderId);
                try (ResultSet detailResult = details.executeQuery()) {
                    while (detailResult.next()) {
                        stockLines.add(new StockLine(
                                detailResult.getInt("product_id"),
                                detailResult.getInt("quantity"),
                                detailResult.getString("color"),
                                detailResult.getString("size")));
                    }
                }
            }

            if (stockLines.isEmpty()) {
                throw new SQLException("Order has no details");
            }
            for (StockLine line : stockLines) {
                decreaseStock(connection, line.productId, line.color, line.size, line.quantity);
            }

            try (PreparedStatement update = connection.prepareStatement(
                    "UPDATE orders SET status = ? WHERE id = ? AND status = ?")) {
                update.setString(1, Order.STATUS_PAID_PROCESSING);
                update.setInt(2, orderId);
                update.setString(3, Order.STATUS_PENDING_MOMO);
                if (update.executeUpdate() != 1) {
                    throw new SQLException("Order status changed while completing payment");
                }
            }

            connection.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (connection != null) connection.rollback();
            } catch (SQLException rollbackError) {
                rollbackError.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.setAutoCommit(true);
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private void decreaseStock(Connection connection, int productId, String color, String size, int quantity)
            throws SQLException {
        if (quantity <= 0) {
            throw new SQLException("Invalid order quantity");
        }

        int variantId = 0;
        int variantStock = 0;
        String normalizedColor = normalizeVariantValue(color);
        String normalizedSize = normalizeVariantValue(size);
        try (PreparedStatement variant = connection.prepareStatement(
                "SELECT id, stock_quantity FROM product_variants "
                        + "WHERE product_id = ? AND color = ? AND size = ? ORDER BY id LIMIT 1 FOR UPDATE")) {
            variant.setInt(1, productId);
            variant.setString(2, normalizedColor);
            variant.setString(3, normalizedSize);
            try (ResultSet result = variant.executeQuery()) {
                if (result.next()) {
                    variantId = result.getInt("id");
                    variantStock = result.getInt("stock_quantity");
                }
            }
        }

        if (variantId > 0) {
            if (variantStock < quantity) {
                throw new SQLException("Insufficient variant stock for product " + productId);
            }
            try (PreparedStatement updateVariant = connection.prepareStatement(
                    "UPDATE product_variants SET stock_quantity = stock_quantity - ? WHERE id = ?")) {
                updateVariant.setInt(1, quantity);
                updateVariant.setInt(2, variantId);
                if (updateVariant.executeUpdate() != 1) {
                    throw new SQLException("Unable to update variant stock for product " + productId);
                }
            }
            try (PreparedStatement syncProduct = connection.prepareStatement(
                    "UPDATE product SET amount = (SELECT COALESCE(SUM(stock_quantity), 0) "
                            + "FROM product_variants WHERE product_id = ?) WHERE pid = ?")) {
                syncProduct.setInt(1, productId);
                syncProduct.setInt(2, productId);
                syncProduct.executeUpdate();
            }
            return;
        }

        try (PreparedStatement updateLegacy = connection.prepareStatement(
                "UPDATE product SET amount = amount - ? WHERE pid = ? AND amount >= ? "
                        + "AND NOT EXISTS (SELECT 1 FROM product_variants WHERE product_id = ?)")) {
            updateLegacy.setInt(1, quantity);
            updateLegacy.setInt(2, productId);
            updateLegacy.setInt(3, quantity);
            updateLegacy.setInt(4, productId);
            if (updateLegacy.executeUpdate() != 1) {
                throw new SQLException("Invalid variant or insufficient stock for product " + productId);
            }
        }
    }

    private String normalizeVariantValue(String value) {
        return value == null ? "" : value.trim();
    }

    private static class StockLine {
        private final int productId;
        private final int quantity;
        private final String color;
        private final String size;

        private StockLine(int productId, int quantity, String color, String size) {
            this.productId = productId;
            this.quantity = quantity;
            this.color = color;
            this.size = size;
        }
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
        String sql = "SELECT d.id AS detail_id, d.order_id, d.product_id, "
                + "d.price AS detail_price, d.quantity AS detail_quantity, "
                + "d.color AS detail_color, d.size AS detail_size, p.* FROM order_details d "
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
                        rs.getInt("detail_id"),
                        rs.getInt("order_id"),
                        rs.getInt("product_id"),
                        rs.getDouble("detail_price"),
                        rs.getInt("detail_quantity"),
                        rs.getString("detail_color"),
                        rs.getString("detail_size"),
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
