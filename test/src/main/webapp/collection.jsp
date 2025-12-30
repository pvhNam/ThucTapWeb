<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Bộ Sưu Tập | Fashion Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css"><link rel="stylesheet" href="CSS/collection.css">
</head>
<body>
    <jsp:include page="header.jsp"><jsp:param name="page" value="collection"/></jsp:include>
    <div class="collection-wrapper">
        <div class="collection-header"><h1>LOOKBOOK 2025</h1>
            <div class="filter-menu">
                <button class="filter-btn active" onclick="filterSelection('all')">Tất Cả</button>
                <button class="filter-btn" onclick="filterSelection('summer')">Mùa Hè</button>
                <button class="filter-btn" onclick="filterSelection('office')">Công Sở</button>
            </div>
        </div>
        <div class="gallery-grid">
            <div class="gallery-item" data-category="summer"><img src="img/maunangdong.jpg">
                <div class="item-overlay"><span class="collection-tag">Summer 2025</span><h2 class="collection-name">Tropical Paradise</h2><a href="index.jsp" class="btn-discover">KHÁM PHÁ</a></div>
            </div>
            </div>
    </div>
    <jsp:include page="footer.jsp" />
    <script>
        function filterSelection(c) {
            var x = document.getElementsByClassName("gallery-item");
            if (c == "all") c = "";
            for (var i = 0; i < x.length; i++) {
                x[i].style.display = (x[i].getAttribute("data-category").indexOf(c) > -1) ? "block" : "none";
            }
        }
    </script>
</body>
</html>