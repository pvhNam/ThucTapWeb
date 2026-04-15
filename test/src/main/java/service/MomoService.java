package service;

import java.nio.charset.StandardCharsets;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.json.JSONObject;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class MomoService {
	private final String partnerCode = "MOMO";
    private final String accessKey = "F8BBA842ECF85";
    private final String secretKey = "K951B6PE1waDMi640xX08PD3vg6EkVlz";
    private final String endpoint = "https://test-payment.momo.vn/v2/gateway/api/create";
    public String createPayment(String amount, String orderId, String orderInfo) throws Exception {
        String requestId = String.valueOf(System.currentTimeMillis());
        // URL này phải khớp với URL cấu hình trong Servlet của bạn
        String redirectUrl = "http://localhost:8080/FashionStore/momo-callback"; 
        String ipnUrl = "http://localhost:8080/FashionStore/momo-callback";
        String requestType = "captureWallet";
        String extraData = "";

        // Tạo chữ ký HMAC-SHA256 (Thứ tự bảng chữ cái A-Z)
        String rawSignature = "accessKey=" + accessKey + "&amount=" + amount + "&extraData=" + extraData +
                "&ipnUrl=" + ipnUrl + "&orderId=" + orderId + "&orderInfo=" + orderInfo +
                "&partnerCode=" + partnerCode + "&redirectUrl=" + redirectUrl + "&requestId=" + requestId + "&requestType=" + requestType;

        String signature = hmacSha256(rawSignature, secretKey);

        JSONObject message = new JSONObject();
        message.put("partnerCode", partnerCode);
        message.put("accessKey", accessKey);
        message.put("requestId", requestId);
        message.put("amount", amount);
        message.put("orderId", orderId);
        message.put("orderInfo", orderInfo);
        message.put("redirectUrl", redirectUrl);
        message.put("ipnUrl", ipnUrl);
        message.put("extraData", extraData);
        message.put("requestType", requestType);
        message.put("signature", signature);
        message.put("lang", "vi");

        OkHttpClient client = new OkHttpClient();
        RequestBody body = RequestBody.create(message.toString(), MediaType.get("application/json; charset=utf-8"));
        Request request = new Request.Builder().url(endpoint).post(body).build();

        try (Response response = client.newCall(request).execute()) {
            JSONObject resJson = new JSONObject(response.body().string());
            if (resJson.has("payUrl")) {
                return resJson.getString("payUrl");
            }
            throw new Exception("MoMo Error: " + resJson.toString());
        }
    }

    private String hmacSha256(String data, String key) throws Exception {
        byte[] keyBytes = key.getBytes(StandardCharsets.UTF_8);
        SecretKeySpec signingKey = new SecretKeySpec(keyBytes, "HmacSHA256");
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(signingKey);
        byte[] rawHmac = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder(rawHmac.length * 2);
        for (byte b : rawHmac) sb.append(String.format("%02x", b));
        return sb.toString();
    }
}
