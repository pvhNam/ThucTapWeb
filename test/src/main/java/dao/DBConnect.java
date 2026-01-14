package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {
    private static final String url = "jdbc:mysql://localhost:3306/ltweb?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String user = "admin"; 
    private static final String pass = "2123"; 

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);
            System.out.println("Kết nối CSDL thành công!");
        } catch (Exception e) {
            System.out.println("Kết nối thất bại!");
            e.printStackTrace();
        }
        return conn;
    }
    
    // test
public static void main(String[] args) {
	getConnection();
}
}
