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

    // 1. LOGIN
    public user login(String username, String password) {
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new user(rs.getInt("uid"), rs.getString("username"), rs.getString("password"),
                        rs.getString("email"), rs.getString("fullname"), rs.getString("phonenumber"),
                        rs.getString("avatar"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 2. REGISTER
    public void register(String user, String pass, String email, String fullname, String phone) {
        String query = "INSERT INTO users (username, password, email, fullname, phonenumber, is_admin) VALUES (?, ?, ?, ?, ?, 0)";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, user);
            ps.setString(2, pass);
            ps.setString(3, email);
            ps.setString(4, fullname);
            ps.setString(5, phone);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 3. CHECK USER EXIST
    public user checkUserExist(String username) {
        String query = "SELECT * FROM users WHERE username = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new user(rs.getInt("uid"), rs.getString("username"), rs.getString("password"),
                        rs.getString("email"), rs.getString("fullname"), rs.getString("phonenumber"),
                        rs.getString("avatar"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 4. CHECK EMAIL EXIST
    public user checkEmailExist(String email) {
        String query = "SELECT * FROM users WHERE email = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new user(rs.getInt("uid"), rs.getString("username"), rs.getString("password"),
                        rs.getString("email"), rs.getString("fullname"), rs.getString("phonenumber"),
                        rs.getString("avatar"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 5. CHANGE PASSWORD
    public boolean changePassword(String username, String newPassword) {
        String query = "UPDATE users SET password = ? WHERE username = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, newPassword);
            ps.setString(2, username);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // --- [QUAN TRỌNG] HÀM NÀY ĐỂ SỬA LỖI BẠN ĐANG GẶP ---
    // 6. UPDATE USER INFO (Nhận vào đối tượng user)
    public boolean updateUserInfo(user u) {
        String sql = "UPDATE users SET fullname = ?, email = ?, phonenumber = ? WHERE uid = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, u.getFullname());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPhonenumber());
            ps.setInt(4, u.getUid());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Hàm update cũ (giữ lại để tránh lỗi ở chỗ khác nếu có dùng)
    public void updateUser(int uid, String email, String fullname, String phone) {
        String query = "UPDATE users SET email=?, fullname=?, phonenumber=? WHERE uid=?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, fullname);
            ps.setString(3, phone);
            ps.setInt(4, uid);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 7. UPDATE AVATAR
    public boolean updateAvatar(int uid, String filename) {
        String sql = "UPDATE users SET avatar = ? WHERE uid = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, filename);
            ps.setInt(2, uid);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 8. GET ALL USERS
    public List<user> getAllUsers() {
        List<user> list = new ArrayList<>();
        String query = "SELECT * FROM users";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new user(rs.getInt("uid"), rs.getString("username"), rs.getString("password"),
                        rs.getString("email"), rs.getString("fullname"), rs.getString("phonenumber"),
                        rs.getString("avatar")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 9. SEARCH USERS
    public List<user> searchUsers(String keyword) {
        List<user> list = new ArrayList<>();
        String query = "SELECT * FROM users WHERE username LIKE ? OR fullname LIKE ? OR email LIKE ? OR phonenumber LIKE ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new user(rs.getInt("uid"), rs.getString("username"), rs.getString("password"),
                        rs.getString("email"), rs.getString("fullname"), rs.getString("phonenumber"),
                        rs.getString("avatar")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 10. DELETE USER
    public void deleteUser(int uid) {
        String query = "DELETE FROM users WHERE uid = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, uid);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 11. GET USER BY ID
    public user getUserById(int uid) {
        String query = "SELECT * FROM users WHERE uid = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, uid);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new user(rs.getInt("uid"), rs.getString("username"), rs.getString("password"),
                        rs.getString("email"), rs.getString("fullname"), rs.getString("phonenumber"),
                        rs.getString("avatar"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}