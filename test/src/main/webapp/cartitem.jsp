<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.cartItem, model.user, model.Voucher"%>
<%@ page import="java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ Hàng | Fashion Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Montserrat:wght@300;400;500;600&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="CSS/style.css" />
    <link rel="stylesheet" href="CSS/cart.css" />
</head>
<body>
    <header class="header">
        <a href="index.jsp"><img src="img/logover2_5.png" alt="Logo" class="logo" width="80"></a>
        <nav class="menu">
            <a href="index.jsp">CỬA HÀNG</a>
            <a href="collection.jsp">BỘ SƯU TẬP</a> 
            <a href="about.jsp">GIỚI THIỆU</a> 
            <a href="news.jsp">TIN TỨC</a>
        </nav>
        <div class="actions">
            <div class="account">
                <% user currentUser = (user) session.getAttribute("user");
                   if (currentUser == null) { %>
                    <a href="login.jsp">ĐĂNG NHẬP</a> | <a href="register.jsp">ĐĂNG KÍ</a>
                <% } else { %>
                    <div class="user-info">
                        <span>Hi, <%=currentUser.getUsername()%></span> 
                        <a href="profile.jsp"><img src="img/default-user.png" class="user-avatar" width="30"></a>
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">(Thoát)</a>
                    </div>
                <% } %>
            </div>
            <a href="cart"><i class="fa-solid fa-cart-shopping"></i></a>
        </div>
    </header>

    <div class="cart-wrapper">
        <h1 class="page-title">GIỎ HÀNG CỦA BẠN</h1>

        <div class="cart-layout">
            
            <div class="cart-items-section">
                <% 
                    List<cartItem> list = (List<cartItem>) request.getAttribute("cartList");
                    DecimalFormat df = new DecimalFormat("#,### VNĐ");
                    
                    if (list != null && !list.isEmpty()) {
                        for (cartItem item : list) {
                            String imgUrl = (item.getProduct().getImage() != null) ? item.getProduct().getImage() : "img/no-image.png";
                %>
                    <div class="cart-card">
                        <div class="card-img">
                            <img src="<%= imgUrl %>" alt="Product">
                        </div>
                        <div class="card-details">
                            <div class="card-info">
                                <h3><%= item.getProduct().getPdescription() %></h3>
                                <p class="variant">Size: <%= item.getProduct().getSize() %> | Màu: <%= item.getProduct().getColor() %></p>
                                <p class="price"><%= df.format(item.getProduct().getPrice()) %></p>
                            </div>
                            
                            <div class="card-actions">
                                <div class="qty-control">
                                    <form action="cart" method="post">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="pid" value="<%= item.getProduct().getPid() %>">
                                        <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>">
                                        <button class="qty-btn minus">-</button>
                                    </form>
                                    <span class="qty-val"><%= item.getQuantity() %></span>
                                    <form action="cart" method="post">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="pid" value="<%= item.getProduct().getPid() %>">
                                        <input type="hidden" name="quantity" value="<%= item.getQuantity() + 1 %>">
                                        <button class="qty-btn plus">+</button>
                                    </form>
                                </div>
                                
                                <div class="item-total-group">
                                    <span class="item-total"><%= df.format(item.getTotalPrice()) %></span>
                                    <form action="cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="pid" value="<%= item.getProduct().getPid() %>">
                                        <button class="remove-btn" onclick="return confirm('Xóa sản phẩm này?')"><i class="fa-solid fa-xmark"></i></button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                <% 
                        }
                    } else {
                %>
                    <div class="empty-cart">
                        <i class="fa-solid fa-basket-shopping"></i>
                        <p>Giỏ hàng của bạn đang trống.</p>
                        <a href="index.jsp" class="btn-shop-now">MUA SẮM NGAY</a>
                    </div>
                <% } %>
            </div>

            <div class="cart-summary-section">
                <div class="summary-box">
                    <h3>THÔNG TIN ĐƠN HÀNG</h3>
                    
                    <% if(currentUser != null) { 
                       int walletCount = (Integer) request.getAttribute("walletCount");
                    %>
                    <div class="wallet-badge">
                        <i class="fa-solid fa-ticket"></i> Bạn có <b><%= walletCount %></b> mã ưu đãi
                    </div>
                    <% } %>

                    <% 
                        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");
                        String voucherError = (String) request.getAttribute("voucherError");
                        String flashMsg = (String) session.getAttribute("flashMsg");
                        session.removeAttribute("flashMsg"); // Xóa msg sau khi hiện
                    %>
                    <div class="voucher-box">
                        <label>Mã giảm giá</label>
                        <% if(appliedVoucher == null) { %>
                            <form action="cart" method="post" class="voucher-form">
                                <input type="hidden" name="action" value="apply_voucher">
                                <input type="text" name="voucherCode" placeholder="Nhập mã (VD: WELCOME10)" required>
                                <button type="submit">ÁP DỤNG</button>
                            </form>
                            <% if(flashMsg != null) { %> <p class="msg-error"><%= flashMsg %></p> <% } %>
                            <% if(voucherError != null) { %> <p class="msg-error"><%= voucherError %></p> <% } %>
                        <% } else { %>
                            <div class="voucher-active">
                                <span><i class="fa-solid fa-tag"></i> <%= appliedVoucher.getCode() %></span>
                                <form action="cart" method="post">
                                    <input type="hidden" name="action" value="remove_voucher">
                                    <button class="remove-voucher">Hủy</button>
                                </form>
                            </div>
                            <p class="msg-success">Đã áp dụng mã giảm giá!</p>
                        <% } %>
                    </div>

                    <div class="divider"></div>

                    <% 
                        double subtotal = (Double) request.getAttribute("subtotal");
                        double discount = (Double) request.getAttribute("discountAmount");
                        double finalTotal = (Double) request.getAttribute("finalTotal");
                    %>
                    <div class="summary-row">
                        <span>Tạm tính</span>
                        <span><%= df.format(subtotal) %></span>
                    </div>
                    <% if(discount > 0) { %>
                    <div class="summary-row discount">
                        <span>Giảm giá</span>
                        <span>- <%= df.format(discount) %></span>
                    </div>
                    <% } %>
                    
                    <div class="divider"></div>
                    
                    <div class="summary-row total">
                        <span>Tổng cộng</span>
                        <span><%= df.format(finalTotal) %></span>
                    </div>

                    <a href="checkout" class="btn-checkout">TIẾN HÀNH THANH TOÁN</a>
                </div>
            </div>

        </div>
    </div>
    
    <footer class="footer">
        </footer>
</body>
</html>