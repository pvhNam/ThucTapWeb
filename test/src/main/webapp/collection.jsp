<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, dao.ProductDAO, model.product"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bộ Sưu Tập | Fashion Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css">
    <link rel="stylesheet" href="CSS/collection.css">
</head>
<body>
    <jsp:include page="header.jsp">
        <jsp:param name="page" value="collection"/>
    </jsp:include>

    <div class="collection-wrapper">
        <div class="collection-header">
            <h1>LOOKBOOK 2025</h1>
            <div class="filter-menu">
                <button class="filter-btn active" onclick="filterSelection('all', this)">Tất Cả</button>
                <button class="filter-btn" onclick="filterSelection('summer', this)">Mùa Hè</button>
                <button class="filter-btn" onclick="filterSelection('office', this)">Công Sở</button>
                <button class="filter-btn" onclick="filterSelection('party', this)">Dạ Hội & Tiệc</button>
                <button class="filter-btn" onclick="filterSelection('new', this)">Hàng Mới</button>
            </div>
        </div>

        <div class="gallery-grid">
            <%
                ProductDAO pdao = new ProductDAO();
                List<product> products = pdao.getAllProducts();

                if (products != null) {
                    for (product p : products) {
                        // --- LOGIC TỰ ĐỘNG PHÂN LOẠI ---
                        String rawName = p.getPdescription(); // Lấy tên gốc
                        String nameLower = (rawName != null) ? rawName.toLowerCase() : "";
                        String categoryTags = "all"; // Mặc định ai cũng có tag 'all'

                        // 1. Phân loại Mùa Hè
                        if (nameLower.contains("hè") || nameLower.contains("summer") || nameLower.contains("biển") || nameLower.contains("thun")) {
                            categoryTags += " summer";
                        }
                        
                        // 2. Phân loại Công Sở
                        if (nameLower.contains("sơ mi") || nameLower.contains("âu") || nameLower.contains("vest") || nameLower.contains("công sở")) {
                            categoryTags += " office";
                        }

                        // 3. Phân loại Dạ Hội/Tiệc
                        if (nameLower.contains("váy") || nameLower.contains("đầm") || nameLower.contains("tiệc") || nameLower.contains("lụa")) {
                            categoryTags += " party";
                        }
                        
                        // 4. Phân loại Hàng Mới (Ví dụ: ID lớn hoặc logic khác, ở đây tạm set ngẫu nhiên hoặc logic ID > 10)
                        if (p.getPid() > 5) { // Giả sử ID > 5 là hàng mới nhập
                             categoryTags += " new";
                        }

                        // Chỉ hiển thị nếu sản phẩm thuộc ít nhất 1 nhóm (trừ all) hoặc bạn muốn hiện tất cả
                        // Ở đây ta render ra tất cả, JS sẽ làm nhiệm vụ ẩn hiện
            %>
            
            <div class="gallery-item show" data-category="<%= categoryTags %>">
                <img src="<%= (p.getImage() != null && !p.getImage().isEmpty()) ? p.getImage() : "img/no-image.png" %>" alt="<%= p.getPdescription() %>">
                
                <div class="item-overlay">
                    <span class="collection-tag">
                        <% if(categoryTags.contains("summer")) { %> SUMMER VIBES <% } 
                           else if(categoryTags.contains("office")) { %> OFFICE CHIC <% } 
                           else if(categoryTags.contains("party")) { %> PARTY NIGHT <% } 
                           else { %> DAILY WEAR <% } %>
                    </span>
                    
                    <h2 class="collection-name"><%= p.getPdescription() %></h2>
                    
                    <div class="collection-desc">
                        Thiết kế độc quyền, phong cách thời thượng dành riêng cho bạn.
                    </div>
                    
                    <a href="product-detail?pid=<%=p.getPid()%>" class="btn-discover">CHI TIẾT & MUA NGAY</a>
                </div>
            </div>

            <%      } 
                } 
            %>
        </div>
    </div>

    <jsp:include page="footer.jsp" />

    <script>
        // Chạy mặc định để hiển thị tất cả lúc đầu
        filterSelection("all", document.querySelector('.filter-btn.active'));

        function filterSelection(c, btnElement) {
            var x, i;
            x = document.getElementsByClassName("gallery-item");
            
            // 1. Xử lý Logic Ẩn/Hiện
            if (c == "all") c = ""; // Nếu chọn all thì chuỗi rỗng để match tất cả
            
            for (i = 0; i < x.length; i++) {
                removeClass(x[i], "show"); // Ẩn hết trước
                var itemTags = x[i].getAttribute("data-category");
                
                // Nếu tag của item chứa từ khóa filter -> Hiện lên
                if (itemTags.indexOf(c) > -1) {
                    addClass(x[i], "show");
                }
            }
            
            // 2. Xử lý đổi màu nút Active (Gạch chân vàng)
            if (btnElement) {
                var btns = document.getElementsByClassName("filter-btn");
                for (var j = 0; j < btns.length; j++) {
                    btns[j].classList.remove("active");
                }
                btnElement.classList.add("active");
            }
        }

        // Helper: Thêm class
        function addClass(element, name) {
            var arr1, arr2;
            arr1 = element.className.split(" ");
            arr2 = name.split(" ");
            for (var i = 0; i < arr2.length; i++) {
                if (arr1.indexOf(arr2[i]) == -1) {
                    element.className += " " + arr2[i];
                }
            }
        }

        // Helper: Xóa class
        function removeClass(element, name) {
            var arr1, arr2;
            arr1 = element.className.split(" ");
            arr2 = name.split(" ");
            for (var i = 0; i < arr2.length; i++) {
                while (arr1.indexOf(arr2[i]) > -1) {
                    arr1.splice(arr1.indexOf(arr2[i]), 1);
                }
            }
            element.className = arr1.join(" ");
        }
    </script>
</body>
</html>