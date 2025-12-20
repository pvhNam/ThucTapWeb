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
				// Mapping: Cột DB -> Java Class
				list.add(new product(rs.getInt("pid"), rs.getString("name"), // DB là "name" -> Java là pdescription
						rs.getDouble("price"), rs.getInt("cateID"), rs.getString("color"), rs.getString("size"),
						rs.getInt("amount"), // DB là "amount" -> Java là stockquantyti
						rs.getString("img") // DB là "img" -> Java là image
				));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// 2. Lấy chi tiết sản phẩm theo ID
	public product getProductById(int pid) {
		String sql = "SELECT * FROM product WHERE pid = ?";
		try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, pid);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return new product(rs.getInt("pid"), rs.getString("name"), // Sửa thành "name"
							rs.getDouble("price"), rs.getInt("cateID"), rs.getString("color"), rs.getString("size"),
							rs.getInt("amount"), // Sửa thành "amount"
							rs.getString("img") // Sửa thành "img"
					);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// 3. THÊM SẢN PHẨM MỚI (QUAN TRỌNG: CÂU SQL PHẢI DÙNG TÊN CỘT DB)
	// Trong file ProductDAO.java
    public boolean addProduct(product p) {
        // CÂU LỆNH SQL CHUẨN THEO ẢNH DATABASE CỦA BẠN:
        String sql = "INSERT INTO product (name, price, cateID, color, size, amount, img) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            
            // Mapping dữ liệu:
            ps.setString(1, p.getPdescription()); // Java là pdescription -> Lưu vào cột 'name'
            ps.setDouble(2, p.getPrice());
            ps.setInt(3, p.getCid());
            ps.setString(4, p.getColor());
            ps.setString(5, p.getSize());
            ps.setInt(6, p.getStockquantyti());   // Java là stockquantyti -> Lưu vào cột 'amount'
            ps.setString(7, p.getImage());        // Java là image -> Lưu vào cột 'img'
            
            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

	// 4. Cập nhật sản phẩm
	public boolean updateProduct(product p) {
		// SQL dùng tên cột trong MySQL
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

	// 5. Xóa sản phẩm
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

	// 6. Trừ tồn kho
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