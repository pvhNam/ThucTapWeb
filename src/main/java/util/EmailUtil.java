package util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtil {
    public static void sendEmail(String toEmail, String subject, String body) {
        // Cấu hình email gửi đi
        final String username = readSetting("mail.smtp.username", "SMTP_USERNAME", "");
        final String password = readSetting("mail.smtp.password", "SMTP_PASSWORD", "");
        final String fromEmail = readSetting("mail.smtp.from", "SMTP_FROM", username);
        if (isBlank(toEmail)) {
            throw new IllegalArgumentException("Recipient email is required");
        }
        if (isBlank(username) || isBlank(password) || isBlank(fromEmail)) {
            throw new IllegalStateException(
                    "SMTP is not configured. Set SMTP_USERNAME, SMTP_PASSWORD and optionally SMTP_FROM.");
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", readSetting("mail.smtp.host", "SMTP_HOST", "smtp.gmail.com"));
        props.put("mail.smtp.port", readSetting("mail.smtp.port", "SMTP_PORT", "587"));
        props.put("mail.smtp.auth", "true"); 
        props.put("mail.smtp.starttls.enable", "true"); 
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        // Tạo phiên làm việc (Session)
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
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

    public static boolean isConfigured() {
        return !isBlank(readSetting("mail.smtp.username", "SMTP_USERNAME", ""))
                && !isBlank(readSetting("mail.smtp.password", "SMTP_PASSWORD", ""));
    }

    private static String readSetting(String propertyName, String environmentName, String fallback) {
        String value = System.getProperty(propertyName);
        if (isBlank(value)) value = System.getenv(environmentName);
        return isBlank(value) ? fallback : value.trim();
    }

    private static boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
}
