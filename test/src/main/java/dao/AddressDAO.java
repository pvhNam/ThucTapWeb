package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Address;

public class AddressDAO {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    //Lấy danh sách địa chỉ của User
    public List<Address> getAddressesByUserId(int userId) {
        List<Address> list = new ArrayList<>();
        String query = "SELECT * FROM Address WHERE user_id = ? ORDER BY is_default DESC, id DESC";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Address(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("receiver_name"),
                        rs.getString("phone"),
                        rs.getString("specific_address"),
                        rs.getString("ward"),
                        rs.getString("district"),
                        rs.getString("city"),
                        rs.getBoolean("is_default")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //Lấy địa chỉ mặc định để tự động hiển thị ở giỏ hàng
    public Address getDefaultAddressByUserId(int userId) {
        String query = "SELECT * FROM Address WHERE user_id = ? ORDER BY is_default DESC LIMIT 1";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new Address(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("receiver_name"),
                        rs.getString("phone"),
                        rs.getString("specific_address"),
                        rs.getString("ward"),
                        rs.getString("district"),
                        rs.getString("city"),
                        rs.getBoolean("is_default")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //Thêm địa chỉ mới
    public void insertAddress(Address addr) {
        String query = "INSERT INTO Address (user_id, receiver_name, phone, specific_address, ward, district, city, is_default) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            conn = new DBConnect().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, addr.getUserId());
            ps.setString(2, addr.getReceiverName());
            ps.setString(3, addr.getPhone());
            ps.setString(4, addr.getSpecificAddress());
            ps.setString(5, addr.getWard());
            ps.setString(6, addr.getDistrict());
            ps.setString(7, addr.getCity());
            ps.setBoolean(8, addr.isDefault());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}