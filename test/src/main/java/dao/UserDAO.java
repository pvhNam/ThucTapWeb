package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.user;

public class UserDAO {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Hàm Login: Tham số password ở đây mong đợi là chuỗi ĐÃ MÃ HÓA từ Controller
    public user login(String username, String password) {
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        try {
            conn = new DBConnect().getConnection();
            if (conn == null) return null;

            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password); // So sánh hash với hash trong DB
            rs = ps.executeQuery();

            if (rs.next()) {
                return new user(
                    rs.getInt("uid"), 
                    rs.getString("username"), 
                    rs.getString("password"),
                    rs.getString("email"), 
                    rs.getString("fullname"), 
                    rs.getString("phonenumber"),
                    rs.getString("avatar")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Kiểm tra user tồn tại
    public user checkUserExist(String username) {
        String query = "SELECT * FROM users WHERE username = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new user(rs.getInt("uid"), rs.getString("username"), "", "", "", "","");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Đăng ký: password nhận vào phải là MÃ HÓA
    public void register(String user, String pass, String email, String fullname, String phone) {
        String query = "INSERT INTO users (username, password, email, fullname, phonenumber) VALUES (?, ?, ?, ?, ?)";
        try {
            conn = new DBConnect().getConnection();
            if (conn == null) return;

            ps = conn.prepareStatement(query);
            ps.setString(1, user);
            ps.setString(2, pass); // Lưu hash vào cột password
            ps.setString(3, email);
            ps.setString(4, fullname);
            ps.setString(5, phone);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Cập nhật thông tin
    public boolean updateUserInfo(user u) {
        String sql = "UPDATE users SET fullname = ?, email = ?, phone = ? WHERE username = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, u.getFullname());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPhonenumber());
            ps.setString(4, u.getUsername());

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đổi mật khẩu
    public boolean changePassword(String username, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE username = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword); // newPassword này cũng cần phải được hash ở Controller trước khi truyền vào
            ps.setString(2, username);

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy tất cả user
    public List<user> getAllUsers() {
        List<user> list = new ArrayList<>();
        String query = "SELECT * FROM users"; 
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new user(
                    rs.getInt("uid"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("email"),
                    rs.getString("fullname"),
                    rs.getString("phonenumber"),
                    rs.getString("avatar")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Xóa user
    public void deleteUser(int uid) {
        String query = "DELETE FROM users WHERE uid = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, uid);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public boolean updateAvatar(int uid, String filename) {
        String sql = "UPDATE users SET avatar = ? WHERE uid = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, filename);
            ps.setInt(2, uid);
            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}