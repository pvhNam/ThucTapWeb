package service;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class VnpayService {
    private static final String VERSION = "2.1.0";
    private static final DateTimeFormatter VNPAY_DATE_FORMAT = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
    private static final Pattern TRANSACTION_REFERENCE = Pattern.compile("^FS(\\d+)V(\\d+)$");

    private final String tmnCode;
    private final String hashSecret;
    private final String paymentUrl;
    private final String configuredReturnUrl;
    private final Properties localSettings;

    public VnpayService() {
        localSettings = loadLocalSettings();
        tmnCode = readRequiredSetting("vnpay.tmnCode", "VNPAY_TMN_CODE");
        hashSecret = readRequiredSetting("vnpay.hashSecret", "VNPAY_HASH_SECRET");
        paymentUrl = readSetting("vnpay.paymentUrl", "VNPAY_PAYMENT_URL",
                "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html");
        configuredReturnUrl = readSetting("vnpay.returnUrl", "VNPAY_RETURN_URL", "");
    }

    public String createPaymentUrl(long amountVnd, String transactionReference, String orderInfo,
            String fallbackReturnUrl, String clientIp, String locale) throws Exception {
        if (amountVnd <= 0 || amountVnd > 9_999_999_999L) {
            throw new IllegalArgumentException("VNPay amount is outside the supported range.");
        }
        if (!TRANSACTION_REFERENCE.matcher(transactionReference).matches()) {
            throw new IllegalArgumentException("Invalid VNPay transaction reference.");
        }

        String returnUrl = configuredReturnUrl.isBlank() ? fallbackReturnUrl : configuredReturnUrl;
        if (returnUrl == null || returnUrl.isBlank()) {
            throw new IllegalArgumentException("VNPay return URL is required.");
        }

        ZonedDateTime createdAt = ZonedDateTime.now(java.time.ZoneId.of("Asia/Ho_Chi_Minh"));
        Map<String, String> parameters = new TreeMap<>();
        parameters.put("vnp_Version", VERSION);
        parameters.put("vnp_Command", "pay");
        parameters.put("vnp_TmnCode", tmnCode);
        parameters.put("vnp_Amount", Math.multiplyExact(amountVnd, 100L) + "");
        parameters.put("vnp_CurrCode", "VND");
        parameters.put("vnp_TxnRef", transactionReference);
        parameters.put("vnp_OrderInfo", orderInfo);
        parameters.put("vnp_OrderType", "other");
        parameters.put("vnp_Locale", "en".equalsIgnoreCase(locale) ? "en" : "vn");
        parameters.put("vnp_ReturnUrl", returnUrl);
        parameters.put("vnp_IpAddr", normalizeIpAddress(clientIp));
        parameters.put("vnp_CreateDate", createdAt.format(VNPAY_DATE_FORMAT));
        parameters.put("vnp_ExpireDate", createdAt.plusMinutes(15).format(VNPAY_DATE_FORMAT));

        String query = buildCanonicalQuery(parameters);
        String secureHash = hmacSha512(query, hashSecret);
        return paymentUrl + "?" + query + "&vnp_SecureHash=" + secureHash;
    }

    public boolean isValidResponseSignature(Map<String, String> responseParameters) throws Exception {
        if (responseParameters == null || responseParameters.isEmpty()) {
            return false;
        }

        String providedHash = responseParameters.get("vnp_SecureHash");
        if (providedHash == null || providedHash.isBlank()
                || !tmnCode.equals(responseParameters.get("vnp_TmnCode"))) {
            return false;
        }

        Map<String, String> signedParameters = new TreeMap<>();
        for (Map.Entry<String, String> entry : responseParameters.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            if (key != null && key.startsWith("vnp_")
                    && !"vnp_SecureHash".equals(key)
                    && !"vnp_SecureHashType".equals(key)
                    && value != null && !value.isEmpty()) {
                signedParameters.put(key, value);
            }
        }

        String expectedHash = hmacSha512(buildCanonicalQuery(signedParameters), hashSecret);
        return MessageDigest.isEqual(
                expectedHash.getBytes(StandardCharsets.US_ASCII),
                providedHash.toLowerCase(Locale.ROOT).getBytes(StandardCharsets.US_ASCII));
    }

    public String createTransactionReference(int orderId, int voucherId) {
        if (orderId <= 0 || voucherId < 0) {
            throw new IllegalArgumentException("Invalid order or voucher id.");
        }
        return "FS" + orderId + "V" + voucherId;
    }

    public int extractOrderId(String transactionReference) {
        Matcher matcher = transactionReference == null ? null : TRANSACTION_REFERENCE.matcher(transactionReference);
        if (matcher == null || !matcher.matches()) {
            return 0;
        }
        return parsePositiveInt(matcher.group(1));
    }

    public int extractVoucherId(String transactionReference) {
        Matcher matcher = transactionReference == null ? null : TRANSACTION_REFERENCE.matcher(transactionReference);
        if (matcher == null || !matcher.matches()) {
            return 0;
        }
        return parsePositiveInt(matcher.group(2));
    }

    private String buildCanonicalQuery(Map<String, String> parameters) {
        StringBuilder query = new StringBuilder();
        for (Map.Entry<String, String> entry : new TreeMap<>(parameters).entrySet()) {
            if (entry.getValue() == null || entry.getValue().isEmpty()) {
                continue;
            }
            if (query.length() > 0) {
                query.append('&');
            }
            query.append(urlEncode(entry.getKey())).append('=').append(urlEncode(entry.getValue()));
        }
        return query.toString();
    }

    private String urlEncode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    private String hmacSha512(String data, String key) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA512");
        mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
        byte[] digest = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder result = new StringBuilder(digest.length * 2);
        for (byte value : digest) {
            result.append(String.format("%02x", value));
        }
        return result.toString();
    }

    private String normalizeIpAddress(String clientIp) {
        if (clientIp == null || clientIp.isBlank()) {
            return "127.0.0.1";
        }
        String firstAddress = clientIp.split(",", 2)[0].trim();
        if (firstAddress.length() < 7 || firstAddress.length() > 45
                || !firstAddress.matches("[0-9a-fA-F:.]+")) {
            return "127.0.0.1";
        }
        return firstAddress;
    }

    private int parsePositiveInt(String value) {
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String readRequiredSetting(String propertyKey, String envKey) {
        String value = readSetting(propertyKey, envKey, "");
        if (value.isBlank()) {
            throw new IllegalStateException("Missing VNPay configuration: " + envKey);
        }
        return value;
    }

    private String readSetting(String propertyKey, String envKey, String defaultValue) {
        String value = System.getProperty(propertyKey);
        if (value == null || value.isBlank()) {
            value = System.getenv(envKey);
        }
        if (value == null || value.isBlank()) {
            value = localSettings.getProperty(propertyKey);
        }
        if (value == null || value.isBlank()) {
            value = localSettings.getProperty(envKey);
        }
        return value == null || value.isBlank() ? defaultValue : value.trim();
    }

    private Properties loadLocalSettings() {
        Properties settings = new Properties();
        String configuredPath = System.getProperty("vnpay.configFile");
        if (configuredPath == null || configuredPath.isBlank()) {
            configuredPath = System.getenv("VNPAY_CONFIG_FILE");
        }

        Path configPath = configuredPath == null || configuredPath.isBlank()
                ? Path.of(System.getProperty("user.home"), ".thuctapweb", "vnpay.properties")
                : Path.of(configuredPath.trim());

        if (!Files.isRegularFile(configPath)) {
            return settings;
        }
        try (InputStream input = Files.newInputStream(configPath)) {
            settings.load(input);
        } catch (IOException e) {
            throw new IllegalStateException("Cannot read local VNPay configuration.", e);
        }
        return settings;
    }
}
