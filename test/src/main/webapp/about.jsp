<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, dao.ProductDAO, model.product, java.text.DecimalFormat"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="shop.page_title" /> | Fashion Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/about.css">
    <link rel="stylesheet" href="CSS/style.css">
    <link rel="stylesheet" href="CSS/index.css">  
</head>
<body>
    <jsp:include page="header.jsp"><jsp:param name="page" value="about" /></jsp:include>

    <div style="background-color: #f5f5f5; padding: 40px 0; text-align: center; margin-bottom: 20px;">
        <h1 style="font-size: 2rem; margin-bottom: 10px; letter-spacing: 2px;"><fmt:message key="shop.title" /></h1>
        <p style="color: #666;"><fmt:message key="shop.breadcrumb" /></p>
    </div>

    <div class="page-container">
        <aside class="sidebar">
            <div class="filter-group">
                <h3 class="filter-title"><fmt:message key="shop.filter_price" /></h3>
                <ul class="filter-list">
                    <li><a href="about.jsp?price=all" class="<%= request.getParameter("price") == null || request.getParameter("price").equals("all") ? "active" : "" %>">
                        <i class="fa-solid fa-circle-check"></i> <fmt:message key="shop.price_all" />
                    </a></li>
                    <li><a href="about.jsp?price=under500" class="<%= "under500".equals(request.getParameter("price")) ? "active" : "" %>">
                        <i class="fa-solid fa-tag"></i> <fmt:message key="shop.price_under500" />
                    </a></li>
                    <li><a href="about.jsp?price=500to1000" class="<%= "500to1000".equals(request.getParameter("price")) ? "active" : "" %>">
                        <i class="fa-solid fa-tag"></i> <fmt:message key="shop.price_500_1000" />
                    </a></li>
                    <li><a href="about.jsp?price=above1000" class="<%= "above1000".equals(request.getParameter("price")) ? "active" : "" %>">
                        <i class="fa-solid fa-tag"></i> <fmt:message key="shop.price_above1000" />
                    </a></li>
                </ul>
            </div>
            
            <div class="filter-group">
                <h3 class="filter-title"><fmt:message key="shop.category" /></h3>
                <ul class="filter-list">
                    <li><a href="#"><fmt:message key="shop.cat_shirt" /></a></li>
                    <li><a href="#"><fmt:message key="shop.cat_pants" /></a></li>
                    <li><a href="#"><fmt:message key="shop.cat_accessories" /></a></li>
                    <li><a href="#"><fmt:message key="shop.cat_collection" /></a></li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <%
                // Logic Java giữ nguyên (Lọc, Sắp xếp, Phân trang)
                ProductDAO pdao = new ProductDAO();
                List<product> allProducts = pdao.getAllProducts();
                List<product> filteredProducts = new ArrayList<>();
                String priceFilter = request.getParameter("price");
                if (allProducts != null) {
                    if (priceFilter == null || priceFilter.equals("all")) { filteredProducts.addAll(allProducts); } 
                    else {
                        for (product p : allProducts) {
                            double price = p.getPrice();
                            if (priceFilter.equals("under500") && price < 500000) filteredProducts.add(p);
                            else if (priceFilter.equals("500to1000") && price >= 500000 && price <= 1000000) filteredProducts.add(p);
                            else if (priceFilter.equals("above1000") && price > 1000000) filteredProducts.add(p);
                        }
                    }
                }
                String sortType = request.getParameter("sort");
                if ("price_asc".equals(sortType)) Collections.sort(filteredProducts, (p1, p2) -> Double.compare(p1.getPrice(), p2.getPrice()));
                else if ("price_desc".equals(sortType)) Collections.sort(filteredProducts, (p1, p2) -> Double.compare(p2.getPrice(), p1.getPrice()));
                else if ("name_asc".equals(sortType)) Collections.sort(filteredProducts, (p1, p2) -> p1.getPdescription().compareTo(p2.getPdescription()));
                
                int pageCurrent = 1;
                int productsPerPage = 9;
                if (request.getParameter("page") != null) { try { pageCurrent = Integer.parseInt(request.getParameter("page")); } catch(Exception e){} }
                int totalProducts = filteredProducts.size();
                int totalPages = (int) Math.ceil((double) totalProducts / productsPerPage);
                int start = (pageCurrent - 1) * productsPerPage;
                int end = Math.min(start + productsPerPage, totalProducts);
                List<product> pageProducts = new ArrayList<>();
                if (start < totalProducts) { pageProducts = filteredProducts.subList(start, end); }
                DecimalFormat df = new DecimalFormat("#,### VNĐ");
            %>

            <div class="shop-toolbar">
                <span class="result-count"><fmt:message key="shop.showing" /> <b><%= start+1 %>-<%= end %></b> <fmt:message key="shop.of" /> <b><%= totalProducts %></b> <fmt:message key="shop.results" /></span>
                <form action="about.jsp" method="get" class="sort-box">
                    <% if(priceFilter != null) { %><input type="hidden" name="price" value="<%= priceFilter %>"><% } %>
                    <select name="sort" onchange="this.form.submit()">
                        <option value="default"><fmt:message key="shop.sort_default" /></option>
                        <option value="price_asc" <%= "price_asc".equals(sortType) ? "selected" : "" %>><fmt:message key="shop.sort_price_asc" /></option>
                        <option value="price_desc" <%= "price_desc".equals(sortType) ? "selected" : "" %>><fmt:message key="shop.sort_price_desc" /></option>
                        <option value="name_asc" <%= "name_asc".equals(sortType) ? "selected" : "" %>><fmt:message key="shop.sort_name" /></option>
                    </select>
                </form>
            </div>

            <div class="product-grid-shop">
                <% if (pageProducts.isEmpty()) { %>
                    <div style="grid-column: 1/-1; text-align: center; padding: 50px;">
                        <p><fmt:message key="shop.no_products" /></p>
                        <a href="about.jsp" style="color: var(--gold); text-decoration: underline;"><fmt:message key="shop.clear_filter" /></a>
                    </div>
                <% } else {
                    for (product p : pageProducts) { %>
                    <div class="product-card">
                        <div class="product-image">
                            <a href="product-detail?pid=<%=p.getPid()%>">
                                <img src="<%= (p.getImage() != null) ? p.getImage() : "img/no-image.png" %>" alt="<%=p.getPdescription()%>">
                            </a>
                            <a href="product-detail?pid=<%=p.getPid()%>" class="overlay-btn"><i class="fa-regular fa-eye"></i></a>
                        </div>
                        <div class="product-details">
                            <h3 class="product-name"><a href="product-detail?pid=<%=p.getPid()%>"><%=p.getPdescription()%></a></h3>
                            <span class="price"><%=df.format(p.getPrice())%></span>
                            <form action="cart" method="post">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="pid" value="<%=p.getPid()%>">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn-add-cart"><fmt:message key="home.product.add_cart" /></button>
                            </form>
                        </div>
                    </div>
                <% } } %>
            </div>

            <% if (totalPages > 1) { %>
            <div class="pagination">
                <% if (pageCurrent > 1) { %>
                    <a href="about.jsp?page=<%= pageCurrent - 1 %>&sort=<%= sortType != null ? sortType : "" %>&price=<%= priceFilter != null ? priceFilter : "" %>" class="page-link"><i class="fa-solid fa-chevron-left"></i></a>
                <% } %>
                <% for (int i = 1; i <= totalPages; i++) { %>
                    <a href="about.jsp?page=<%= i %>&sort=<%= sortType != null ? sortType : "" %>&price=<%= priceFilter != null ? priceFilter : "" %>" class="page-link <%= (i == pageCurrent) ? "active" : "" %>"><%= i %></a>
                <% } %>
                <% if (pageCurrent < totalPages) { %>
                    <a href="about.jsp?page=<%= pageCurrent + 1 %>&sort=<%= sortType != null ? sortType : "" %>&price=<%= priceFilter != null ? priceFilter : "" %>" class="page-link"><i class="fa-solid fa-chevron-right"></i></a>
                <% } %>
            </div>
            <% } %>
        </main>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>