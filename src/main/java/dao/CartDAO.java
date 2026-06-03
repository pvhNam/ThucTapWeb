package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.CartItem;
import model.Product;

public class CartDAO {
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;

	// Lấy danh sách giỏ hàng (Đã thêm color, size)
	public List<CartItem> getCartByUid(int uid) {
		List<CartItem> list = new ArrayList<>();
		String query = "SELECT c.quantity, c.color as cart_color, c.size as cart_size, p.* FROM cart c JOIN product p ON c.product_id = p.pid WHERE c.user_id = ?";
		try {
			conn = DBConnect.getConnection();
			ps = conn.prepareStatement(query);
			ps.setInt(1, uid);
			rs = ps.executeQuery();
			while (rs.next()) {
				Product p = new Product(rs.getInt("pid"), rs.getString("name"), rs.getDouble("price"),
						rs.getInt("cateID"), rs.getString("color"), rs.getString("size"), rs.getInt("amount"),
						rs.getString("img"));
				int quantity = rs.getInt("quantity");
				String cColor = rs.getString("cart_color");
				String cSize = rs.getString("cart_size");
				list.add(new CartItem(p, quantity, cColor, cSize));
			}
		} catch (Exception e) { e.printStackTrace(); }
		return list;
	}

	// Thêm vào giỏ (Kiểm tra trùng id + màu + size)
	public void addToCart(int uid, int pid, String color, String size, int quantity) {
		String checkQuery = "SELECT quantity FROM cart WHERE user_id = ? AND product_id = ? AND color = ? AND size = ?";
		try {
			conn = DBConnect.getConnection();
			ps = conn.prepareStatement(checkQuery);
			ps.setInt(1, uid);
			ps.setInt(2, pid);
			ps.setString(3, color != null ? color : "");
			ps.setString(4, size != null ? size : "");
			rs = ps.executeQuery();

			if (rs.next()) {
				int newQty = rs.getInt("quantity") + quantity;
				String updateQuery = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ? AND color = ? AND size = ?";
				PreparedStatement psUpdate = conn.prepareStatement(updateQuery);
				psUpdate.setInt(1, newQty);
				psUpdate.setInt(2, uid);
				psUpdate.setInt(3, pid);
				psUpdate.setString(4, color != null ? color : "");
				psUpdate.setString(5, size != null ? size : "");
				psUpdate.executeUpdate();
			} else {
				String insertQuery = "INSERT INTO cart (user_id, product_id, color, size, quantity) VALUES (?, ?, ?, ?, ?)";
				PreparedStatement psInsert = conn.prepareStatement(insertQuery);
				psInsert.setInt(1, uid);
				psInsert.setInt(2, pid);
				psInsert.setString(3, color != null ? color : "");
				psInsert.setString(4, size != null ? size : "");
				psInsert.setInt(5, quantity);
				psInsert.executeUpdate();
			}
		} catch (Exception e) { e.printStackTrace(); }
	}

	// Cập nhật số lượng
	public void updateQuantity(int uid, int pid, String color, String size, int quantity) {
		String query = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ? AND color = ? AND size = ?";
		try {
			conn = DBConnect.getConnection();
			ps = conn.prepareStatement(query);
			ps.setInt(1, quantity);
			ps.setInt(2, uid);
			ps.setInt(3, pid);
			ps.setString(4, color != null ? color : "");
			ps.setString(5, size != null ? size : "");
			ps.executeUpdate();
		} catch (Exception e) { e.printStackTrace(); }
	}

	// Xóa sản phẩm
	public void removeItem(int uid, int pid, String color, String size) {
		String query = "DELETE FROM cart WHERE user_id = ? AND product_id = ? AND color = ? AND size = ?";
		try {
			conn = DBConnect.getConnection();
			ps = conn.prepareStatement(query);
			ps.setInt(1, uid);
			ps.setInt(2, pid);
			ps.setString(3, color != null ? color : "");
			ps.setString(4, size != null ? size : "");
			ps.executeUpdate();
		} catch (Exception e) { e.printStackTrace(); }
	}

	public void clearCart(int uid) {
		String query = "DELETE FROM cart WHERE user_id = ?";
		try {
			conn = DBConnect.getConnection();
			ps = conn.prepareStatement(query);
			ps.setInt(1, uid);
			ps.executeUpdate();
		} catch (Exception e) { e.printStackTrace(); }
	}
}