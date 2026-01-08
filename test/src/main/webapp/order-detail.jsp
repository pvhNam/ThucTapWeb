<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, dao.OrderDAO, model.OrderDetail, model.Order, model.user, java.text.DecimalFormat"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="order.detail_title" /> | Fashion Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css" />
   <style>
body {
	background: #f4f6f9;
	font-family: 'Montserrat', sans-serif;
}

.detail-container {
	max-width: 1000px;
	margin: 40px auto;
	background: white;
	padding: 30px;
	border-radius: 8px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
}

.head-title {
	font-size: 22px;
	font-weight: bold;
	margin-bottom: 20px;
	padding-bottom: 15px;
	border-bottom: 2px solid #eee;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.customer-info {
	background: #f8f9fa;
	padding: 20px;
	border-radius: 6px;
	margin-bottom: 30px;
	border: 1px solid #e9ecef;
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 10px;
}

.info-row {
	font-size: 15px;
	color: #333;
}

.info-row strong {
	color: #555;
	margin-right: 10px;
}

.detail-table {
	width: 100%;
	border-collapse: collapse;
}

.detail-table th {
	background: #1a1a1a;
	color: white;
	padding: 12px;
	text-align: left;
}

.detail-table td {
	padding: 15px;
	border-bottom: 1px solid #eee;
	vertical-align: middle;
}

.img-thumb {
	width: 60px;
	height: 75px;
	object-fit: cover;
	border-radius: 4px;
	margin-right: 15px;
}

.total-row {
	font-size: 20px;
	font-weight: bold;
	color: #d00000;
	text-align: right;
	padding-top: 20px;
}

