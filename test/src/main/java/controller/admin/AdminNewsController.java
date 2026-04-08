package controller.admin;

import java.io.IOException;
import java.util.List;
import dao.NewsDAO;
import model.News;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-news")
public class AdminNewsController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private boolean checkAdminPermission(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User currUser = (User) session.getAttribute("user");
        Boolean isHardcodedAdmin = (Boolean) session.getAttribute("isAdmin");
        int role = (currUser != null) ? currUser.getIsAdmin()
                : ((isHardcodedAdmin != null && isHardcodedAdmin) ? 1 : 0);

        if (role != 1) {
            response.sendRedirect("admin");
            return false;
        }
        return true;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdminPermission(request, response)) return;

        String type = request.getParameter("type");
        NewsDAO dao = new NewsDAO();

        if ("edit".equals(type)) {
            int id = Integer.parseInt(request.getParameter("id"));
            News n = dao.getNewsById(id);
            request.setAttribute("n", n);
            request.getRequestDispatcher("/views/admin/edit-news.jsp").forward(request, response);
        } else if ("delete".equals(type)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteNews(id);
            response.sendRedirect("admin-news");
        } else {
            List<News> list = dao.getAllNews();
            request.setAttribute("listN", list);
            request.getRequestDispatcher("/views/admin/news.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdminPermission(request, response)) return;

        request.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String shortDesc = request.getParameter("shortDesc");
        String content = request.getParameter("content");
        String image = request.getParameter("image");

        News n = new News(id, title, shortDesc, content, image, null);
        NewsDAO dao = new NewsDAO();
        dao.updateNews(n);

        response.sendRedirect("admin-news");
    }
}
