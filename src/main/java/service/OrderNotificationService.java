package service;

import java.text.NumberFormat;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.LoyaltyReward;
import model.Membership;
import model.Order;
import util.EmailUtil;

public class OrderNotificationService {
    private static final Logger LOGGER = Logger.getLogger(OrderNotificationService.class.getName());
    private final SmsWebhookClient smsClient = new SmsWebhookClient();

    public void notifyOrderPlaced(Order order) {
        notify(order, "Don hang #" + order.getId() + " da duoc tiep nhan",
                "Trang thai: " + order.getDisplayStatus() + ". Chung toi se thong bao khi don hang thay doi.");
    }

    public void notifyStatusChanged(Order order, LoyaltyReward reward) {
        StringBuilder details = new StringBuilder("Trang thai moi: ")
                .append(order.getDisplayStatus()).append('.');
        if (reward != null && reward.isNewlyIssued()) {
            details.append(" Voucher tri an 100.000 VND: ").append(reward.getVoucherCode()).append('.');
            Membership membership = reward.getMembership();
            if (membership != null && membership.isMember()) {
                details.append(" Hang thanh vien: ").append(membership.getTierLabel())
                        .append(" - giam ").append((int) membership.getDiscountPercent())
                        .append("% cho cac hoa don tiep theo.");
            }
        }
        notify(order, "Cap nhat don hang #" + order.getId(), details.toString());
    }

    private void notify(Order order, String subject, String details) {
        if (order == null) return;
        String money = NumberFormat.getNumberInstance(new Locale("vi", "VN")).format(order.getTotalMoney());
        String message = subject + "\n"
                + "Tong thanh toan: " + money + " VND\n"
                + details;

        String email = normalize(order.getContactEmail());
        String phone = normalize(order.getContactPhone());
        if (email != null) {
            try {
                EmailUtil.sendEmail(email, subject, message);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Unable to send order email for order " + order.getId(), e);
            }
        }
        if (phone != null) {
            if (!smsClient.isConfigured()) {
                LOGGER.warning("SMS webhook is not configured; order SMS was skipped for order " + order.getId());
            } else {
                try {
                    smsClient.send(phone, message.replace('\n', ' '));
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Unable to send order SMS for order " + order.getId(), e);
                }
            }
        }
    }

    private String normalize(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }
}
