package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/google-login")
public class GoogleLoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String clientId = getServletContext().getInitParameter("google.clientId");
        if (clientId == null || clientId.isEmpty()) {
            clientId = System.getenv("GOOGLE_CLIENT_ID");
        }
        String configuredRedirect = getServletContext().getInitParameter("google.redirectUri");

        String redirectUri = configuredRedirect;
        if (configuredRedirect == null || configuredRedirect.isEmpty() || configuredRedirect.equals("YOUR_REDIRECT_URI")) {
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

        if (clientId == null || clientId.isEmpty() || clientId.equals("YOUR_GOOGLE_CLIENT_ID")) {
            request.setAttribute("error", "Google OAuth client ID không được tìm thấy.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        String scope = "openid email profile";
        String authUrl = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id=" + URLEncoder.encode(clientId, "UTF-8")
                + "&response_type=code"
                + "&scope=" + URLEncoder.encode(scope, "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8")
                + "&access_type=online"
                + "&prompt=select_account";
        if (configuredRedirect != null && !configuredRedirect.isEmpty() && !configuredRedirect.equals(redirectUri)) {
            String message = "Configured redirect URI (web.xml) does not match this server's computed redirect URI.\n"
                    + "Configured: " + configuredRedirect + "\nComputed: " + redirectUri
                    + "\nMake sure the redirect URI registered in Google Cloud Console matches exactly.";
            request.setAttribute("error", message.replaceAll("\\n", "<br/>"));
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(authUrl);
    }
}
