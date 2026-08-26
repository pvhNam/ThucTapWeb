<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.ReportDAO" %>
<%@ page import="model.ReportPeriod" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    ReportPeriod period = (ReportPeriod) request.getAttribute("period");
    ReportDAO.RevenueReportSummary summary = (ReportDAO.RevenueReportSummary) request.getAttribute("summary");
    List<ReportDAO.ProductRevenueItem> items = (List<ReportDAO.ProductRevenueItem>) request.getAttribute("items");
    List<ReportDAO.ProductRevenueItem> topItems = (List<ReportDAO.ProductRevenueItem>) request.getAttribute("topItems");
    double maxRevenue = request.getAttribute("maxRevenue") == null ? 0 : (double) request.getAttribute("maxRevenue");
    String filter = (String) request.getAttribute("filter");
    String keyword = (String) request.getAttribute("keyword");
    String generatedAt = (String) request.getAttribute("generatedAt");
    String errorMessage = (String) request.getAttribute("errorMessage");
    DecimalFormat money = new DecimalFormat("#,##0 đ");
    DecimalFormat number = new DecimalFormat("#,##0");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo doanh thu | Nam Thành Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="CSS/admin/Admin.css">
    <link rel="stylesheet" href="CSS/admin/admin-revenue-report.css">
</head>
<body class="revenue-report-page">
<jsp:include page="sidebarAdmin.jsp">
    <jsp:param name="pageName" value="revenue-report" />
</jsp:include>

