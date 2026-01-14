package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.math.BigInteger;

public class MD5 {
    
    public static String getMd5(String input) {
        try {
            // Gọi thuật toán MD5
            MessageDigest md = MessageDigest.getInstance("MD5");
            
            // Tính toán message digest từ input
            byte[] messageDigest = md.digest(input.getBytes());
            
            // Chuyển mảng byte thành BigInteger
            BigInteger no = new BigInteger(1, messageDigest);
            
            // Chuyển thành mã Hex (hệ 16)
            String hashtext = no.toString(16);
            
            // Thêm các số 0 ở đầu nếu chưa đủ 32 ký tự
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}