package util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class LoggingConfigListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        String clientId = System.getenv("GOOGLE_CLIENT_ID");
        String clientSecret = System.getenv("GOOGLE_CLIENT_SECRET");

        if (clientId != null && !clientId.isEmpty()) {
            sce.getServletContext().setAttribute("google.clientId", clientId);
            sce.getServletContext().log("Google clientId loaded from environment.");
        } else {
            sce.getServletContext().log("Google clientId not found in environment.");
        }

        if (clientSecret != null && !clientSecret.isEmpty()) {
            sce.getServletContext().setAttribute("google.clientSecret", clientSecret);
            sce.getServletContext().log("Google clientSecret loaded from environment.");
        } else {
            sce.getServletContext().log("Google clientSecret not found in environment.");
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