<main class="main-content report-main">
    <header class="report-header">
        <div>
            <a class="report-breadcrumb" href="admin"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
            <p class="report-eyebrow">Phân tích kinh doanh</p>
            <h1>Báo cáo doanh thu &amp; tồn kho</h1>
        </div>
        <div class="report-generated">
            <i class="fa-regular fa-clock"></i>
            <span>Cập nhật<br><strong><%= generatedAt %></strong></span>
        </div>
    </header>

    <% if (errorMessage != null) { %>
    <div class="report-alert" role="alert">
        <i class="fa-solid fa-triangle-exclamation"></i>
        <span><c:out value="${errorMessage}" /></span>
    </div>
    <% } %>

    <section class="report-control-panel" aria-labelledby="period-filter-title">
        <div class="control-heading">
            <div>
                <span class="control-icon"><i class="fa-regular fa-calendar"></i></span>
                <div>
                    <h2 id="period-filter-title">Chọn kỳ báo cáo</h2>
                </div>
            </div>
            <span class="period-result"><%= period.getDisplayLabel() %></span>
        </div>

        <form action="admin-revenue-report" method="get" class="period-form" data-admin-ajax>
            <div class="period-segments" role="radiogroup" aria-label="Loại kỳ báo cáo">
                <label>
                    <input type="radio" name="period" value="month" <%= ReportPeriod.MONTH.equals(period.getType()) ? "checked" : "" %> data-admin-auto-submit>
                    <span><i class="fa-regular fa-calendar-days"></i> Theo tháng</span>
                </label>
                <label>
                    <input type="radio" name="period" value="six_months" <%= ReportPeriod.SIX_MONTHS.equals(period.getType()) ? "checked" : "" %> data-admin-auto-submit>
                    <span><i class="fa-solid fa-chart-line"></i> 6 tháng</span>
                </label>
                <label>
                    <input type="radio" name="period" value="year" <%= ReportPeriod.YEAR.equals(period.getType()) ? "checked" : "" %> data-admin-auto-submit>
                    <span><i class="fa-regular fa-calendar-check"></i> Theo năm</span>
                </label>
            </div>
            <label class="report-field">
                <span>Tháng kết thúc</span>
                <select name="month" data-admin-auto-submit>
                    <% for (int monthIndex = 1; monthIndex <= 12; monthIndex++) { %>
                    <option value="<%= monthIndex %>" <%= monthIndex == period.getMonth() ? "selected" : "" %>>Tháng <%= monthIndex %></option>
                    <% } %>
                </select>
            </label>
            <label class="report-field report-year-field">
                <span>Năm</span>
                <input type="number" name="year" min="2000" max="<%= java.time.LocalDate.now().getYear() + 1 %>" value="<%= period.getYear() %>" required data-admin-auto-submit>
            </label>
            <button type="submit" class="report-primary-button">
                <i class="fa-solid fa-filter"></i> Xem báo cáo
            </button>
        </form>
    </section>

    <section class="report-stats" aria-label="Tổng quan báo cáo">
        <article class="report-stat report-stat--revenue">
            <span class="report-stat-icon"><i class="fa-solid fa-coins"></i></span>
            <div><p>Doanh thu sản phẩm</p><strong><%= money.format(summary.getTotalRevenue()) %></strong><small><%= summary.getCompletedOrders() %> đơn hoàn tất</small></div>
        </article>
        <article class="report-stat report-stat--profit">
            <span class="report-stat-icon"><i class="fa-solid fa-arrow-trend-up"></i></span>
            <div><p>Lợi nhuận ước tính</p><strong><%= money.format(summary.getTotalProfit()) %></strong><small>Giá vốn ghi nhận: <%= money.format(summary.getTotalCost()) %></small></div>
        </article>
        <article class="report-stat report-stat--sold">
            <span class="report-stat-icon"><i class="fa-solid fa-bag-shopping"></i></span>
            <div><p>Số lượng đã bán</p><strong><%= number.format(summary.getUnitsSold()) %></strong><small><%= summary.getSoldProducts() %> mặt hàng có phát sinh bán</small></div>
        </article>
        <article class="report-stat report-stat--stock">
            <span class="report-stat-icon"><i class="fa-solid fa-boxes-stacked"></i></span>
            <div><p>Số lượng còn kho</p><strong><%= number.format(summary.getUnitsInStock()) %></strong><small><%= summary.getUnsoldProducts() %> mặt hàng chưa bán trong kỳ</small></div>
        </article>
    </section>

    <section class="report-insights-grid">
        <article class="report-card top-products-card">
            <div class="report-card-heading">
                <div><span class="card-kicker">Hiệu suất</span><h2>Mặt hàng tạo doanh thu cao</h2></div>
                <span class="soft-badge"><%= period.getDisplayLabel() %></span>
            </div>
            <div class="revenue-bars">
                <% if (topItems != null && !topItems.isEmpty()) {
                    for (ReportDAO.ProductRevenueItem topItem : topItems) {
                        double width = maxRevenue > 0 ? (topItem.getRevenue() / maxRevenue * 100) : 0;
                %>
                <div class="revenue-bar-item">
                    <div class="bar-label">
                        <span><%= topItem.getProductName() %></span>
                        <strong><%= money.format(topItem.getRevenue()) %></strong>
                    </div>
                    <div class="bar-track"><span style="width:<%= Math.max(3, width) %>%"></span></div>
                    <small><%= topItem.getQuantitySold() %> sản phẩm đã bán</small>
                </div>
                <% }} else { %>
                <div class="report-empty-small"><i class="fa-regular fa-chart-bar"></i> Chưa có sản phẩm bán thành công trong kỳ này.</div>
                <% } %>
            </div>
        </article>

        <article class="report-card export-report-card">
            <div class="report-card-heading">
                <div><span class="card-kicker">Excel</span><h2>Xuất dữ liệu đã chọn</h2></div>
                <span class="excel-icon"><i class="fa-solid fa-file-excel"></i></span>
            </div>
            <p>File gồm trang tổng quan và bảng chi tiết, có sẵn bộ lọc cột để tiếp tục xử lý trong Excel.</p>
            <form action="admin-export-revenue" method="get" class="export-report-form" data-download data-no-transition>
                <input type="hidden" name="period" value="<%= period.getType() %>">
                <input type="hidden" name="month" value="<%= period.getMonth() %>">
                <input type="hidden" name="year" value="<%= period.getYear() %>">
                <label class="report-field">
                    <span>Nội dung cần xuất</span>
                    <select name="scope">
                        <option value="all">Toàn bộ mặt hàng</option>
                        <option value="sold">Chỉ mặt hàng đã bán</option>
                        <option value="inventory">Chỉ mặt hàng còn tồn kho</option>
                        <option value="unsold">Chỉ mặt hàng chưa bán trong kỳ</option>
                    </select>
                </label>
                <button type="submit" class="excel-download-button">
                    <i class="fa-solid fa-download"></i>
                    <span>Xuất file Excel<small>.xlsx • có tổng quan và chi tiết</small></span>
                </button>
            </form>
        </article>
    </section>

    <section class="report-card product-report-card">
        <div class="report-card-heading table-card-heading">
            <div>
                <span class="card-kicker">Chi tiết mặt hàng</span>
                <h2>Đã bán, chưa bán và tồn kho</h2>
            </div>
            <span class="result-count"><%= items == null ? 0 : items.size() %> kết quả</span>
        </div>

        <form action="admin-revenue-report" method="get" class="report-search-form" data-admin-ajax>
            <input type="hidden" name="period" value="<%= period.getType() %>">
            <input type="hidden" name="month" value="<%= period.getMonth() %>">
            <input type="hidden" name="year" value="<%= period.getYear() %>">
            <label class="report-search-field">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="search" name="q" value="<c:out value='${keyword}' />" placeholder="Tìm mã, tên hoặc danh mục..." data-admin-live-search>
            </label>
            <label class="report-field compact-field">
                <span class="sr-only">Trạng thái</span>
                <select name="filter" data-admin-auto-submit>
                    <option value="all" <%= "all".equals(filter) ? "selected" : "" %>>Tất cả mặt hàng</option>
                    <option value="sold" <%= "sold".equals(filter) ? "selected" : "" %>>Đã bán trong kỳ</option>
                    <option value="unsold" <%= "unsold".equals(filter) ? "selected" : "" %>>Chưa bán trong kỳ</option>
                    <option value="inventory" <%= "inventory".equals(filter) ? "selected" : "" %>>Còn tồn kho</option>
                    <option value="low_stock" <%= "low_stock".equals(filter) ? "selected" : "" %>>Sắp hết hàng</option>
                </select>
            </label>
            <button type="submit" class="report-secondary-button">Lọc dữ liệu</button>
            <% if ((keyword != null && !keyword.isEmpty()) || !"all".equals(filter)) { %>
            <a class="clear-filter-button" data-admin-ajax-link href="admin-revenue-report?period=<%= period.getType() %>&month=<%= period.getMonth() %>&year=<%= period.getYear() %>">Xóa lọc</a>
            <% } %>
        </form>

        <div class="report-table-wrap">
            <table class="revenue-table">
                <thead>
                <tr>
                    <th>Mặt hàng</th>
                    <th>Trạng thái kỳ</th>
                    <th class="numeric">Đã bán</th>
                    <th class="numeric">Còn kho</th>
                    <th class="numeric">Giá bán</th>
                    <th class="numeric">Doanh thu</th>
                    <th class="numeric">Lợi nhuận ước tính</th>
                </tr>
                </thead>
                <tbody>
                <% if (items != null && !items.isEmpty()) {
                    for (ReportDAO.ProductRevenueItem item : items) {
                        pageContext.setAttribute("reportItem", item);
                        int availableTotal = item.getQuantitySold() + item.getStockRemaining();
                        double sellThrough = availableTotal > 0 ? item.getQuantitySold() * 100.0 / availableTotal : 0;
                %>
                <tr>
                    <td>
                        <div class="report-product-cell">
                            <div class="report-product-image">
                                <c:choose>
                                    <c:when test="${not empty reportItem.image}"><img src="<c:out value='${reportItem.image}' />" alt=""></c:when>
                                    <c:otherwise><i class="fa-solid fa-shirt"></i></c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <strong><c:out value="${reportItem.productName}" /></strong>
                                <span>#<%= item.getProductId() %> • <c:out value="${reportItem.categoryName}" /></span>
                            </div>
                        </div>
                    </td>
                    <td>
                        <span class="sale-status <%= item.isSold() ? "is-sold" : "is-unsold" %>">
                            <i class="fa-solid <%= item.isSold() ? "fa-circle-check" : "fa-minus" %>"></i>
                            <%= item.isSold() ? "Đã bán" : "Chưa bán" %>
                        </span>
                        <div class="sell-through" title="Tỷ lệ đã bán trên tổng đã bán và tồn hiện tại">
                            <span style="width:<%= Math.min(100, sellThrough) %>%"></span>
                        </div>
                    </td>
                    <td class="numeric quantity-sold"><%= number.format(item.getQuantitySold()) %></td>
                    <td class="numeric">
                        <span class="stock-number <%= item.getStockRemaining() == 0 ? "stock-empty" : (item.getStockRemaining() <= 5 ? "stock-low" : "stock-good") %>">
                            <%= number.format(item.getStockRemaining()) %>
                        </span>
                    </td>
                    <td class="numeric muted-money"><%= money.format(item.getSellingPrice()) %></td>
                    <td class="numeric revenue-money"><%= money.format(item.getRevenue()) %></td>
                    <td class="numeric <%= item.getProfit() >= 0 ? "profit-money" : "loss-money" %>"><%= money.format(item.getProfit()) %></td>
                </tr>
                <% }} else { %>
                <tr><td colspan="7">
                    <div class="report-empty-state">
                        <i class="fa-solid fa-box-open"></i>
                        <strong>Không có mặt hàng phù hợp</strong>
                        <span>Hãy đổi kỳ báo cáo hoặc xóa điều kiện lọc.</span>
                    </div>
                </td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <footer class="report-table-note">
            <span><i class="fa-solid fa-circle-info"></i> Doanh thu chỉ tính các đơn có trạng thái giao thành công.</span>
            <span><i class="fa-solid fa-triangle-exclamation"></i> <%= summary.getLowStockProducts() %> mặt hàng chỉ còn từ 1–5 sản phẩm.</span>
        </footer>
    </section>
</main>
</body>
</html>
