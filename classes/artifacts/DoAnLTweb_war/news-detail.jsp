<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.News, model.User"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
<meta charset="UTF-8">
<% News n = (News) request.getAttribute("newsObj");
   if (n == null) { response.sendRedirect("news.jsp"); return; } %>
<title><%=n.getTitle()%> | Fashion Store</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/user/news-detail.css">
</head>
<body>
    <jsp:include page="header.jsp"><jsp:param name="page" value="news" /></jsp:include>
    <div class="article-container">
        <div class="article-header">
            <h1 class="article-title"><%=n.getTitle()%></h1>
            <div class="article-meta">
                <span><i class="fa-regular fa-calendar"></i> <%=n.getCreatedAt()%></span>
                <span style="margin: 0 10px;">|</span> <span>Fashion Store Team</span>
            </div>
        </div>
        <img src="<%=n.getImage()%>" alt="Img" class="article-featured-img" onerror="this.src='img/no-image.png'">
        <div class="article-content">
            <p><strong><%=n.getShortDesc()%></strong></p>
            <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
            <% String content = n.getContent();
               if (content != null) { content = content.replace("\n", "<br>"); }
               else { content = "<p>Updating...</p>"; } %>
            <%=content%>
        </div>
        <div class="article-footer">
            <a href="news.jsp" class="btn-back"> <i class="fa-solid fa-arrow-left"></i> <fmt:message key="news.back" /></a>
        </div>
    </div>
        <jsp:include page="footer.jsp" />
</body>
</html>
