package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Voucher;

public class VoucherDAO {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // 1. Tìm voucher theo mã code (Ví dụ: WELCOME10)
    public Voucher getVoucherByCode(String code) {
        String query = "SELECT * FROM vouchers WHERE code = ?";
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, code);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new Voucher(
                    rs.getInt("id"),
                    rs.getString("code"),
                    rs.getString("description"),
                    rs.getDouble("discount_amount"),
                    rs.getString("discount_type"),
                    rs.getDouble("min_order"),
                    rs.getDate("expiry_date")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 2. Kiểm tra người dùng đã lưu mã này chưa (tránh lưu trùng)
    public boolean checkUserHasVoucher(int userId, int voucherId) {
        String query = "SELECT * FROM user_wallet WHERE user_id = ? AND voucher_id = ?";
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            ps.setInt(2, voucherId);
            rs = ps.executeQuery();
            if (rs.next()) return true; // Đã có
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Lưu voucher vào ví (Chức năng Save)
    public boolean saveVoucherToWallet(int userId, int voucherId) {
        if (checkUserHasVoucher(userId, voucherId)) {
            return false; // Đã có rồi thì không lưu nữa
        }
        String query = "INSERT INTO user_wallet (user_id, voucher_id, is_used) VALUES (?, ?, FALSE)";
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            ps.setInt(2, voucherId);
            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Xóa voucher khỏi ví (hoặc đánh dấu đã dùng) - Gọi hàm này khi Thanh toán thành công
    public void markVoucherUsed(int userId, int voucherId) {
        // Cách 1: Xóa hẳn (Mất sau khi dùng)
        String query = "DELETE FROM user_wallet WHERE user_id = ? AND voucher_id = ?";
        
        // Cách 2: Nếu muốn giữ lịch sử thì dùng UPDATE set is_used = TRUE
        // String query = "UPDATE user_wallet SET is_used = TRUE WHERE user_id = ? AND voucher_id = ?";
        
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            ps.setInt(2, voucherId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}