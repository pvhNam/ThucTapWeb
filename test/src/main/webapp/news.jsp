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
<link rel="stylesheet" href="CSS/style.css"/>

<style>
/* Container chính */
.news-container {
	max-width: 1000px; /* Thu hẹp lại một chút cho đẹp dạng list */
	margin: 40px auto;
	padding: 0 20px;
}

/* Chuyển Grid thành Flex Column để xếp dọc */
.news-grid {
	display: flex;
	flex-direction: column;
	gap: 30px;
}

/* Card tin tức: Flex Row để ảnh bên trái, chữ bên phải */
.news-card {
	display: flex; 
	border: 1px solid #eee;
	border-radius: 8px;
	overflow: hidden;
	background: #fff;
	transition: 0.3s;
    height: 220px; /* Chiều cao cố định cho card */
}

.news-card:hover {
	box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
	transform: translateX(5px); /* Hiệu ứng đẩy sang phải nhẹ */
}

/* Chỉnh ảnh: Cố định chiều rộng, chiều cao full card */
.news-img {
	width: 350px; /* Chiều rộng cố định của ảnh */
	height: 100%; /* Full chiều cao của card */
	object-fit: cover;
    flex-shrink: 0; /* Không cho ảnh bị co lại */
}

/* Nội dung: Chiếm phần còn lại */
.news-content {
	padding: 25px;
    flex: 1; /* Chiếm hết khoảng trống còn lại */
    display: flex;
    flex-direction: column;
    justify-content: center; /* Căn giữa nội dung theo chiều dọc */
}

.news-date {
	font-size: 0.85rem;
	color: #999;
	margin-bottom: 10px;
	display: block;
    text-transform: uppercase;
    font-weight: 600;
}

.news-title {
	font-size: 1.4rem;
	margin-bottom: 12px;
	color: #1a1a1a;
	font-weight: bold;
    line-height: 1.3;
}

.news-desc {
	color: #555;
	font-size: 0.95rem;
	line-height: 1.6;
    
    /* Cắt bớt text nếu quá dài (tối đa 3 dòng) */
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

/* --- Responsive cho Mobile --- */
@media (max-width: 768px) {
    .news-card {
        flex-direction: column; /* Trên điện thoại thì quay về dạng dọc (ảnh trên, chữ dưới) */
        height: auto; /* Chiều cao tự động */
    }
    
    .news-img {
        width: 100%; /* Ảnh full màn hình */
        height: 200px;
    }
    
    .news-content {
        padding: 20px;
    }
}
</style>
</head>
<body>
	<header class="header">
        <a href="index.jsp"><img src="img/logover2_5.png" alt="Logo" class="logo" width="80"></a>

        <nav class="menu">
            <a href="index.jsp" >TRANG CHỦ</a> 
            <a href="collection.jsp">BỘ SƯU TẬP</a> 
            <a href="about.jsp">GIỚI THIỆU</a> 
            <a href="news.jsp" class="active">TIN TỨC</a>
        </nav>

        <div class="actions">
            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i> 
                <input type="text" placeholder="Tìm kiếm sản phẩm..." />
            </div>

            <div class="account">
            	<%user currentUser = (user) session.getAttribute("user");
                boolean isLoggedIn = (currentUser != null); %>
                <% if (!isLoggedIn) { %>
                    <a href="login.jsp">ĐĂNG NHẬP</a> <span style="color:#ccc">|</span> <a href="register.jsp">ĐĂNG KÍ</a>
                <% } else { 
                	String fullName = currentUser.getFullname();
                    String displayName = fullName;
                    
                    if (fullName == null) {
                        displayName = "Member";
                    } else if (fullName.length() > 15) {
                        displayName = fullName.substring(0, 15) + "...";
                    }
                %>
                    <div class="user-info">
                        <span>Hi, <%=displayName%></span> 
                        <a href="order-history" title="Lịch sử mua hàng" style="margin-left: 5px;">
                           <i class="fa-solid fa-clock-rotate-left"></i>
                        </a>
                        <a href="profile.jsp" title="Trang cá nhân"> 
                            <img src="img/images.jpg" alt="User" class="user-avatar"> 
                        </a>
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Đăng xuất"><i class="fa-solid fa-right-from-bracket"></i></a>
                    </div>
                <% } %>
            </div>
            
            <a href="cart" aria-label="Giỏ hàng" class="cart-icon"> 
                <i class="fa-solid fa-cart-shopping"></i>
            </a>
        </div>
    </header>

	<div class="news-container">
		<h1 style="text-align: center; margin-bottom: 40px; font-size: 2rem; letter-spacing: 1px;">BẢN TIN THỜI TRANG</h1>
		
		<div class="news-grid">
			<%
			NewsDAO dao = new NewsDAO();
			List<News> list = dao.getAllNews();
			if (list != null && !list.isEmpty()) {
				for (News n : list) {
			%>
            <a href="news-detail?id=<%=n.getId()%>" style="text-decoration: none; color: inherit;">
			    <div class="news-card">
				    <img src="<%=n.getImage()%>" alt="<%=n.getTitle()%>"
					    class="news-img" onerror="this.src='img/no-image.png'">
				    <div class="news-content">
					    <span class="news-date"><i class="fa-regular fa-calendar"></i>
						    <%=n.getCreatedAt()%></span>
					    <h3 class="news-title"><%=n.getTitle()%></h3>
					    <p class="news-desc"><%=n.getShortDesc()%></p>
                        <span style="color: #333; font-weight: 600; margin-top: 10px; font-size: 0.9rem;">
                            Đọc tiếp &rarr;
                        </span>
				    </div>
			    </div>
            </a>
			<%
			}
			} else {
			%>
			<p style="text-align: center; width: 100%; color: #777;">Chưa có tin tức nào được cập nhật.</p>
			<%
			}
			%>
		</div>
	</div>
</body>
</html>