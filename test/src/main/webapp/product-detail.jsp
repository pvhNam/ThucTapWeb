<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.product, model.user, java.text.DecimalFormat"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<%
product p = (product) request.getAttribute("p");
if (p == null) {
    response.sendRedirect("index.jsp");
    return;
}
DecimalFormat df = new DecimalFormat("#,### VNĐ");
%>

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
<meta charset="UTF-8">
<title><%=p.getPdescription()%> | Fashion Store</title> 
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Montserrat:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/product-detail.css" />
</head>
<body>
    <header> 
        <jsp:include page="header.jsp"><jsp:param name="page" value="index"/></jsp:include>
    </header>

    <div class="back-nav">
        <a href="javascript:history.back()" class="btn-back">
            <i class="fa-solid fa-arrow-left-long"></i> <fmt:message key="product.back" />
        </a>
    </div>

    <div class="detail-wrapper">
        <div class="detail-left">
            <img src="<%=(p.getImage() != null) ? p.getImage() : "img/no-image.png"%>" alt="Product">
        </div>

        <div class="detail-right">
            <span class="p-cat"><fmt:message key="product.code" />: #<%=p.getPid()%></span>
            <h1 class="p-title"><%=p.getPdescription()%></h1>
            <div class="p-price"><%=df.format(p.getPrice())%></div>

            <div class="meta-info">
                <div class="meta-row">
                    <span class="meta-label"><fmt:message key="product.color" />:</span> <span><%=p.getColor()%></span>
                </div>
                <div class="meta-row">
                    <span class="meta-label"><fmt:message key="product.size" />:</span> <span><%=p.getSize()%></span>
                </div>
                <div class="meta-row">
                    <span class="meta-label"><fmt:message key="product.status" />:</span>
                    <% if (p.getStockquantyti() > 0) { %>
                    <span class="stock-tag instock"><fmt:message key="product.instock" /> (<%=p.getStockquantyti()%>)</span>
                    <% } else { %>
                    <span class="stock-tag outstock"><fmt:message key="product.outstock" /></span>
                    <% } %>
                </div>
            </div>

            <p class="p-desc">
                <%=p.getPdescription()%>. <fmt:message key="product.desc_default" />
            </p>

            <form action="cart" method="post" class="action-box">
                <input type="hidden" name="action" value="add"> 
                <input type="hidden" name="pid" value="<%=p.getPid()%>">

                <% if (p.getStockquantyti() > 0) { %>
                <input type="number" name="quantity" value="1" min="1" max="<%=p.getStockquantyti()%>" class="qty-input">
                <button type="submit" class="btn-add-cart-detail"><fmt:message key="home.product.add_cart" /></button>
                <% } else { %>
                <input type="number" value="0" disabled class="qty-input" style="background: #eee; color: #999;">
                <button type="button" class="btn-add-cart-detail btn-disabled"><fmt:message key="product.temp_out" /></button>
                <% } %>
            </form>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>