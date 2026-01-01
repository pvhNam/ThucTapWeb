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

<style>
/* CSS RIÊNG CHO TRANG CHI TIẾT */
.article-container {
	max-width: 800px;
	margin: 40px auto;
	padding: 0 20px;
	background: #fff;
}

/* Breadcrumb */
.breadcrumb {
	font-size: 0.9rem;
	color: #888;
	margin-bottom: 20px;
}

.breadcrumb a {
	text-decoration: none;
	color: #333;
	font-weight: 600;
}

/* Header bài viết */
.article-header {
	margin-bottom: 30px;
	text-align: center;
}

.article-title {
	font-size: 2rem;
	font-weight: 800;
	color: #1a1a1a;
	line-height: 1.3;
	margin-bottom: 15px;
}

.article-meta {
	color: #777;
	font-size: 0.9rem;
	font-style: italic;
}

/* Ảnh đại diện */
.article-featured-img {
	width: 100%;
	height: auto;
	max-height: 500px;
	object-fit: cover;
	border-radius: 8px;
	margin-bottom: 30px;
}

/* Nội dung */
.article-content {
	font-size: 1.1rem;
	line-height: 1.8;
	color: #333;
	text-align: justify;
}

.article-content p {
	margin-bottom: 20px;
}

/* Nút quay lại */
.article-footer {
	margin-top: 50px;
	padding-top: 30px;
	border-top: 1px solid #eee;
}

.btn-back {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	text-decoration: none;
	color: #333;
	font-weight: 600;
	padding: 10px 20px;
	border: 1px solid #ddd;
	border-radius: 30px;
	transition: 0.3s;
}

.btn-back:hover {
	background: #333;
	color: white;
}
</style>
</head>
<body>

	<header class="header">
		<a href="index.jsp"><img src="img/logover2_5.png" alt="Logo"
			class="logo" width="80"></a>
		<nav class="menu">
			<a href="index.jsp">TRANG CHỦ</a> <a href="collection.jsp">BỘ
				SƯU TẬP</a> <a href="about.jsp">GIỚI THIỆU</a> <a href="news.jsp"
				class="active">TIN TỨC</a>
		</nav>
		<div class="actions">
			<div class="account">
				<%
				user currentUser = (user) session.getAttribute("user");
				if (currentUser != null) {
				%>
				<div class="user-info">
					<span>Hi, <%=currentUser.getFullname()%></span> <a href="logout"
						class="logout-btn"><i class="fa-solid fa-right-from-bracket"></i></a>
				</div>
				<%
				} else {
				%>
				<a href="login.jsp">ĐĂNG NHẬP</a>
				<%
				}
				%>
			</div>
			<a href="cart" class="cart-icon"><i
				class="fa-solid fa-cart-shopping"></i></a>
		</div>
	</header>

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