package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.News;

public class NewsDAO {
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;

	//Thêm tin tức
	public boolean addNews(News n) {
		String sql = "INSERT INTO news (title, short_desc, content, image, created_at) VALUES (?, ?, ?, ?, NOW())";
		try {
			conn = DBConnect.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, n.getTitle());
			ps.setString(2, n.getShortDesc());
			ps.setString(3, n.getContent());
			ps.setString(4, n.getImage());
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	//Lấy tất cả tin tức
	public List<News> getAllNews() {
		List<News> list = new ArrayList<>();
		String sql = "SELECT * FROM news ORDER BY created_at DESC";
		try {
			conn = DBConnect.getConnection();
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while (rs.next()) {
				list.add(new News(rs.getInt("id"), rs.getString("title"), rs.getString("short_desc"),
						rs.getString("content"), rs.getString("image"), rs.getDate("created_at")));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	//Lấy 1 tin tức theo ID (để sửa)
	public News getNewsById(int id) {
		String sql = "SELECT * FROM news WHERE id = ?";
		try {
			conn = DBConnect.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			rs = ps.executeQuery();
			if (rs.next()) {
				return new News(rs.getInt("id"), rs.getString("title"), rs.getString("short_desc"),
						rs.getString("content"), rs.getString("image"), rs.getDate("created_at"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// Cập nhật tin tức
	public boolean updateNews(News n) {
		String sql = "UPDATE news SET title=?, short_desc=?, content=?, image=? WHERE id=?";
		try {
			conn = DBConnect.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, n.getTitle());
			ps.setString(2, n.getShortDesc());
			ps.setString(3, n.getContent());
			ps.setString(4, n.getImage());
			ps.setInt(5, n.getId());
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	// Xóa tin tức
	public void deleteNews(int id) {
		String sql = "DELETE FROM news WHERE id=?";
		try { 	 	
			conn = DBConnect.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}