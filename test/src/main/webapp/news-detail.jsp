<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.News, model.user"%>
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
<link rel="stylesheet" href="CSS/news-detail.css">
</head>
<style type="text/css">
body {
    background-color: #f9f9f9;
    margin: 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.article-container {
    max-width: 900px;
    margin: 40px auto;
    padding: 40px;
    background: #fff;
    box-shadow: 0 0 20px rgba(0,0,0,0.05);
    border-radius: 8px;
}

/* --- HEADER BÀI VIẾT --- */
.article-header {
    text-align: center;
    margin-bottom: 30px;
}

.article-title {
    font-size: 2.2rem;
    font-weight: 800;
    color: #222;
    line-height: 1.4;
    margin-bottom: 15px;
}

.article-meta {
    color: #888;
    font-size: 0.95rem;
    text-transform: uppercase;
    letter-spacing: 1px;
}

/* --- ẢNH ĐẠI DIỆN --- */
.article-featured-img {
    width: 100%;
    height: 450px;
    object-fit: cover;
    border-radius: 8px;
    margin-bottom: 30px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

/* --- NỘI DUNG BÀI VIẾT --- */
.article-content {
    font-size: 1.15rem;
    line-height: 1.8;
    color: #333;
    text-align: justify;
}

.article-content strong {
    display: block;
    font-size: 1.2rem;
    color: #000;
    margin-bottom: 20px;
    font-style: italic;
}

.article-content p {
    margin-bottom: 20px;
}

/* --- PHẦN BÌNH LUẬN --- */
.comment-section {
    margin-top: 60px;
    padding-top: 40px;
    border-top: 2px solid #eee;
}

.section-title {
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 25px;
    border-left: 5px solid #000;
    padding-left: 15px;
    text-transform: uppercase;
}

/* Form nhập */
.comment-form {
    background: #f8f8f8;
    padding: 25px;
    border-radius: 10px;
    margin-bottom: 40px;
}

.comment-form textarea {
    width: 100%;
    padding: 15px;
    border: 1px solid #ddd;
    border-radius: 5px;
    font-size: 1rem;
    font-family: inherit;
    resize: vertical;
    outline: none;
    box-sizing: border-box;
    transition: 0.3s;
    background: #fff;
}

.comment-form textarea:focus {
    border-color: #000;
}

.btn-comment {
    background: #000;
    color: #fff;
    padding: 12px 30px;
    border: none;
    border-radius: 30px;
    font-weight: bold;
    text-transform: uppercase;
    cursor: pointer;
    margin-top: 15px;
    transition: 0.3s;
}

.btn-comment:hover {
    background: #444;
    transform: translateY(-2px);
}

/* Danh sách bình luận */
.comment-list {
    display: flex;
    flex-direction: column;
    gap: 25px;
}

.comment-item {
    display: flex;
    gap: 20px;
    padding-bottom: 20px;
    border-bottom: 1px solid #f0f0f0;
}

.comment-item:last-child {
    border-bottom: none;
}

.user-avatar {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #ddd;
}

.comment-body {
    flex: 1;
}

.user-name {
    font-weight: 700;
    font-size: 1rem;
    color: #000;
    margin: 0 0 5px 0;
}

.comment-date {
    font-size: 0.8rem;
    color: #999;
    font-weight: normal;
    margin-left: 10px;
}

.comment-text {
    color: #444;
    line-height: 1.5;
    margin: 0;
}

/* --- FOOTER & BUTTON --- */
.article-footer {
    margin-top: 40px;
    text-align: left;
}

.btn-back {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    text-decoration: none;
    color: #333;
    font-weight: 600;
    padding: 10px 25px;
    border: 1px solid #ccc;
    border-radius: 50px;
    transition: all 0.3s;
}

.btn-back:hover {
    background: #000;
    color: #fff;
    border-color: #000;
}</style>
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
</body>
</html>