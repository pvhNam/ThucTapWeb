package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;

import model.LoyaltyReward;
import model.Membership;
import model.Order;
import service.LoyaltyPolicy;

public class LoyaltyDAO {
    private static final double REWARD_AMOUNT = 100_000d;
    private static final int REWARD_VALID_DAYS = 60;

    public Membership getMembership(int userId) {
        String sql = "SELECT tier, lifetime_spend, discount_percent "
                + "FROM customer_memberships WHERE user_id = ?";
        try (Connection connection = DBConnect.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    return LoyaltyPolicy.membershipFor(userId, result.getDouble("lifetime_spend"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Membership.standard(userId);
    }

    /**
     * Issues the 100,000 VND reward and refreshes membership exactly once per
     * completed order. The unique order reward and row locks make retries safe.
     */
    public LoyaltyReward processCompletedOrder(int orderId) {
        Connection connection = null;
        try {
            connection = DBConnect.getConnection();
            connection.setAutoCommit(false);

            OrderOwner order = lockCompletedOrder(connection, orderId);
            if (order == null) {
                connection.rollback();
                return null;
            }

            ensureMembershipRow(connection, order.userId);
            lockMembership(connection, order.userId);

            ExistingReward existingReward = findExistingReward(connection, orderId);
            double lifetimeSpend = calculateLifetimeSpend(connection, order.userId);
            Membership membership = upsertMembership(connection, order.userId, lifetimeSpend);

            if (existingReward != null) {
                connection.commit();
                return new LoyaltyReward(false, existingReward.voucherCode, membership);
            }

            String voucherCode = "THANKS100K-U" + order.userId + "-O" + orderId;
            int voucherId = createRewardVoucher(connection, voucherCode);
            addVoucherToWallet(connection, order.userId, voucherId);
            insertRewardAudit(connection, orderId, order.userId, voucherId);

            connection.commit();
            return new LoyaltyReward(true, voucherCode, membership);
        } catch (Exception e) {
            e.printStackTrace();
            rollbackQuietly(connection);
            return null;
        } finally {
            closeQuietly(connection);
        }
    }

    private OrderOwner lockCompletedOrder(Connection connection, int orderId) throws SQLException {
        String sql = "SELECT user_id, status FROM orders WHERE id = ? FOR UPDATE";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, orderId);
            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) {
                    return null;
                }
                Order order = new Order();
                order.setStatus(result.getString("status"));
                if (!order.isSuccessStatus()) {
                    return null;
                }
                return new OrderOwner(result.getInt("user_id"));
            }
        }
    }

    private void ensureMembershipRow(Connection connection, int userId) throws SQLException {
        String sql = "INSERT INTO customer_memberships "
                + "(user_id, tier, lifetime_spend, discount_percent) VALUES (?, 'STANDARD', 0, 0) "
                + "ON DUPLICATE KEY UPDATE user_id = VALUES(user_id)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.executeUpdate();
        }
    }

    private void lockMembership(Connection connection, int userId) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(
                "SELECT user_id FROM customer_memberships WHERE user_id = ? FOR UPDATE")) {
            statement.setInt(1, userId);
            try (ResultSet ignored = statement.executeQuery()) {
                if (!ignored.next()) {
                    throw new SQLException("Unable to lock customer membership");
                }
            }
        }
    }

    private ExistingReward findExistingReward(Connection connection, int orderId) throws SQLException {
        String sql = "SELECT v.code FROM loyalty_order_rewards r "
                + "JOIN vouchers v ON v.id = r.voucher_id WHERE r.order_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, orderId);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? new ExistingReward(result.getString("code")) : null;
            }
        }
    }

    private double calculateLifetimeSpend(Connection connection, int userId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_money), 0) AS lifetime_spend FROM orders "
                + "WHERE user_id = ? AND (status = ? OR LOWER(status) IN ('success', 'completed'))";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setString(2, Order.STATUS_SUCCESS);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? result.getDouble("lifetime_spend") : 0;
            }
        }
    }

    private Membership upsertMembership(Connection connection, int userId, double lifetimeSpend) throws SQLException {
        Membership membership = LoyaltyPolicy.membershipFor(userId, lifetimeSpend);

        String sql = "UPDATE customer_memberships SET tier = ?, lifetime_spend = ?, discount_percent = ? "
                + "WHERE user_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, membership.getTier());
            statement.setDouble(2, lifetimeSpend);
            statement.setDouble(3, membership.getDiscountPercent());
            statement.setInt(4, userId);
            if (statement.executeUpdate() != 1) {
                throw new SQLException("Unable to update customer membership");
            }
        }
        return membership;
    }

    private int createRewardVoucher(Connection connection, String voucherCode) throws SQLException {
        String sql = "INSERT INTO vouchers "
                + "(code, description, discount_amount, discount_type, min_order, expiry_date, is_public) "
                + "VALUES (?, ?, ?, 'FIXED', ?, ?, FALSE)";
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, voucherCode);
            statement.setString(2, "Tri an khach hang sau khi hoan tat don hang");
            statement.setDouble(3, REWARD_AMOUNT);
            statement.setDouble(4, REWARD_AMOUNT);
            statement.setDate(5, Date.valueOf(LocalDate.now().plusDays(REWARD_VALID_DAYS)));
            if (statement.executeUpdate() != 1) {
                throw new SQLException("Unable to create loyalty voucher");
            }
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new SQLException("Missing generated loyalty voucher id");
                }
                return keys.getInt(1);
            }
        }
    }

    private void addVoucherToWallet(Connection connection, int userId, int voucherId) throws SQLException {
        String sql = "INSERT INTO user_wallet (user_id, voucher_id, is_used) VALUES (?, ?, FALSE)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, voucherId);
            if (statement.executeUpdate() != 1) {
                throw new SQLException("Unable to add loyalty voucher to wallet");
            }
        }
    }

    private void insertRewardAudit(Connection connection, int orderId, int userId, int voucherId) throws SQLException {
        String sql = "INSERT INTO loyalty_order_rewards (order_id, user_id, voucher_id) VALUES (?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, orderId);
            statement.setInt(2, userId);
            statement.setInt(3, voucherId);
            if (statement.executeUpdate() != 1) {
                throw new SQLException("Unable to save loyalty reward audit");
            }
        }
    }

    private void rollbackQuietly(Connection connection) {
        if (connection == null) return;
        try {
            connection.rollback();
        } catch (SQLException ignored) {
        }
    }

    private void closeQuietly(Connection connection) {
        if (connection == null) return;
        try {
            connection.setAutoCommit(true);
            connection.close();
        } catch (SQLException ignored) {
        }
    }

    private static final class OrderOwner {
        private final int userId;

        private OrderOwner(int userId) {
            this.userId = userId;
        }
    }

    private static final class ExistingReward {
        private final String voucherCode;

        private ExistingReward(String voucherCode) {
            this.voucherCode = voucherCode;
        }
    }
}
