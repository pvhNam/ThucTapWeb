package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/change-lang")
public class LanguageController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String lang = request.getParameter("lang");
        HttpSession session = request.getSession();
        
        // Lưu ngôn ngữ vào Session
        if ("en".equals(lang)) {
            session.setAttribute("lang", "en"); 
        } else {
            session.setAttribute("lang", "vi"); // Mặc định là vi
        }
        
        // Quay lại trang vừa đứng (Referer)
        String referer = request.getHeader("referer");
        response.sendRedirect(referer != null ? referer : "index.jsp");
    }
}