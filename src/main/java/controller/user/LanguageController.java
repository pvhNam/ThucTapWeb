package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.TreeSet;

@WebServlet("/change-lang")
public class LanguageController extends HttpServlet {
    private static final String BUNDLE_NAME = "resources.messages";
    private static final String CLIENT_BUNDLE_NAME = "resources.messages_client";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String lang = "en".equalsIgnoreCase(request.getParameter("lang")) ? "en" : "vi";
        HttpSession session = request.getSession();
        session.setAttribute("lang", lang);

        if (isAjaxRequest(request)) {
            writeLanguageResponse(response, lang);
            return;
        }

        String referer = request.getHeader("referer");
        response.sendRedirect(referer != null ? referer : "home");
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        return "XMLHttpRequest".equalsIgnoreCase(requestedWith)
                || (accept != null && accept.contains("application/json"));
    }

    private void writeLanguageResponse(HttpServletResponse response, String lang) throws IOException {
        String sourceLang = "en".equals(lang) ? "vi" : "en";
        JSONArray translations = new JSONArray();
        appendTranslations(translations, BUNDLE_NAME, sourceLang, lang);
        appendTranslations(translations, CLIENT_BUNDLE_NAME, sourceLang, lang);

        JSONObject payload = new JSONObject()
                .put("success", true)
                .put("lang", lang)
                .put("translations", translations);

        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.getWriter().write(payload.toString());
    }

    private void appendTranslations(JSONArray translations, String bundleName,
                                    String sourceLang, String targetLang) {
        ResourceBundle source = ResourceBundle.getBundle(bundleName, Locale.forLanguageTag(sourceLang));
        ResourceBundle target = ResourceBundle.getBundle(bundleName, Locale.forLanguageTag(targetLang));

        Set<String> keys = new TreeSet<>(source.keySet());
        keys.retainAll(target.keySet());
        for (String key : keys) {
            String from = source.getString(key);
            String to = target.getString(key);
            if (!from.equals(to) && !from.isBlank()) {
                translations.put(new JSONObject()
                        .put("key", key)
                        .put("from", from)
                        .put("to", to));
            }
        }
    }
}
