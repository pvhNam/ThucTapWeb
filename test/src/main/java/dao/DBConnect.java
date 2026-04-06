package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {

    private static final String url = "jdbc:mysql://gateway01.ap-southeast-1.prod.aws.tidbcloud.com:4000/ltweb?sslMode=VERIFY_IDENTITY&ssl.trustServerCertificate=true";
    
    private static final String user = "SvDW34VUu9Z9zni.root"; 
    
    private static final String pass = "9Bn4n3LyABc9LFGt"; 

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);
            System.out.println("Kết nối TiDB thành công!");
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