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

    // Lấy thông tin Voucher
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

    // Kiểm tra sở hữu
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

    //Lấy danh sách voucher của user
    public List<Voucher> getVouchersByUid(int uid) {
        List<Voucher> list = new ArrayList<>();
        String query = "SELECT v.* FROM vouchers v " +
                       "JOIN user_wallet w ON v.id = w.voucher_id " +
                       "WHERE w.user_id = ? AND w.is_used = FALSE AND v.expiry_date >= CURDATE()";
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
    
    //Lưu voucher
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

    //Đánh dấu voucher đã sử dụng 
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