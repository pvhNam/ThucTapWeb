<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.user"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tin Tức Thời Trang</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css" />
    <link rel="stylesheet" href="CSS/news.css" />
</head>
<body>

    <header class="header">
        <img src="img/logover2_5.png" alt="Logo" class="logo" width="80">

        <nav class="menu">
            <a href="index.jsp">CỬA HÀNG</a>
            <a href="collection.jsp">BỘ SƯU TẬP</a>
            <a href="about.jsp">GIỚI THIỆU</a> 
            <a href="news.jsp" class="active">TIN TỨC</a>
        </nav>

        <div class="actions">
            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i> 
                <input type="text" placeholder="Tìm Kiếm" />
            </div>
            
            <div class="account">
                <%
                    user currentUser = (user) session.getAttribute("user");
                    if (currentUser == null) { 
                %>
                    <a href="login.jsp">ĐĂNG NHẬP</a> |
                    <a href="register.jsp">ĐĂNG KÍ</a>
                <% 
                    } else { 
                        String displayName = currentUser.getUsername();
                        if(currentUser.getFullname() != null) displayName = currentUser.getFullname();
                %>
                    <div class="user-info" style="display:flex; align-items:center; gap:10px;">
                        <span>Xin chào, <%= displayName %></span>
                        <a href="profile.jsp" title="Trang cá nhân">
                            <img src="img/default-user.png" alt="User" class="user-avatar" style="width:30px; border-radius:50%;">
                        </a>
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn" style="color:red; font-size:0.8rem;">(Thoát)</a>
                    </div>
                <% 
                    } 
                %>
            </div>
            
            <a href="cart" aria-label="Giỏ hàng"> 
                <i class="fa-solid fa-cart-shopping"></i>
            </a>
        </div>
    </header>

    <div class="news-hero">
        <h1>BLOG THỜI TRANG</h1>
        <p>Cập nhật xu hướng mới nhất năm 2025</p>
    </div>

    <div class="news-container">
        
        <div class="section-heading">
            <h2>Bài Viết Mới Nhất</h2>
        </div>

        <div class="news-grid">
            
            <article class="news-card">
                <div class="news-img">
                    <span class="news-date">08/12</span>
                    <img src="https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=2070&auto=format&fit=crop" alt="News 1">
                </div>
                <div class="news-content">
                    <span class="news-category">Xu Hướng</span>
                    <h3>Bộ sưu tập Mùa Hè 2025: Sự bùng nổ của màu sắc</h3>
                    <p>Khám phá những gam màu rực rỡ sẽ thống trị các sàn diễn thời trang trong mùa hè năm nay. Đừng bỏ lỡ cơ hội làm mới tủ đồ của bạn.</p>
                    <a href="#" class="read-more-btn">Đọc tiếp <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </article>

            <article class="news-card">
                <div class="news-img">
                    <span class="news-date">05/12</span>
                    <img src="https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=2020&auto=format&fit=crop" alt="News 2">
                </div>
                <div class="news-content">
                    <span class="news-category">Phong Cách</span>
                    <h3>5 Cách phối đồ Minimalist cho nàng công sở</h3>
                    <p>Phong cách tối giản không bao giờ lỗi mốt. Hãy cùng tìm hiểu cách phối đồ vừa thanh lịch vừa thoải mái cho môi trường làm việc.</p>
                    <a href="#" class="read-more-btn">Đọc tiếp <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </article>

            <article class="news-card">
                <div class="news-img">
                    <span class="news-date">01/12</span>
                    <img src="https://images.unsplash.com/photo-1558769132-cb1aea458c5e?q=80&w=1974&auto=format&fit=crop" alt="News 3">
                </div>
                <div class="news-content">
                    <span class="news-category">Khuyến Mãi</span>
                    <h3>Săn Sale Giáng Sinh: Giảm giá lên đến 50%</h3>
                    <p>Chương trình khuyến mãi lớn nhất trong năm đã bắt đầu. Hàng ngàn sản phẩm thời trang cao cấp đang chờ đón bạn.</p>
                    <a href="#" class="read-more-btn">Đọc tiếp <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </article>

            <article class="news-card">
                <div class="news-img">
                    <span class="news-date">28/11</span>
                    <img src="https://images.unsplash.com/photo-1529139574466-a302d2052574?q=80&w=2070&auto=format&fit=crop" alt="News 4">
                </div>
                <div class="news-content">
                    <span class="news-category">Mẹo Vặt</span>
                    <h3>Bảo quản đồ da đúng cách tại nhà</h3>
                    <p>Đồ da cần được chăm sóc đặc biệt để giữ được độ bền và vẻ đẹp. Bài viết này sẽ hướng dẫn bạn các bước cơ bản.</p>
                    <a href="#" class="read-more-btn">Đọc tiếp <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </article>
             <article class="news-card">
                <div class="news-img">
                    <span class="news-date">28/11</span>
                    <img src="https://images.unsplash.com/photo-1490481651871-ab68de25d43d?q=80&w=2070&auto=format&fit=crop" alt="News 4">
                </div>
                <div class="news-content">
                    <span class="news-category">Mẹo Vặt</span>
                    <h3>Cách chọn size quần áo chuẩn xác khi mua online</h3>
                    <p>Bảng hướng dẫn chi tiết cách đo các vòng cơ thể để chọn được size đồ ưng ý nhất mà không cần thử trực tiếp.</p>
                    <a href="#" class="read-more-btn">Đọc tiếp <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </article>
             <article class="news-card">
                <div class="news-img">
                    <span class="news-date">28/11</span>
                    <img src="https://images.unsplash.com/photo-1469334031218-e382a71b716b?q=80&w=2070&auto=format&fit=crop" alt="News 4">
                </div>
                <div class="news-content">
                    <span class="news-category">Bộ sưu tập</span>
                    <h3>Vẻ đẹp của trang phục Vintage thập niên 90</h3>
                    <p>Sự trở lại của phong cách retro thập niên 90 đang làm mưa làm gió. Cùng chiêm ngưỡng những set đồ kinh điển.</p>
                    <a href="#" class="read-more-btn">Đọc tiếp <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </article>

        </div>
    </div>

    <footer class="footer">
        <div class="footer-top">
            <div class="contact">
                <h3>Liên Hệ</h3>
                <p><strong>☎️</strong> 0981774313</p>
                <p><strong>✉️</strong> tranthanglo@gmail.com</p>
                <p><strong>📍</strong> S2, đường Hải Triều, phường Bến Nghé, Quận 1, TP HCM</p>
            </div>

            <div class="payandship">
                <div class="payment">
                    <h4>Phương thức thanh toán</h4>
                    <div class="logos">
                        <img src="img/visa.png" alt="VISA"> 
                        <img src="img/jcb.png"alt="JCB"> 
                        <img src="img/paypal.png" alt="PayPal">
                    </div>
                </div>
                <div class="shipping">
                    <h4>Đơn vị vận chuyển</h4>
                    <div class="logos2">
                        <img src="img/vietnampost.png" alt="VietPost"> 
                        <img src="img/ghtk.png" alt="GHN"> 
                        <img src="img/jt.png" alt="J&T Express"> 
                        <img src="img/kerry.png" alt="Kerry">
                    </div>
                </div>
            </div>
            <div class="catalog">
                <h4>Danh mục</h4>
                <ul>
                    <li><a href="index.jsp">Trang chủ</a></li>
                    <li><a href="#">Cửa hàng</a></li>
                    <li><a href="about.jsp">Giới thiệu</a></li>
                    <li><a href="news.jsp">Tin tức</a></li>
                    <li><a href="#">Liên hệ</a></li>
                </ul>
            </div>
            <div class="fangage">
                <h3>Fanpage</h3>
                <div class="social-icons">
                    <i class="bi bi-facebook"></i> 
                    <a href="#" aria-label="Facebook"> <img src="img/facebook1.png" alt="FB" width="30"></a> 
                    <a href="#" aria-label="YouTube"><img src="img/youtube.png" alt="YT" width="30"></a> 
                    <a href="#" aria-label="TikTok"><img src="img/tiktok.png" alt="TikTok" width="30"></a> 
                    <a href="#" aria-label="Instagram"><img src="img/instagram.png" alt="IG" width="30"></a>
                </div>
            </div>
        </div>
    </footer>
</body>
</html>