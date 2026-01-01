<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.News, model.user"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<%
// Lấy đối tượng từ Controller gửi sang
News n = (News) request.getAttribute("newsObj");

// Nếu n null (truy cập trực tiếp trang này mà không qua Controller), đẩy về news
if (n == null) {
	response.sendRedirect("news.jsp");
	return;
}
%>
<title><%=n.getTitle()%> | Fashion Store</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/news-detail.css">
</head>
<body>

<jsp:include page="header.jsp">
        <jsp:param name="page" value="news" />
    </jsp:include>

	<div class="article-container">

		<div class="article-header">
			<h1 class="article-title"><%=n.getTitle()%></h1>
			<div class="article-meta">
				<span><i class="fa-regular fa-calendar"></i> <%=n.getCreatedAt()%></span>
				<span style="margin: 0 10px;">|</span> <span>Fashion Store
					Team</span>
			</div>
		</div>

		<img src="<%=n.getImage()%>" alt="Ảnh bài viết"
			class="article-featured-img" onerror="this.src='img/no-image.png'">

		<div class="article-content">
			<p>
				<strong><%=n.getShortDesc()%></strong>
			</p>

			<hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">

			<%
			String content = n.getContent();
			if (content != null) {
				// Thay thế ký tự xuống dòng (\n) thành thẻ <br> để hiển thị đúng trên web
				content = content.replace("\n", "<br>");
			} else {
				content = "<p>Nội dung đang cập nhật...</p>";
			}
			%>
			<%=content%>
		</div>

		<div class="article-footer">
			<a href="news.jsp" class="btn-back"> <i
				class="fa-solid fa-arrow-left"></i> Quay lại danh sách tin
			</a>
		</div>
	</div>

</body>
</html>