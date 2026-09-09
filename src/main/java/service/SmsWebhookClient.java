package service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

import org.json.JSONObject;

public class SmsWebhookClient {
    private final HttpClient client = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(5))
            .build();

    public boolean isConfigured() {
        return !readSetting("order.sms.webhook", "ORDER_SMS_WEBHOOK", "").isBlank();
    }

    public void send(String phoneNumber, String message) throws Exception {
        String webhook = readSetting("order.sms.webhook", "ORDER_SMS_WEBHOOK", "");
        if (webhook.isBlank()) {
            throw new IllegalStateException("ORDER_SMS_WEBHOOK is not configured");
        }

        JSONObject payload = new JSONObject()
                .put("to", phoneNumber)
                .put("message", message);
        HttpRequest.Builder request = HttpRequest.newBuilder(URI.create(webhook))
                .timeout(Duration.ofSeconds(10))
                .header("Content-Type", "application/json; charset=UTF-8")
                .POST(HttpRequest.BodyPublishers.ofString(payload.toString(), StandardCharsets.UTF_8));

        String token = readSetting("order.sms.webhookToken", "ORDER_SMS_WEBHOOK_TOKEN", "");
        if (!token.isBlank()) {
            request.header("Authorization", "Bearer " + token);
        }

        HttpResponse<String> response = client.send(request.build(), HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IllegalStateException("SMS webhook returned HTTP " + response.statusCode());
        }
    }

    private String readSetting(String propertyName, String environmentName, String fallback) {
        String value = System.getProperty(propertyName);
        if (value == null || value.isBlank()) value = System.getenv(environmentName);
        return value == null || value.isBlank() ? fallback : value.trim();
    }
}
