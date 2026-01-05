<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, dao.ProductDAO, model.product"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="collection.page_title" /> | Fashion Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css">
    <link rel="stylesheet" href="CSS/collection.css">
</head>
<body>
    <jsp:include page="header.jsp"><jsp:param name="page" value="collection"/></jsp:include>

    <div class="collection-wrapper">
        <div class="collection-header">
            <h1><fmt:message key="collection.lookbook" /></h1>
            <div class="filter-menu">
                <button class="filter-btn active" onclick="filterSelection('all', this)"><fmt:message key="collection.filter_all" /></button>
                <button class="filter-btn" onclick="filterSelection('summer', this)"><fmt:message key="collection.filter_summer" /></button>
                <button class="filter-btn" onclick="filterSelection('office', this)"><fmt:message key="collection.filter_office" /></button>
                <button class="filter-btn" onclick="filterSelection('party', this)"><fmt:message key="collection.filter_party" /></button>
                <button class="filter-btn" onclick="filterSelection('new', this)"><fmt:message key="collection.filter_new" /></button>
            </div>
        </div>

        <div class="gallery-grid">
            <%
                ProductDAO pdao = new ProductDAO();
                List<product> products = pdao.getAllProducts();
                if (products != null) {
                    for (product p : products) {
                        // Logic phân loại (giữ nguyên logic Java)
                        String rawName = p.getPdescription();
                        String nameLower = (rawName != null) ? rawName.toLowerCase() : "";
                        String categoryTags = "all";
                        if (nameLower.contains("hè") || nameLower.contains("summer") || nameLower.contains("biển")) categoryTags += " summer";
                        if (nameLower.contains("sơ mi") || nameLower.contains("âu") || nameLower.contains("vest") || nameLower.contains("công sở")) categoryTags += " office";
                        if (nameLower.contains("váy") || nameLower.contains("đầm") || nameLower.contains("tiệc")) categoryTags += " party";
                        if (p.getPid() > 5) categoryTags += " new";
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
                    <div class="collection-desc"><fmt:message key="collection.item_desc" /></div>
                    <a href="product-detail?pid=<%=p.getPid()%>" class="btn-discover"><fmt:message key="collection.btn_detail" /></a>
                </div>
            </div>
            <%      } 
                } 
            %>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
    <script>
        filterSelection("all", document.querySelector('.filter-btn.active'));
        function filterSelection(c, btnElement) {
            var x, i;
            x = document.getElementsByClassName("gallery-item");
            if (c == "all") c = "";
            for (i = 0; i < x.length; i++) {
                removeClass(x[i], "show");
                if (x[i].getAttribute("data-category").indexOf(c) > -1) addClass(x[i], "show");
            }
            if (btnElement) {
                var btns = document.getElementsByClassName("filter-btn");
                for (var j = 0; j < btns.length; j++) btns[j].classList.remove("active");
                btnElement.classList.add("active");
            }
        }
        function addClass(element, name) {
            var arr1 = element.className.split(" "), arr2 = name.split(" ");
            for (var i = 0; i < arr2.length; i++) if (arr1.indexOf(arr2[i]) == -1) element.className += " " + arr2[i];
        }
        function removeClass(element, name) {
            var arr1 = element.className.split(" "), arr2 = name.split(" ");
            for (var i = 0; i < arr2.length; i++) while (arr1.indexOf(arr2[i]) > -1) arr1.splice(arr1.indexOf(arr2[i]), 1);
            element.className = arr1.join(" ");
        }
    </script>
</body>
</html>