.action-buttons {
        display: flex; justify-content: space-between; align-items: center;
        margin-top: 30px; border-top: 1px solid #eee; padding-top: 20px;
    }

    .btn-back-link {
        display: inline-flex; align-items: center; gap: 8px; text-decoration: none; color: #666; font-weight: 600;
        transition: 0.3s;
    }
    .btn-back-link:hover { color: #333; }

    .btn-cancel {
        background-color: #dc3545; color: white; padding: 10px 20px;
        border: none; border-radius: 4px; cursor: pointer; font-weight: bold;
        display: inline-flex; align-items: center; gap: 5px; transition: 0.3s; font-size: 14px;
    }
    .btn-cancel:hover { background-color: #c82333; }
</style>
</head>
<%
    // 1. Khai báo link mặc định
    String backLink = "order-history"; 
    
    // 2. Lấy user từ session (Lưu ý: model.user viết thường theo code của bạn)
    model.user currentUser = (model.user) session.getAttribute("user"); 
    
    // 3. Logic kiểm tra
    boolean isAdmin = false;
    String currentUsername = "";
    String currentFullname = ""; // Biến chứa họ tên

    if (currentUser != null) {
        // Lấy thông tin (Giả định model.user có hàm getUsername và getFullName)
        // Nếu hàm getFullName() bên model của bạn tên khác (vd: getName), hãy sửa lại dòng dưới
        currentUsername = currentUser.getUsername();
        try { currentFullname = currentUser.getFullname(); } catch (Exception e) { currentFullname = "Chưa lấy được (Check tên hàm)"; }

        // --- CHECK ADMIN ---
//         // Cách 1: Check theo Username (admin)
//         if (currentUsername != null && "Administrator".equalsIgnoreCase(currentUsername.trim())) {
//             backLink = "admin.jsp"; 
//             isAdmin = true;
//         }
        
        // Cách 2: Check theo Fullname (Nếu bạn muốn check bằng tên đầy đủ)
        // Bỏ comment dòng dưới và thay "Admin Quản Lý" bằng tên thật trong DB của bạn
        
        if (currentFullname != null && currentFullname.equalsIgnoreCase("Administrator")) {
            backLink = "admin"; 
            isAdmin = true;
        }
        
    }
%>

<div style="background: #fff3cd; color: #856404; padding: 15px; border: 1px solid #ffeeba; margin: 10px; font-family: monospace;">
    <strong>🔍 DEBUG INFO:</strong><br>
    - Session User Object: <%= (currentUser == null ? "NULL (Chưa đăng nhập)" : "Đã lấy được") %><br>
    <% if (currentUser != null) { %>
        - Username: [<%= currentUsername %>]<br>
        - Fullname: [<%= currentFullname %>] <br>
        - Link nút Back hiện tại: [<%= backLink %>]<br>
        - Là Admin?: <%= isAdmin ? "ĐÚNG" : "SAI" %>
    <% } %>
</div>
<body>
    <jsp:include page="header.jsp" />

    <div class="detail-container">
        <%
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int orderId = Integer.parseInt(idParam);
                OrderDAO dao = new OrderDAO();
                Order order = dao.getOrderById(orderId);
                List<OrderDetail> details = dao.getDetails(orderId);

                if (order != null) {
                    DecimalFormat df = new DecimalFormat("#,### VNĐ");
        %>
        <div class="head-title">
            <span><i class="fa-solid fa-file-invoice"></i> <fmt:message key="order.id" /> #<%=order.getId()%></span>
            <span style="font-size: 14px; background: #d4edda; color: #155724; padding: 5px 12px; border-radius: 20px;">
                <%=order.getStatus()%>
            </span>
        </div>

        <div class="customer-info">
            <div class="info-row"><strong><fmt:message key="order.receiver" />:</strong> <%=order.getUserName()%></div>
            <div class="info-row"><strong><fmt:message key="order.date" />:</strong> <%=order.getCreatedAt()%></div>
            <div class="info-row" style="grid-column: span 2;"><strong><fmt:message key="order.address" />:</strong> <%=order.getAddress()%></div>
        </div>

        <table class="detail-table">
            <thead>
                <tr>
                    <th><fmt:message key="order.product" /></th>
                    <th style="text-align: center;"><fmt:message key="order.price" /></th>
                    <th style="text-align: center;"><fmt:message key="order.quantity" /></th>
                    <th style="text-align: right;"><fmt:message key="order.subtotal" /></th>
                </tr>
            </thead>
            <tbody>
                <% for (OrderDetail item : details) { double subTotal = item.getPrice() * item.getQuantity(); %>
                <tr>
                    <td style="display: flex; align-items: center;">
                        <img src="<%=item.getProduct().getImage()%>" class="img-thumb">
                        <div>
                            <div style="font-weight: 600;"><%=item.getProduct().getPdescription()%></div>
                            <small>Size: <%=item.getProduct().getSize()%> | Color: <%=item.getProduct().getColor()%></small>
                        </div>
                    </td>
                    <td style="text-align: center;"><%=df.format(item.getPrice())%></td>
                    <td style="text-align: center;">x <%=item.getQuantity()%></td>
                    <td style="text-align: right; font-weight: bold;"><%=df.format(subTotal)%></td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <div class="total-row"><fmt:message key="order.total" />: <%=df.format(order.getTotalMoney())%></div>
        
        

        <div class="action-buttons">
            <a href="<%= backLink %>" class="btn-back-link"> 
                <i class="fa-solid fa-arrow-left"></i> <fmt:message key="order.back" />
            </a>

            <% if (order.getStatus() != null && order.getStatus().equals("Đang xử lý")) { %>
                <form action="order-detail" method="post" onsubmit="return confirm('<fmt:message key="order.cancel_confirm" />');" style="margin: 0;">
                    <input type="hidden" name="id" value="<%= order.getId() %>">
                    <input type="hidden" name="action" value="cancel">
                    <button type="submit" class="btn-cancel"><i class="fa-solid fa-xmark"></i> <fmt:message key="order.cancel_btn" /></button>
                </form>
            <% } %>
        </div>
        <% } else { %>
            <div style="text-align: center; padding: 40px;">
                <i class="fa-regular fa-folder-open" style="font-size: 40px; color: #ccc; margin-bottom: 15px;"></i>
                <p><fmt:message key="order.not_found" /></p>
                <a href="<%= backLink %>" class="btn-back-link"><fmt:message key="order.back" /></a>
            </div>
        <% }
            } catch (Exception e) { %>
            <p style="color: red;">Error: <%=e.getMessage()%></p>
            <a href="<%= backLink %>" class="btn-back-link"><fmt:message key="order.back" /></a>
        <% }
        } else { %>
            <p style="text-align: center; padding: 30px;"><fmt:message key="order.invalid_id" /></p>
            <a href="<%= backLink %>" class="btn-back-link" style="justify-content: center;"><fmt:message key="order.back" /></a>
        <% } %>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>