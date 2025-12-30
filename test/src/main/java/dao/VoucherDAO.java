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

    /**
     * 1. Lấy TẤT CẢ Voucher công khai để hiển thị trên trang chủ
     * Dựa trên cấu trúc bảng: id, code, description, discount_amount, discount_type, min_order, expiry_date
     */
    public List<Voucher> getAllVouchers() {
        List<Voucher> list = new ArrayList<>();
        // Lấy những mã còn hạn sử dụng hoặc không để ngày hết hạn
        String query = "SELECT * FROM vouchers WHERE expiry_date >= CURDATE() OR expiry_date IS NULL";
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

    /**
     * 2. Lấy thông tin chi tiết của 1 Voucher dựa vào mã Code
     */
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

    /**
     * 3. Kiểm tra xem người dùng đã sở hữu Voucher này trong ví chưa (và chưa dùng)
     */
    public boolean checkUserHasVoucher(int userId, int voucherId) {
        String query = "SELECT * FROM user_wallet WHERE user_id = ? AND voucher_id = ? AND is_used = FALSE";
        try {
            conn = DBConnect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            ps.setInt(2, voucherId);
            rs = ps.executeQuery();
            if (rs.next()) return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 4. Lấy danh sách Voucher có trong ví của một người dùng cụ thể (chưa dùng và còn hạn)
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
     * 5. Lưu một Voucher vào ví người dùng (khi nhấn nút "Lưu mã")
     */
    public boolean saveVoucherToWallet(int userId, int voucherId) {
         if(checkUserHasVoucher(userId, voucherId)) return false;
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

    /**
     * 6. Đánh dấu Voucher đã được sử dụng sau khi thanh toán thành công
     */
    public void markVoucherUsed(int userId, int voucherId) {
        String query = "UPDATE user_wallet SET is_used = TRUE WHERE user_id = ? AND voucher_id = ?";
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