<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order, model.user"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
<meta charset="UTF-8">
<title><fmt:message key="history.page_title" /> | Fashion Store</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/oder-history.css" />
</head>
<body>
    <header>
        <jsp:include page="header.jsp"><jsp:param name="page" value="#" /></jsp:include>
    </header>

    <div class="history-container">
        <h1 class="page-title" style="text-align: left; font-size: 24px;">
            <fmt:message key="history.heading" />
        </h1>

        <%
        List<Order> list = (List<Order>) request.getAttribute("listOrders");
        DecimalFormat df = new DecimalFormat("#,### VNĐ");

        if (list == null || list.isEmpty()) {
        %>
        <div class="empty-cart" style="text-align: center; padding: 50px;">
            <i class="fa-solid fa-box-open" style="font-size: 40px; color: #ccc;"></i>
            <p><fmt:message key="history.empty" /></p>
            <a href="index.jsp" class="btn-shop-now"><fmt:message key="cart.shop_now" /></a>
        </div>
        <%
        } else {
        %>

        <table class="order-table">
            <thead>
                <tr>
                    <th><fmt:message key="history.id" /></th>
                    <th><fmt:message key="history.date" /></th>
                    <th><fmt:message key="history.address" /></th>
                    <th><fmt:message key="history.total" /></th>
                    <th><fmt:message key="history.status" /></th>
                    <th><fmt:message key="history.action" /></th>
                </tr>
            </thead>
            <tbody>
                <%
                for (Order o : list) {
                    String statusClass = "status-processing";
                    if (o.getStatus().contains("hủy") || o.getStatus().contains("Hủy") || o.getStatus().toLowerCase().contains("cancel"))
                        statusClass = "status-cancelled";
                    else if (o.getStatus().contains("Giao") || o.getStatus().contains("Thành công") || o.getStatus().toLowerCase().contains("success"))
                        statusClass = "status-shipped";
                %>
                <tr>
                    <td>#<%=o.getId()%></td>
                    <td><%=o.getCreatedAt()%></td>
                    <td><%=o.getAddress()%></td>
                    <td style="font-weight: bold; color: #d00;"><%=df.format(o.getTotalMoney())%></td>
                    <td><span class="status-tag <%=statusClass%>"><%=o.getStatus()%></span></td>
                    <td>
                        <a href="order-detail?id=<%=o.getId()%>" class="btn-view-detail">
                            <fmt:message key="history.view_detail" />
                        </a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

    <footer>
        <jsp:include page="footer.jsp" />
    </footer>
</body>
</html>