package controller.user;

import java.io.IOException;
import dao.NewsDAO;
import model.News;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/news-detail")
public class NewsDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        try {
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);

                NewsDAO dao = new NewsDAO();
                News n = dao.getNewsById(id);

                if (n != null) {
                    request.setAttribute("newsObj", n);
                    request.getRequestDispatcher("/news-detail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("news");
                }
            } else {
                response.sendRedirect("news");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("news");
        }
    }
}
