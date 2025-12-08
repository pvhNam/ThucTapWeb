package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.user;

public class UserDAO {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    public user login(String username, String password) {
        // Lưu ý: Tên cột phải khớp 100% với ảnh SQL bạn gửi (username, password)
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        
        try {
            conn = new DBConnect().getConnection();
            if (conn == null) {
                System.out.println("LỖI: Kết nối CSDL thất bại (conn is null)!");
                return null;
            }

            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Tìm thấy user -> In ra để kiểm tra
                System.out.println("Đã tìm thấy user trong DB: " + rs.getString("username"));
                
                return new user(
                    rs.getInt("uid"),
                    rs.getString("username"), // Cột trong DB là username
                    rs.getString("password"),
                    rs.getString("email"),
                    rs.getString("fullname"),
                    rs.getString("phonenumber") // SỬA: Lấy String, không ép kiểu int nữa
                );
            } else {
                System.out.println("LỖI LOGIC: Không tìm thấy dòng nào khớp với user/pass này trong bảng users.");
            }
        } catch (Exception e) {
            System.out.println("LỖI NGOẠI LỆ (EXCEPTION): " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật hàm checkUserExist cho khớp
    public user checkUserExist(String username) {
        String query = "SELECT * FROM users WHERE username = ?";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new user(rs.getInt("uid"), rs.getString("username"), "", "", "", "");
            }
        } catch (Exception e) {}
        return null;
    }
    
    // Cập nhật hàm register cho khớp
    public void register(String user, String pass, String email, String fullname, String phone) {
        // 1. Kiểm tra câu lệnh SQL: Tên cột phải KHỚP 100% với Database
        // Trong ảnh bạn gửi, cột tên là: username, password, email, fullname, phonenumber
        String query = "INSERT INTO users (username, password, email, fullname, phonenumber) VALUES (?, ?, ?, ?, ?)";
        
        try {
            conn = new DBConnect().getConnection();
            
            // Kiểm tra kết nối
            if (conn == null) {
                System.out.println("LỖI: Conn bị Null, chưa kết nối được Database!");
                return;
            }

            ps = conn.prepareStatement(query);
            ps.setString(1, user);
            ps.setString(2, pass);
            ps.setString(3, email);
            ps.setString(4, fullname);
            ps.setString(5, phone);
            
            // 2. Thực thi lệnh
            int row = ps.executeUpdate();
            if (row > 0) {
                System.out.println("Đăng ký thành công! Đã thêm vào DB.");
            } else {
                System.out.println("Không thêm được dòng nào vào DB.");
            }
            
        } catch (Exception e) {
            // QUAN TRỌNG: In lỗi ra để biết tại sao không lưu được
            System.out.println("LỖI KHI ĐĂNG KÝ: " + e.getMessage());
            e.printStackTrace();
        }
    
    }
 // 1. Hàm cập nhật thông tin chung
    public boolean updateUserInfo(user u) {
        String sql = "UPDATE users SET fullname = ?, email = ?, phone = ? WHERE username = ?";
        try {
            // Giả sử bạn có hàm kết nối connection tên là conn
            PreparedStatement ps = conn.prepareStatement(sql);
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

    // 2. Hàm đổi mật khẩu
    public boolean changePassword(String username, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE username = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setString(2, username);
            
            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}