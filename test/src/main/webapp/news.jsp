<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, dao.NewsDAO, model.News, model.user"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Tin Tức | Fashion Store</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<style>
.news-container {
	max-width: 1200px;
	margin: 40px auto;
	padding: 0 20px;
}

.news-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
	gap: 30px;
}

.news-card {
	border: 1px solid #eee;
	border-radius: 8px;
	overflow: hidden;
	background: #fff;
	transition: 0.3s;
}

.news-card:hover {
	box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
	transform: translateY(-5px);
}

.news-img {
	width: 100%;
	height: 200px;
	object-fit: cover;
}

.news-content {
	padding: 20px;
}

.news-title {
	font-size: 1.2rem;
	margin-bottom: 10px;
	color: #1a1a1a;
	font-weight: bold;
}

.news-desc {
	color: #555;
	font-size: 0.9rem;
	line-height: 1.5;
}

.news-date {
	font-size: 0.8rem;
	color: #999;
	margin-bottom: 5px;
	display: block;
}
</style>
</head>
<body>
	<header class="header">
		<a href="index.jsp"><img src="img/logover2_5.png" alt="Logo"
			class="logo" width="80"></a>
		<nav class="menu">
			<a href="index.jsp">CỬA HÀNG</a> <a href="collection.jsp">BỘ SƯU
				TẬP</a> <a href="about.jsp">GIỚI THIỆU</a> <a href="news.jsp"
				class="active">TIN TỨC</a>
		</nav>
		<div class="actions">
			<a href="cart"><i class="fa-solid fa-cart-shopping"></i></a>
		</div>
	</header>

	<div class="news-container">
		<h1 style="text-align: center; margin-bottom: 40px;">BẢN TIN THỜI
			TRANG</h1>
		<div class="news-grid">
			<%
			NewsDAO dao = new NewsDAO();
			List<News> list = dao.getAllNews();
			if (list != null && !list.isEmpty()) {
				for (News n : list) {
			%>
			<div class="news-card">
				<img src="<%=n.getImage()%>" alt="<%=n.getTitle()%>"
					class="news-img" onerror="this.src='img/no-image.png'">
				<div class="news-content">
					<span class="news-date"><i class="fa-regular fa-clock"></i>
						<%=n.getCreatedAt()%></span>
					<h3 class="news-title"><%=n.getTitle()%></h3>
					<p class="news-desc"><%=n.getShortDesc()%></p>
				</div>
			</div>
			<%
			}
			} else {
			%>
			<p style="text-align: center; width: 100%;">Chưa có tin tức nào.</p>
			<%
			}
			%>
		</div>
	</div>
</body>
</html>