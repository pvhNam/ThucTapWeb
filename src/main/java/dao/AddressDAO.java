package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Address;

public class AddressDAO {

    public List<Address> getAddressesByUserId(int userId) {
        List<Address> list = new ArrayList<>();
        String query = "SELECT * FROM address WHERE user_id = ? ORDER BY is_default DESC, id DESC";

        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAddress(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Address getDefaultAddressByUserId(int userId) {
        String query = "SELECT * FROM address WHERE user_id = ? ORDER BY is_default DESC LIMIT 1";

        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAddress(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Address getAddressByIdAndUserId(int addressId, int userId) {
        String query = "SELECT * FROM address WHERE id = ? AND user_id = ?";

        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, addressId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAddress(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void insertAddress(Address addr) {
        if (addr.isDefault()) {
            clearDefaultAddress(addr.getUserId());
        }

        String query = "INSERT INTO address "
                + "(user_id, receiver_name, phone, specific_address, ward, district, city, is_default) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
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

    public void updateAddress(Address addr) {
        if (addr.isDefault()) {
            clearDefaultAddress(addr.getUserId());
        }

        String query = "UPDATE address SET receiver_name = ?, phone = ?, specific_address = ?, "
                + "ward = ?, district = ?, city = ?, is_default = ? "
                + "WHERE id = ? AND user_id = ?";

        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, addr.getReceiverName());
            ps.setString(2, addr.getPhone());
            ps.setString(3, addr.getSpecificAddress());
            ps.setString(4, addr.getWard());
            ps.setString(5, addr.getDistrict());
            ps.setString(6, addr.getCity());
            ps.setBoolean(7, addr.isDefault());
            ps.setInt(8, addr.getId());
            ps.setInt(9, addr.getUserId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteAddress(int addressId, int userId) {
        String query = "DELETE FROM address WHERE id = ? AND user_id = ?";

        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, addressId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void clearDefaultAddress(int userId) {
        String query = "UPDATE address SET is_default = false WHERE user_id = ?";

        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Address mapAddress(ResultSet rs) throws SQLException {
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
}
