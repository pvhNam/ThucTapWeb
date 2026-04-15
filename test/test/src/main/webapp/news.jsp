<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, dao.NewsDAO, model.News, model.user"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="news.page_title" /> | Fashion Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css" />
    <link rel="stylesheet" href="CSS/news.css">
</head>
<body>
    <jsp:include page="header.jsp"><jsp:param name="page" value="news" /></jsp:include>
    <div class="news-container">
        <h1 style="text-align: center; margin-bottom: 40px; font-size: 2rem; letter-spacing: 1px;"><fmt:message key="news.heading" /></h1>    
        <div class="news-grid">
            <% NewsDAO dao = new NewsDAO();
               List<News> list = dao.getAllNews();
               if (list != null && !list.isEmpty()) {
                   for (News n : list) { %>
            <a href="news-detail?id=<%=n.getId()%>" style="text-decoration: none; color: inherit;">
                <div class="news-card">
                    <img src="<%=n.getImage()%>" alt="<%=n.getTitle()%>" class="news-img" onerror="this.src='img/no-image.png'">
                    <div class="news-content">
                        <span class="news-date"><i class="fa-regular fa-calendar"></i> <%=n.getCreatedAt()%></span>
                        <h3 class="news-title"><%=n.getTitle()%></h3>
                        <p class="news-desc"><%=n.getShortDesc()%></p>
                        <span style="color: #333; font-weight: 600; margin-top: 10px; font-size: 0.9rem;"><fmt:message key="news.read_more" /> &rarr;</span>
                    </div>
                </div>
            </a>
            <% } } else { %>
            <p style="text-align: center; width: 100%; color: #777;"><fmt:message key="news.empty" /></p>
            <% } %>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>