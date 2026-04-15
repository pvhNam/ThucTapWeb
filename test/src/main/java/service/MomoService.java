package service;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.UUID;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.json.JSONObject;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class MomoService {
    private static final MediaType JSON_MEDIA_TYPE = MediaType.get("application/json; charset=utf-8");

    private final String partnerCode = readSetting("momo.partnerCode", "MOMO_PARTNER_CODE", "MOMO");
    private final String accessKey = readSetting("momo.accessKey", "MOMO_ACCESS_KEY", "F8BBA842ECF85");
    private final String secretKey = readSetting("momo.secretKey", "MOMO_SECRET_KEY", "K951B6PE1waDMi640xX08PD3vg6EkVlz");
    private final String endpoint = readSetting("momo.endpoint", "MOMO_ENDPOINT",
            "https://test-payment.momo.vn/v2/gateway/api/create");
    private final OkHttpClient client = new OkHttpClient();

    public String createPayment(long amount, String orderId, String orderInfo, String redirectUrl, String ipnUrl,
            String extraData) throws Exception {
        String requestType = "payWithMethod";
        String requestId = UUID.randomUUID().toString();
        String safeExtraData = extraData == null ? "" : extraData;

        String rawSignature = "accessKey=" + accessKey
                + "&amount=" + amount
                + "&extraData=" + safeExtraData
                + "&ipnUrl=" + ipnUrl
                + "&orderId=" + orderId
                + "&orderInfo=" + orderInfo
                + "&partnerCode=" + partnerCode
                + "&redirectUrl=" + redirectUrl
                + "&requestId=" + requestId
                + "&requestType=" + requestType;

        String signature = hmacSha256(rawSignature, secretKey);

        JSONObject message = new JSONObject();
        message.put("partnerCode", partnerCode);
        message.put("partnerName", "Fashion Store");
        message.put("storeId", "FashionStore");
        message.put("requestId", requestId);
        message.put("amount", amount);
        message.put("orderId", orderId);
        message.put("orderInfo", orderInfo);
        message.put("redirectUrl", redirectUrl);
        message.put("ipnUrl", ipnUrl);
        message.put("lang", "vi");
        message.put("extraData", safeExtraData);
        message.put("requestType", requestType);
        message.put("autoCapture", true);
        message.put("signature", signature);

        RequestBody body = RequestBody.create(message.toString(), JSON_MEDIA_TYPE);
        Request request = new Request.Builder()
                .url(endpoint)
                .post(body)
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (response.body() == null) {
                throw new Exception("MoMo did not return a response body.");
            }

            JSONObject resJson = new JSONObject(response.body().string());
            if (response.isSuccessful() && resJson.optInt("resultCode", -1) == 0 && resJson.has("payUrl")) {
                return resJson.getString("payUrl");
            }
            throw new Exception("MoMo Error: " + resJson);
        }
    }

    public String encodeExtraData(JSONObject data) {
        if (data == null || data.length() == 0) {
            return "";
        }
        return Base64.getEncoder().encodeToString(data.toString().getBytes(StandardCharsets.UTF_8));
    }

    public JSONObject decodeExtraData(String extraData) {
        if (extraData == null || extraData.isBlank()) {
            return new JSONObject();
        }

        try {
            byte[] decoded = Base64.getDecoder().decode(extraData);
            String json = new String(decoded, StandardCharsets.UTF_8);
            return new JSONObject(json);
        } catch (Exception e) {
            return new JSONObject();
        }
    }

    public boolean isValidCallbackSignature(JSONObject callbackData) throws Exception {
        if (callbackData == null) {
            return false;
        }

        String providedSignature = callbackData.optString("signature", "");
        if (providedSignature.isBlank()) {
            return false;
        }

        String rawSignature = "accessKey=" + accessKey
                + "&amount=" + callbackData.optString("amount", "")
                + "&extraData=" + callbackData.optString("extraData", "")
                + "&message=" + callbackData.optString("message", "")
                + "&orderId=" + callbackData.optString("orderId", "")
                + "&orderInfo=" + callbackData.optString("orderInfo", "")
                + "&orderType=" + callbackData.optString("orderType", "")
                + "&partnerCode=" + callbackData.optString("partnerCode", "")
                + "&payType=" + callbackData.optString("payType", "")
                + "&requestId=" + callbackData.optString("requestId", "")
                + "&responseTime=" + callbackData.optString("responseTime", "")
                + "&resultCode=" + callbackData.optString("resultCode", "")
                + "&transId=" + callbackData.optString("transId", "");

        String expectedSignature = hmacSha256(rawSignature, secretKey);
        return expectedSignature.equals(providedSignature) && partnerCode.equals(callbackData.optString("partnerCode", ""));
    }

    private String readSetting(String propertyKey, String envKey, String defaultValue) {
        String value = System.getProperty(propertyKey);
        if (value == null || value.isBlank()) {
            value = System.getenv(envKey);
        }
        if (value == null || value.isBlank()) {
            value = defaultValue;
        }
        return value;
    }

    private String hmacSha256(String data, String key) throws Exception {
        byte[] keyBytes = key.getBytes(StandardCharsets.UTF_8);
        SecretKeySpec signingKey = new SecretKeySpec(keyBytes, "HmacSHA256");
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(signingKey);
        byte[] rawHmac = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder(rawHmac.length * 2);
        for (byte b : rawHmac) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
