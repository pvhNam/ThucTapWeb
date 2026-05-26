<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order, model.User"%>
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
    <%-- KHÔNG đặt oder-history.css ở đây nữa --%>
</head>
<body>
<header>
    <jsp:include page="header.jsp"><jsp:param name="page" value="#" /></jsp:include>
</header>

<%-- Đặt SAU header.jsp để load sau Header.css, đảm bảo thắng --%>
<link rel="stylesheet" href="CSS/user/oder-history.css" />

<div class="history-container">
    <h1 class="page-title" style="text-align: left; font-size: 24px;">
        <fmt:message key="history.heading" />
    </h1>

    <%
        List<Order> list = (List<Order>) request.getAttribute("listOrders");
        String activeTab = request.getParameter("tab");
        if (activeTab == null || activeTab.isEmpty()) activeTab = "all";
        DecimalFormat df = new DecimalFormat("#,### VNĐ");
    %>

    <!-- Tab navigation -->
    <div class="order-tabs">
        <a href="order-history?tab=all" class="tab-item <%= "all".equals(activeTab) ? "active" : "" %>">
            <i class="fa-solid fa-list"></i> Tất cả
        </a>
        <a href="order-history?tab=shipping" class="tab-item <%= "shipping".equals(activeTab) ? "active" : "" %>">
            <i class="fa-solid fa-truck"></i> Đang giao
        </a>
        <a href="order-history?tab=success" class="tab-item <%= "success".equals(activeTab) ? "active" : "" %>">
            <i class="fa-solid fa-circle-check"></i> Đã giao
        </a>
        <a href="order-history?tab=pending" class="tab-item <%= "pending".equals(activeTab) ? "active" : "" %>">
            <i class="fa-solid fa-clock"></i> Chưa giao
        </a>
        <a href="order-history?tab=cancelled" class="tab-item <%= "cancelled".equals(activeTab) ? "active" : "" %>">
            <i class="fa-solid fa-ban"></i> Đã hủy
        </a>
    </div>

    <%
        if (list == null || list.isEmpty()) {
    %>
    <div class="empty-cart" style="text-align: center; padding: 50px;">
        <i class="fa-solid fa-box-open" style="font-size: 40px; color: #ccc;"></i>
        <p><fmt:message key="history.empty" /></p>
        <a href="index.jsp" class="btn-shop-now"><fmt:message key="cart.shop_now" /></a>
    </div>
    <%
    } else {
        List<Order> filteredList = new java.util.ArrayList<>();
        for (Order o : list) {
            String normalized = o.getNormalizedStatus();
            boolean include = false;
            switch (activeTab) {
                case "shipping":
                    include = model.Order.STATUS_SHIPPING.equals(normalized);
                    break;
                case "success":
                    include = model.Order.STATUS_SUCCESS.equals(normalized);
                    break;
                case "pending":
                    include = model.Order.STATUS_PROCESSING.equals(normalized)
                            || model.Order.STATUS_PENDING_MOMO.equals(normalized)
                            || model.Order.STATUS_PAID_PROCESSING.equals(normalized);
                    break;
                case "cancelled":
                    include = model.Order.STATUS_CANCELLED.equals(normalized)
                            || model.Order.STATUS_MOMO_FAILED.equals(normalized);
                    break;
                default:
                    include = true;
                    break;
            }
            if (include) filteredList.add(o);
        }

        if (filteredList.isEmpty()) {
    %>
    <div class="empty-cart" style="text-align: center; padding: 50px;">
        <i class="fa-solid fa-box-open" style="font-size: 40px; color: #ccc;"></i>
        <p>Không có đơn hàng nào trong mục này.</p>
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
            for (Order o : filteredList) {
                String statusClass;
                String normalized = o.getNormalizedStatus();
                if (model.Order.STATUS_CANCELLED.equals(normalized) || model.Order.STATUS_MOMO_FAILED.equals(normalized)) {
                    statusClass = "status-cancelled";
                } else if (model.Order.STATUS_SUCCESS.equals(normalized)) {
                    statusClass = "status-success";
                } else if (model.Order.STATUS_SHIPPING.equals(normalized)) {
                    statusClass = "status-shipped";
                } else {
                    statusClass = "status-processing";
                }
        %>
        <tr>
            <td>#<%=o.getId()%></td>
            <td><%=o.getCreatedAt()%></td>
            <td><%=o.getAddress()%></td>
            <td style="font-weight: bold; color: #d00;"><%=df.format(o.getTotalMoney())%></td>
            <td><span class="status-tag <%=statusClass%>"><%=o.getDisplayStatus()%></span></td>
            <td>
                <a href="order-detail?id=<%=o.getId()%>" class="btn-view-detail">
                    <fmt:message key="history.view_detail" />
                </a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <%
            }
        }
    %>
</div>

<footer>
    <jsp:include page="footer.jsp" />
</footer>
</body>
</html>
