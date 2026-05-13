package controller.user;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.MD5;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Random;

@WebServlet("/google-callback")
public class GoogleCallbackController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        String error = request.getParameter("error");

        if (error != null) {
            request.setAttribute("error", "Google sign-in was cancelled or failed: " + error);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (code == null || code.isEmpty()) {
            request.setAttribute("error", "No code from Google");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Prefer values placed into the ServletContext attributes (set by LoggingConfigListener),
        // then web.xml init-params, then environment variables.
        String clientId = null;
        Object cidAttr = getServletContext().getAttribute("google.clientId");
        if (cidAttr instanceof String && !((String) cidAttr).isEmpty()) {
            clientId = (String) cidAttr;
        }
        if (clientId == null || clientId.isEmpty()) {
            clientId = getServletContext().getInitParameter("google.clientId");
        }
        if (clientId == null || clientId.isEmpty()) {
            clientId = System.getenv("GOOGLE_CLIENT_ID");
        }

        String clientSecret = null;
        Object csAttr = getServletContext().getAttribute("google.clientSecret");
        if (csAttr instanceof String && !((String) csAttr).isEmpty()) {
            clientSecret = (String) csAttr;
        }
        if (clientSecret == null || clientSecret.isEmpty()) {
            clientSecret = getServletContext().getInitParameter("google.clientSecret");
        }
        if (clientSecret == null || clientSecret.isEmpty()) {
            clientSecret = System.getenv("GOOGLE_CLIENT_SECRET");
        }

        String redirectUri = null;
        Object ruAttr = getServletContext().getAttribute("google.redirectUri");
        if (ruAttr instanceof String && !((String) ruAttr).isEmpty()) {
            redirectUri = (String) ruAttr;
        }
        if (redirectUri == null || redirectUri.isEmpty()) {
            redirectUri = getServletContext().getInitParameter("google.redirectUri");
        }
        if (redirectUri == null || redirectUri.isEmpty()) {
            // try to build from request
            String scheme = request.getScheme();
            String serverName = request.getServerName();
            int serverPort = request.getServerPort();
            String context = request.getContextPath();
            String portPart = "";
            if (!(serverPort == 80 && "http".equalsIgnoreCase(scheme)) && !(serverPort == 443 && "https".equalsIgnoreCase(scheme))) {
                portPart = ":" + serverPort;
            }
            redirectUri = scheme + "://" + serverName + portPart + context + "/google-callback";
        }
        if (clientSecret == null || clientSecret.isEmpty()) {
            String msg = "Google OAuth client secret is not configured. Set context-param 'google.clientSecret' in web.xml or env GOOGLE_CLIENT_SECRET.";
            request.setAttribute("error", msg);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            String tokenResponse = postForm("https://oauth2.googleapis.com/token",
                    "code=" + URLEncoder.encode(code, "UTF-8")
                            + "&client_id=" + URLEncoder.encode(clientId, "UTF-8")
                            + "&client_secret=" + URLEncoder.encode(clientSecret, "UTF-8")
                            + "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8")
                            + "&grant_type=authorization_code");
            String accessToken = extractJsonValue(tokenResponse, "access_token");
            if (accessToken == null) {
                request.setAttribute("error", "Failed to obtain access token from Google. See server logs for details.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            String userInfo = getWithAuth("https://www.googleapis.com/oauth2/v2/userinfo", accessToken);
            String email = extractJsonValue(userInfo, "email");
            String name = extractJsonValue(userInfo, "name");
            String picture = extractJsonValue(userInfo, "picture");

            if (email == null || email.isEmpty()) {
                request.setAttribute("error", "Unable to retrieve email from Google account.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            UserDAO dao = new UserDAO();
            User u = dao.checkEmailExist(email);
            if (u == null) {
                String baseUsername = email.split("@")[0];
                String username = baseUsername;
                int tries = 0;
                while (dao.checkUserExist(username) != null && tries < 10) {
                    username = baseUsername + new Random().nextInt(1000);
                    tries++;
                }

				String password = MD5.getMd5(email + System.currentTimeMillis());
                dao.register(username, password, email, name != null ? name : username, "");
                u = dao.checkEmailExist(email);
            }

            if (u != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", u);
                session.setAttribute("isAdmin", u.getIsAdmin() == 1 || u.getIsAdmin() == 2);
                response.sendRedirect("home");
            } else {
                request.setAttribute("error", "Unable to create or find user account for Google email.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } catch (Exception ex) {
            request.setAttribute("error", "Google login error: " + ex.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private static String postForm(String urlStr, String urlEncodedBody) throws IOException {
        byte[] postData = urlEncodedBody.getBytes(StandardCharsets.UTF_8);
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setRequestProperty("Accept", "application/json");
        conn.setDoOutput(true);
        try (DataOutputStream wr = new DataOutputStream(conn.getOutputStream())) {
            wr.write(postData);
        }
        int responseCode = conn.getResponseCode();
        try (BufferedReader in = new BufferedReader(new InputStreamReader(
                responseCode >= 200 && responseCode < 400 ? conn.getInputStream() : conn.getErrorStream()))) {
            StringBuilder resp = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) {
                resp.append(line);
            }
            String respStr = resp.toString();
            return respStr;
        }
    }

    private static String getWithAuth(String urlStr, String accessToken) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        conn.setRequestProperty("Accept", "application/json");
        int responseCode = conn.getResponseCode();
        try (BufferedReader in = new BufferedReader(new InputStreamReader(
                responseCode >= 200 && responseCode < 400 ? conn.getInputStream() : conn.getErrorStream()))) {
            StringBuilder resp = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) {
                resp.append(line);
            }
            String respStr = resp.toString();
            return respStr;
        }
    }
    private static String extractJsonValue(String json, String key) {
        if (json == null || key == null) return null;
        String quotedKey = "\"" + key + "\"";
        int keyIdx = json.indexOf(quotedKey);
        if (keyIdx < 0) return null;
        int colonIdx = json.indexOf(':', keyIdx + quotedKey.length());
        if (colonIdx < 0) return null;
        int i = colonIdx + 1;
        // skip whitespace
        while (i < json.length() && Character.isWhitespace(json.charAt(i))) i++;
        if (i >= json.length()) return null;

        if (json.charAt(i) == '"') {
            // quoted value
            i++; // skip opening quote
            int start = i;
            StringBuilder sb = new StringBuilder();
            while (i < json.length()) {
                char c = json.charAt(i);
                if (c == '\\' && i + 1 < json.length()) {
                    i++;
                    sb.append(json.charAt(i));
                } else if (c == '"') {
                    break;
                } else {
                    sb.append(c);
                }
                i++;
            }
            return sb.toString();
        } else {
            int start = i;
            while (i < json.length()) {
                char c = json.charAt(i);
                if (c == ',' || c == '}' || Character.isWhitespace(c)) break;
                i++;
            }
            return json.substring(start, i).replaceAll("[\n\r\"]", "").trim();
        }
    }
}
