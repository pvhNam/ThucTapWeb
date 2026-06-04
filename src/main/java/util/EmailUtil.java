package util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtil {
    public static void sendEmail(String toEmail, String subject, String body) {
        // Cấu hình email gửi đi
        final String fromEmail = "phamvanhoain@gmail.com"; 
        final String password = "emmbwlykemvfrmwy"; // Mật khẩu ứng dụng (App Password)

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); 
        props.put("mail.smtp.port", "587"); 
        props.put("mail.smtp.auth", "true"); 
        props.put("mail.smtp.starttls.enable", "true"); 
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        // Tạo phiên làm việc (Session)
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail));
            msg.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            msg.setSubject(subject, "UTF-8");
            msg.setText(body, "UTF-8");

            Transport.send(msg);
            System.out.println("Gửi email thành công tới: " + toEmail);
        } catch (MessagingException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi gửi email: " + e.getMessage());
        }
    }
}