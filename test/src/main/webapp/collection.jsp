<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.user"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lookbook & Collections</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
     <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Montserrat:wght@300;400;500;600&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="CSS/style.css" />
    <link rel="stylesheet" href="CSS/collection.css" />
</head>
<body>
    <header class="header">
        <a href="index.jsp"><img src="img/logover2_5.png" alt="Logo" class="logo" width="80"></a>
        <nav class="menu">
            <a href="index.jsp">TRANG CHỦ</a>
            <a href="collection.jsp" class="active">BỘ SƯU TẬP</a> 
            <a href="about.jsp">GIỚI THIỆU</a> 
            <a href="news.jsp">TIN TỨC</a>
        </nav>
        <div class="actions">
            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i> 
                <input type="text" placeholder="Tìm kiếm" />
            </div>
            <div class="account">
                <% user currentUser = (user) session.getAttribute("user");
                   if (currentUser == null) { %>
                    <a href="login.jsp">ĐĂNG NHẬP</a> | <a href="register.jsp">ĐĂNG KÍ</a>
                <% } else { %>
                    <div class="user-info">
                        <span>Hi, <%=currentUser.getUsername()%></span> 
                        <a href="profile.jsp"><img src="img/default-user.png" class="user-avatar"></a>
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Đăng xuất"><i class="fa-solid fa-right-from-bracket"></i></a>
                    </div>
                <% } %>
            </div>
            <a href="cart"><i class="fa-solid fa-cart-shopping"></i></a>
        </div>
    </header>

    <div class="collection-wrapper">
        
        <div class="collection-header">
            <h1>FASHION LOOKBOOK 2025</h1>
            
            <div class="filter-menu">
                <button class="filter-btn active" onclick="filterSelection('all')">Tất Cả</button>
                <button class="filter-btn" onclick="filterSelection('summer')">Mùa Hè</button>
                <button class="filter-btn" onclick="filterSelection('office')">Công Sở</button>
                <button class="filter-btn" onclick="filterSelection('party')">Dạ Hội</button>
                <button class="filter-btn" onclick="filterSelection('vintage')">Vintage</button>
            </div>
        </div>

        <div class="gallery-grid">
            
            <div class="gallery-item" data-category="summer">
                <img src="img/maunangdong.jpg" alt="Summer Vibes">
                <div class="item-overlay">
                    <span class="collection-tag">Summer 2025</span>
                    <h2 class="collection-name">Tropical Paradise</h2>
                    <p class="collection-desc">Hơi thở của biển cả trong từng thiết kế Linen thoáng mát.</p>
                    <a href="index.jsp" class="btn-discover">KHÁM PHÁ NGAY <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </div>

            <div class="gallery-item" data-category="office">
                <img src="img/congso.jpg" alt="Office Chic">
                <div class="item-overlay">
                    <span class="collection-tag">Office Wear</span>
                    <h2 class="collection-name">Modern CEO</h2>
                    <p class="collection-desc">Phong cách tối giản, quyền lực dành cho quý cô hiện đại.</p>
                    <a href="index.jsp" class="btn-discover">XEM CHI TIẾT <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </div>

            <div class="gallery-item" data-category="party">
                <img src="img/dangcap.jpg" alt="Party Night">
                <div class="item-overlay">
                    <span class="collection-tag">Evening Gown</span>
                    <h2 class="collection-name">Golden Hour</h2>
                    <p class="collection-desc">Tỏa sáng dưới ánh đèn với những thiết kế đính kết thủ công.</p>
                    <a href="index.jsp" class="btn-discover">XEM CHI TIẾT <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </div>

            <div class="gallery-item" data-category="summer">
                <img src="https://images.unsplash.com/photo-1523381210434-271e8be1f52b?q=80&w=2070&auto=format&fit=crop" alt="Beach Wear">
                <div class="item-overlay">
                    <span class="collection-tag">Beach Wear</span>
                    <h2 class="collection-name">Sun & Sand</h2>
                    <p class="collection-desc">Phụ kiện và trang phục đi biển mới nhất.</p>
                    <a href="index.jsp" class="btn-discover">KHÁM PHÁ NGAY <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </div>

             <div class="gallery-item" data-category="vintage">
                <img src="https://images.unsplash.com/photo-1550614000-4b9519e09963?q=80&w=2070&auto=format&fit=crop" alt="Vintage">
                <div class="item-overlay">
                    <span class="collection-tag">Classic</span>
                    <h2 class="collection-name">Retro 90s</h2>
                    <p class="collection-desc">Sự trở lại của những biểu tượng thời trang thập niên 90.</p>
                    <a href="index.jsp" class="btn-discover">KHÁM PHÁ NGAY <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </div>

        </div>
    </div>

    <footer class="footer">
        <div class="footer-top">
            <div class="contact">
                <h3>Liên Hệ</h3>
                <p><strong>☎️</strong> 0981774313</p>
                <p><strong>✉️</strong> tranthanglo@gmail.com</p>
                <p><strong>📍</strong> S2, đường Hải Triều, Q.1, TP HCM</p>
            </div>
            </div>
    </footer>

    <script>
        function filterSelection(category) {
            var items = document.getElementsByClassName("gallery-item");
            
            // Xử lý Active cho nút bấm
            var btns = document.getElementsByClassName("filter-btn");
            for (var i = 0; i < btns.length; i++) {
                btns[i].addEventListener("click", function() {
                    var current = document.getElementsByClassName("active");
                    current[0].className = current[0].className.replace(" active", "");
                    this.className += " active";
                });
            }

            // Xử lý ẩn hiện Item
            if (category == "all") category = "";
            for (var i = 0; i < items.length; i++) {
                items[i].classList.remove("hide"); // Hiện tất cả trước
                
                // Nếu item không chứa class category tương ứng -> Ẩn
                if (items[i].getAttribute("data-category").indexOf(category) == -1) {
                    items[i].classList.add("hide");
                }
            }
        }
    </script>
</body>
</html>