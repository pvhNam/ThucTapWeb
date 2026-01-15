<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.util.HashMap"%>
<%@ page import="dao.ProductDAO, dao.VoucherDAO, dao.CartDAO"%>
<%@ page import="model.product, model.Voucher, model.user, model.cartItem"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<%--  đa ngôn ngữ  --%>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'vi'}">
<head>
<meta charset="UTF-8">
<title><fmt:message key="home.page_title" /> | Fashion Store</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css">
<link rel="stylesheet" href="CSS/index.css">
</head>
<body>
    <jsp:include page="header.jsp">
        <jsp:param name="page" value="index" />
    </jsp:include>
    <%
        Map<Integer, Integer> mapCart = new HashMap<>();
        user currentUser = (user) session.getAttribute("user");
        List<cartItem> currentCartList = null;

        // Lấy giỏ hàng (từ DB nếu đã login, hoặc từ Session nếu chưa)
        if (currentUser != null) {
            CartDAO cDao = new CartDAO();
            currentCartList = cDao.getCartByUid(currentUser.getUid());
        } else {
            currentCartList = (List<cartItem>) session.getAttribute("cart");
        }

        // Đổ dữ liệu vào Map để tra cứu nhanh
        if (currentCartList != null) {
            for (cartItem item : currentCartList) {
                mapCart.put(item.getProduct().getPid(), item.getQuantity());
            }
        }
    %>

    <div class="hero-banner" style="background-image: url('img/banner.png');">
        <div class="hero-content">
            <span class="hero-subtitle"><fmt:message key="home.hero.subtitle" /></span>
            <h1 class="hero-title"><fmt:message key="home.hero.title" /></h1>
            <a href="#products" class="btn-hero"><fmt:message key="home.hero.btn" /></a>
        </div>
    </div>

    <div class="container voucher-section">
        <div class="section-header" style="display: flex; justify-content: space-between; align-items: center;">
            <h2><fmt:message key="home.voucher.title" /></h2>
            <% Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
               if (isAdmin != null && isAdmin) { %>
            <a href="admin-add-voucher.jsp" class="btn-add-cart" style="width: auto; margin: 0; background: #27ae60;"> 
                + <fmt:message key="home.voucher.add" />
            </a>
            <% } %>
        </div>

        <div class="voucher-grid">
            <%
                VoucherDAO vdao = new VoucherDAO();
                List<Voucher> vouchers = vdao.getAllVouchers();
                DecimalFormat df = new DecimalFormat("#,###");
                if (vouchers != null) {
                    for (Voucher v : vouchers) {
                        String amountDisplay = "PERCENT".equals(v.getDiscountType()) 
                                           ? (int)v.getDiscountAmount() + "%" 
                                           : df.format(v.getDiscountAmount() / 1000) + "K";
                        String unitDisplay = "PERCENT".equals(v.getDiscountType()) ? "OFF" : "VNĐ";
            %>
            <div class="voucher-card">
                <div class="voucher-left">
                    <span class="voucher-amount"><%= amountDisplay %></span> 
                    <span class="voucher-unit"><%= unitDisplay %></span>
                </div>
                <div class="voucher-right">
                    <div class="voucher-info">
                        <span class="voucher-code"><%= v.getCode() %></span>
                        <h4 class="voucher-desc"><%= v.getDescription() %></h4>
                        <p class="voucher-expiry">
                            <%= v.getMinOrder() > 0 ? "Min: " + df.format(v.getMinOrder()) + "đ" : "Exp: " + v.getExpiryDate() %>
                        </p>
                    </div>
                    <button class="btn-save-voucher" onclick="saveVoucher(this, '<%= v.getCode() %>')">
                        <fmt:message key="home.voucher.save" />
                    </button>
                </div>
            </div>
            <% } } %>
        </div>
    </div>

    <div class="container product-section">
        <div class="section-header" id="products">
            <h2><fmt:message key="home.product.title" /></h2>
            <div class="section-line"></div>
        </div>

        <div class="product-grid">
            <%
                ProductDAO pdao = new ProductDAO();
                List<product> products = pdao.getAllProducts();
                DecimalFormat dfFull = new DecimalFormat("#,### VNĐ");
                
                if (products != null && !products.isEmpty()) {
                    int count = 0;
                    int maxDisplay = 8;
                    
                    for (product p : products) {
                        if (count >= maxDisplay) break;
                        count++;
                        
                        // --- BƯỚC 3: KIỂM TRA TỒN KHO VS GIỎ HÀNG ---
                        int stock = p.getStockquantyti(); // Tồn kho thực tế
                        int inCart = mapCart.getOrDefault(p.getPid(), 0); // Số lượng đã có trong giỏ
                        boolean canAdd = (inCart < stock); // Còn thêm được không?
            %>
            <div class="product-card">
                <div class="product-image">
                    <a href="product-detail?pid=<%=p.getPid()%>"> 
                        <img src="<%= (p.getImage() != null) ? p.getImage() : "img/no-image.png" %>" alt="<%=p.getPdescription()%>">
                    </a> 
                    <a href="product-detail?pid=<%=p.getPid()%>" class="overlay-btn">
                        <i class="fa-regular fa-eye"></i>
                    </a>
                    
                    <%-- Hiển thị nhãn Hết hàng nếu kho = 0 --%>
                    <% if (stock <= 0) { %>
                        <span style="position: absolute; top: 10px; left: 10px; background: #e74a3b; color: white; padding: 5px 10px; font-size: 12px; font-weight: bold; border-radius: 4px;">SOLD OUT</span>
                    <% } %>
                </div>
                
                <div class="product-details">
                    <h3 class="product-name">
                        <a href="product-detail?pid=<%=p.getPid()%>"><%=p.getPdescription()%></a>
                    </h3>
                    <span class="price"><%=dfFull.format(p.getPrice())%></span>
                    
                    <form action="cart" method="post">
                        <input type="hidden" name="action" value="add"> 
                        <input type="hidden" name="pid" value="<%=p.getPid()%>"> 
                        <input type="hidden" name="quantity" value="1">
                        
                        <% if (canAdd && stock > 0) { %>
                            <%-- TRƯỜNG HỢP: VẪN CÒN HÀNG ĐỂ THÊM --%>
                            <button type="submit" class="btn-add-cart">
                                <fmt:message key="home.product.add_cart" />
                            </button>
                        <% } else { %>
                            <%-- TRƯỜNG HỢP: ĐÃ HẾT HÀNG HOẶC ĐẠT GIỚI HẠN --%>
                            <button type="button" class="btn-add-cart" disabled 
                                    style="background-color: #ccc; color: #666; cursor: not-allowed; border: 1px solid #ccc;">
                                <% if (stock <= 0) { %>
                                    Hết hàng
                                <% } else { %>
                                    Đã đạt giới hạn
                                <% } %>
                            </button>
                        <% } %>
                    </form>
                </div>
            </div>
            <% 
                    } 
                } 
            %>
        </div>

        <div style="text-align: center; margin-top: 40px; margin-bottom: 20px;">
            <a href="about.jsp" class="btn-see-more"> 
                <fmt:message key="home.see_more" /> <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>
    </div>

    <jsp:include page="footer.jsp" />

    <script>
    function saveVoucher(btn, code) {
        let originalText = btn.innerText;
        btn.innerText = "...";
        
        fetch('voucher', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=save&code=' + code
        })
        .then(response => response.text())
        .then(data => {
            let result = data.trim();
            if (result === "SUCCESS") {
                btn.innerText = "Saved ✓"; 
                btn.style.background = "#1a1a1a"; 
                btn.style.color = "#d4af37"; 
                btn.style.border = "1px solid #1a1a1a";
                btn.disabled = true; 
            } else if (result === "EXISTED") {
                alert("Bạn đã lưu mã này rồi!");
                btn.innerText = "Saved";
                btn.disabled = true;
            } else if (result === "LOGIN_REQUIRED") {
                if(confirm("Bạn cần đăng nhập để lưu mã. Đi đến trang đăng nhập?")) {
                    window.location.href = "login.jsp";
                } else {
                    btn.innerText = originalText;
                }
            } else {
                alert("Lỗi: " + result);
                btn.innerText = originalText;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            btn.innerText = originalText;
        });
    }
    </script>
</body>
</html>