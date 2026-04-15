<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
<meta charset="UTF-8">
<title><fmt:message key="success.page_title" /> | Fashion Store</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Montserrat:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/order-success.css" />
</head>
<body>
    <header class="header">
        <a href="index.jsp"><img src="img/logover2_5.png" alt="Logo" class="logo" width="80"></a>
    </header>

    <div class="success-container">
        <div class="icon-box">
            <i class="fa-solid fa-check"></i>
        </div>

        <h1 class="success-title"><fmt:message key="success.heading" /></h1>

        <p class="success-desc">
            <fmt:message key="success.message1" /> <strong>Fashion Store</strong>.<br>
            <fmt:message key="success.message2" />
        </p>

        <div class="btn-group">
            <a href="index.jsp" class="btn-home"><fmt:message key="success.continue_shopping" /></a> 
            <a href="order-history" class="btn-order"><fmt:message key="success.view_order" /></a>
        </div>
    </div>
</body>
</html>