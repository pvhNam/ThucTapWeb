package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Voucher;

public class VoucherDAO {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Lấy TẤT CẢ Voucher công khai để hiển thị trên trang chủ
    public List<Voucher> getAllVouchers() {
        List<Voucher> list = new ArrayList<>();
        // Lấy những mã còn hạn sử dụng hoặc không để ngày hết hạn
        String query = "SELECT * FROM vouchers WHERE is_public = TRUE "
                + "AND (expiry_date >= CURDATE() OR expiry_date IS NULL)";
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Voucher(
                    rs.getInt("id"),
                    rs.getString("code"),
                    rs.getString("description"),
                    rs.getDouble("discount_amount"),
                    rs.getString("discount_type"),
                    rs.getDouble("min_order"),
                    rs.getDate("expiry_date")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy thông tin chi tiết của 1 Voucher dựa vào mã Code
    public Voucher getVoucherByCode(String code) {
        String query = "SELECT * FROM vouchers "
                + "WHERE UPPER(TRIM(code)) = UPPER(?) "
                + "AND (expiry_date >= CURDATE() OR expiry_date IS NULL)";
        try (Connection connection = DBConnect.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, normalizeCode(code));
            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    return mapVoucher(result);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Kiểm tra xem người dùng đã sở hữu Voucher này trong ví chưa 

    public boolean checkUserHasVoucher(int userId, int voucherId) {
        String query = "SELECT 1 FROM user_wallet w JOIN vouchers v ON v.id = w.voucher_id "
                + "WHERE w.user_id = ? AND w.voucher_id = ? AND w.is_used = FALSE "
                + "AND (v.expiry_date >= CURDATE() OR v.expiry_date IS NULL)";
        try (Connection connection = DBConnect.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, userId);
            statement.setInt(2, voucherId);
            try (ResultSet result = statement.executeQuery()) {
                return result.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Voucher getAvailableVoucherForUserByCode(int userId, String code) {
        String query = "SELECT v.* FROM vouchers v "
                + "JOIN user_wallet w ON w.voucher_id = v.id "
                + "WHERE w.user_id = ? AND w.is_used = FALSE "
                + "AND UPPER(TRIM(v.code)) = UPPER(?) "
                + "AND (v.expiry_date >= CURDATE() OR v.expiry_date IS NULL) "
                + "ORDER BY w.id LIMIT 1";
        return findAvailableVoucher(query, userId, normalizeCode(code));
    }

    public Voucher getAvailableVoucherForUserById(int userId, int voucherId) {
        String query = "SELECT v.* FROM vouchers v "
                + "JOIN user_wallet w ON w.voucher_id = v.id "
                + "WHERE w.user_id = ? AND w.is_used = FALSE AND v.id = ? "
                + "AND (v.expiry_date >= CURDATE() OR v.expiry_date IS NULL) "
                + "ORDER BY w.id LIMIT 1";
        return findAvailableVoucher(query, userId, voucherId);
    }

    private Voucher findAvailableVoucher(String query, int userId, Object value) {
        try (Connection connection = DBConnect.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, userId);
            if (value instanceof Integer integerValue) statement.setInt(2, integerValue);
            else statement.setString(2, String.valueOf(value));
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? mapVoucher(result) : null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Lấy danh sách Voucher có trong ví của một người dùng cụ thể 
     */
    public List<Voucher> getVouchersByUid(int uid) {
        List<Voucher> list = new ArrayList<>();
        String query = "SELECT v.* FROM vouchers v " +
                       "JOIN user_wallet w ON v.id = w.voucher_id " +
                       "WHERE w.user_id = ? AND w.is_used = FALSE AND (v.expiry_date >= CURDATE() OR v.expiry_date IS NULL)";
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, uid);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Voucher(
                    rs.getInt("id"),
                    rs.getString("code"),
                    rs.getString("description"),
                    rs.getDouble("discount_amount"),
                    rs.getString("discount_type"),
                    rs.getDouble("min_order"),
                    rs.getDate("expiry_date")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lưu một Voucher vào ví người dùng 
     */
    public boolean saveVoucherToWallet(int userId, int voucherId) {
         String query = "INSERT INTO user_wallet (user_id, voucher_id, is_used) "
                 + "SELECT ?, v.id, FALSE FROM vouchers v "
                 + "WHERE v.id = ? AND (v.expiry_date >= CURDATE() OR v.expiry_date IS NULL) "
                 + "AND NOT EXISTS (SELECT 1 FROM user_wallet w WHERE w.user_id = ? AND w.voucher_id = v.id)";
         try (Connection connection = DBConnect.getConnection();
                 PreparedStatement statement = connection.prepareStatement(query)) {
             statement.setInt(1, userId);
             statement.setInt(2, voucherId);
             statement.setInt(3, userId);
             return statement.executeUpdate() > 0;
         } catch (Exception e) {
             e.printStackTrace();
         }
         return false;
    }

    /**
     * Đánh dấu Voucher đã được sử dụng sau khi thanh toán thành công
     */
    public boolean markVoucherUsed(int userId, int voucherId) {
        String query = "UPDATE user_wallet SET is_used = TRUE "
                + "WHERE user_id = ? AND voucher_id = ? AND is_used = FALSE";
        try (Connection connection = DBConnect.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, userId);
            statement.setInt(2, voucherId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 // Thêm voucher
    public boolean insertVoucher(Voucher v) {
        String query = "INSERT INTO vouchers (code, description, discount_amount, discount_type, min_order, expiry_date) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, v.getCode());
            ps.setString(2, v.getDescription());
            ps.setDouble(3, v.getDiscountAmount());
            ps.setString(4, v.getDiscountType());
            ps.setDouble(5, v.getMinOrder());
            ps.setDate(6, v.getExpiryDate());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    // cập nhật voucher
    public boolean updateVoucher(Voucher v) {
        String query = "UPDATE vouchers SET code=?, description=?, discount_amount=?, discount_type=?, min_order=?, expiry_date=? WHERE id=?";
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, v.getCode());
            ps.setString(2, v.getDescription());
            ps.setDouble(3, v.getDiscountAmount());
            ps.setString(4, v.getDiscountType());
            ps.setDouble(5, v.getMinOrder());
            ps.setDate(6, v.getExpiryDate());
            ps.setInt(7, v.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    // xóa voucher
    public boolean deleteVoucher(int id) {
      
        String query = "DELETE FROM vouchers WHERE id = ?";
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Voucher getVoucherById(int id) {
        String query = "SELECT * FROM vouchers WHERE id = ?";
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new Voucher(
                    rs.getInt("id"), rs.getString("code"), rs.getString("description"),
                    rs.getDouble("discount_amount"), rs.getString("discount_type"),
                    rs.getDouble("min_order"), rs.getDate("expiry_date")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Voucher getPublicVoucherByCode(String code) {
        String query = "SELECT * FROM vouchers WHERE is_public = TRUE "
                + "AND UPPER(TRIM(code)) = UPPER(?) "
                + "AND (expiry_date >= CURDATE() OR expiry_date IS NULL)";
        try (Connection connection = DBConnect.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, normalizeCode(code));
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? mapVoucher(result) : null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private Voucher mapVoucher(ResultSet result) throws Exception {
        return new Voucher(
                result.getInt("id"),
                result.getString("code"),
                result.getString("description"),
                result.getDouble("discount_amount"),
                result.getString("discount_type"),
                result.getDouble("min_order"),
                result.getDate("expiry_date"));
    }

    private String normalizeCode(String code) {
        return code == null ? "" : code.trim().toUpperCase();
    }
}
