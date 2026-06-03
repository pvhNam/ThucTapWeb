<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, dao.OrderDAO, model.OrderDetail, model.Order, model.User, java.text.DecimalFormat"%>
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
    <link rel="stylesheet" href="CSS/user/order-detail.css">
</head>
<%
    String backLink = "order-history";
    model.User currentUser = (model.User) session.getAttribute("user");

    if (currentUser != null) {
        String currentFullname = "";
        try {
            currentFullname = currentUser.getFullname();
        } catch (Exception e) {
            currentFullname = "";
        }

        if (currentFullname != null && currentFullname.equalsIgnoreCase("Administrator")) {
            backLink = "admin";
        }
    }
%>

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
            <div class="info-row"><strong>Thanh toan:</strong> <%=order.getPaymentMethod()%></div>
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
                <% for (OrderDetail item : details) {
                    double subTotal = item.getPrice() * item.getQuantity();
                %>
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

            <% if (order.getStatus() != null
                    && (Order.STATUS_PROCESSING.equals(order.getStatus())
                        || Order.STATUS_PENDING_MOMO.equals(order.getStatus()))) { %>
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
