package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.product;

public class ProductDAO {

	// 1. Lấy tất cả sản phẩm
	public List<product> getAllProducts() {
		List<product> list = new ArrayList<>();
		String sql = "SELECT * FROM product";
		try (Connection conn = DBConnect.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				list.add(new product(rs.getInt("pid"), rs.getString("name"), rs.getDouble("price"), rs.getInt("cateID"),
						rs.getString("color"), rs.getString("size"), rs.getInt("amount"), rs.getString("img")));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public product getProductById(int pid) {
		String sql = "SELECT * FROM product WHERE pid = ?";
		try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, pid);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return new product(rs.getInt("pid"), rs.getString("name"), rs.getDouble("price"),
							rs.getInt("cateID"), rs.getString("color"), rs.getString("size"), rs.getInt("amount"),
							rs.getString("img"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// THÊM SẢN PHẨM MỚI
	public boolean addProduct(product p) {
		String sql = "INSERT INTO product (name, price, cateID, color, size, amount, img) VALUES (?, ?, ?, ?, ?, ?, ?)";

		try {
			Connection conn = DBConnect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, p.getPdescription());
			ps.setDouble(2, p.getPrice());
			ps.setInt(3, p.getCid());
			ps.setString(4, p.getColor());
			ps.setString(5, p.getSize());
			ps.setInt(6, p.getStockquantyti());
			ps.setString(7, p.getImage());

			int row = ps.executeUpdate();
			return row > 0;
		} catch (Exception e) {
			System.out.println("Lỗi SQL: " + e.getMessage());
			e.printStackTrace();
		}
		return false;
	}

	// Cập nhật sản phẩm
	public boolean updateProduct(product p) {
		String sql = "UPDATE product SET name=?, price=?, cateID=?, color=?, size=?, amount=?, img=? WHERE pid=?";
		try {
			Connection conn = DBConnect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, p.getPdescription());
			ps.setDouble(2, p.getPrice());
			ps.setInt(3, p.getCid());
			ps.setString(4, p.getColor());
			ps.setString(5, p.getSize());
			ps.setInt(6, p.getStockquantyti());
			ps.setString(7, p.getImage());
			ps.setInt(8, p.getPid());

			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	// Xóa sản phẩm
	public void deleteProduct(int pid) {
		String sql = "DELETE FROM product WHERE pid=?";
		try {
			Connection conn = DBConnect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, pid);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// Trừ tồn kho
	public void decreaseStock(int pid, int quantity) {
		// Sửa tên cột amount
		String sql = "UPDATE product SET amount = amount - ? WHERE pid = ? AND amount >= ?";
		try {
			Connection conn = DBConnect.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, quantity);
			ps.setInt(2, pid);
			ps.setInt(3, quantity);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}