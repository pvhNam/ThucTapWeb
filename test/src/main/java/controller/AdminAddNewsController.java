package controller;

import java.io.IOException;
import dao.NewsDAO;
import model.News;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-add-news")
public class AdminAddNewsController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String title = request.getParameter("title");
        String shortDesc = request.getParameter("shortDesc");
        String content = request.getParameter("content");
        String image = request.getParameter("image");

        News n = new News();
        n.setTitle(title);
        n.setShortDesc(shortDesc);
        n.setContent(content);
        n.setImage(image);

        NewsDAO dao = new NewsDAO();
        dao.addNews(n);

        response.sendRedirect("admin-news"); 
    }
}