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

	public user login(String username, String password) {
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
				System.out.println("Đã tìm thấy user trong DB: " + rs.getString("username"));

				return new user(rs.getInt("uid"), rs.getString("username"), rs.getString("password"),
						rs.getString("email"), rs.getString("fullname"), rs.getString("phonenumber"));
			} else {
				System.out.println("LỖI LOGIC: Không tìm thấy dòng nào khớp với user/pass này trong bảng users.");
			}
		} catch (Exception e) {
			System.out.println("LỖI NGOẠI LỆ (EXCEPTION): " + e.getMessage());
			e.printStackTrace();
		}
		return null;
	}

	// Cập nhật hàm checkUserExist
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
		} catch (Exception e) {
		}
		return null;
	}

	// Cập nhật hàm register
	public void register(String user, String pass, String email, String fullname, String phone) {

		String query = "INSERT INTO users (username, password, email, fullname, phonenumber) VALUES (?, ?, ?, ?, ?)";

		try {
			conn = new DBConnect().getConnection();
			// Kiểm tra kết nối
			if (conn == null) {
				System.out.println("LỖI: chưa kết nối được Database!");
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
				System.out.println("Đăng ký thành công!");
			} else {
				System.out.println("Đăng ký không thành công! ");
			}

		} catch (Exception e) {
			System.out.println("LỖI KHI ĐĂNG KÝ: " + e.getMessage());
			e.printStackTrace();
		}

	}

	// 1. Hàm cập nhật thông tin chung
	public boolean updateUserInfo(user u) {
		String sql = "UPDATE users SET fullname = ?, email = ?, phone = ? WHERE username = ?";
		try {
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

	// Hàm đổi mật khẩu
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
	// Lấy tất cả danh sách khách hàng
    public List<user> getAllUsers() {
        List<user> list = new ArrayList<>();
        // Lưu ý: Tên bảng trong DB là `users` hoặc `user` (nếu là user thì nên để trong dấu backtick `user`)
        String query = "SELECT * FROM users"; 
        
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                // Khởi tạo đối tượng theo đúng Constructor trong model.user của bạn
                // Thứ tự: uid, uname, passwordHash, email, fullname, phonenumber
                list.add(new user(
                    rs.getInt("uid"),              // uid
                    rs.getString("username"),      // uname
                    rs.getString("password"),      // passwordHash (Tên cột trong DB có thể là password)
                    rs.getString("email"),         // email
                    rs.getString("fullname"),      // fullname
                    rs.getString("phonenumber")   // phonenumber (Kiểm tra tên cột trong DB của bạn)
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Xóa user theo UID
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
}