<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.time.LocalDate"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard Admin | Fashion Store</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/admin/Admin.css">
<link rel="stylesheet" href="CSS/admin/admin-dashboard.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>

    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="dashboard" />
    </jsp:include>

    <main class="main-content">

        <div class="content-header">
            <h1 class="page-title">Tổng quan Dashboard</h1>
            <div class="user-info">
                <i class="fa-solid fa-user-shield"></i>
                <span>Administrator</span>
            </div>
        </div>

        <%
            // Lấy dữ liệu thống kê từ Servlet
            int totalOrders = request.getAttribute("totalOrders") != null ? (int) request.getAttribute("totalOrders") : 0;
            double totalRevenue = request.getAttribute("totalRevenue") != null ? (double) request.getAttribute("totalRevenue") : 0.0;
            int countProcessing = request.getAttribute("countProcessing") != null ? (int) request.getAttribute("countProcessing") : 0;
            int countCancel    = request.getAttribute("countCancel")    != null ? (int) request.getAttribute("countCancel")    : 0;
            int countSuccess   = request.getAttribute("countSuccess")   != null ? (int) request.getAttribute("countSuccess")   : 0;
            int countShipping  = request.getAttribute("countShipping")  != null ? (int) request.getAttribute("countShipping")  : 0;

            // Format tiền tệ & Thời gian
            DecimalFormat df = new DecimalFormat("#,### VNĐ");
            int currentYear = LocalDate.now().getYear();
            int currentMonth = LocalDate.now().getMonthValue();
        %>

        <div class="stats-cards">
            <a href="admin-orders" class="stat-link">
                <div class="card-stat blue">
                    <div class="stat-info">
                        <h3><%= totalOrders %></h3>
                        <p>Tổng đơn hàng</p>
                    </div>
                    <div class="stat-icon"><i class="fa-solid fa-cart-shopping"></i></div>
                </div>
            </a>

            <a href="admin-orders?filter=success" class="stat-link">
                <div class="card-stat green">
                    <div class="stat-info">
                        <h3 style="color: var(--success);"><%= df.format(totalRevenue) %></h3>
                        <p>Doanh thu thực</p>
                    </div>
                    <div class="stat-icon"><i class="fa-solid fa-sack-dollar"></i></div>
                </div>
            </a>

            <a href="admin-orders?filter=processing" class="stat-link">
                <div class="card-stat orange">
                    <div class="stat-info">
                        <h3><%= countProcessing %></h3>
                        <p>Đang chờ xử lý</p>
                    </div>
                    <div class="stat-icon"><i class="fa-solid fa-clock"></i></div>
                </div>
            </a>

            <a href="admin-orders?filter=cancel" class="stat-link">
                <div class="card-stat red">
                    <div class="stat-info">
                        <h3><%= countCancel %></h3>
                        <p>Đơn bị hủy</p>
                    </div>
                    <div class="stat-icon"><i class="fa-solid fa-ban"></i></div>
                </div>
            </a>

            <a href="admin-orders?filter=shipping" class="stat-link">
                <div class="card-stat teal">
                    <div class="stat-info">
                        <h3><%= countShipping %></h3>
                        <p>Đang giao hàng</p>
                    </div>
                    <div class="stat-icon"><i class="fa-solid fa-truck-fast"></i></div>
                </div>
            </a>

            <a href="admin-orders?filter=success" class="stat-link">
                <div class="card-stat purple">
                    <div class="stat-info">
                        <h3><%= countSuccess %></h3>
                        <p>Giao thành công</p>
                    </div>
                    <div class="stat-icon"><i class="fa-solid fa-circle-check"></i></div>
                </div>
            </a>
        </div>

        <%-- ===== BIỂU ĐỒ TRÒN TRẠNG THÁI ĐƠN HÀNG ===== --%>
        <div class="charts-section">
            <div class="chart-container donut-card">
                <h4 class="chart-title">
                    <i class="fa-solid fa-chart-pie"></i>
                    Phân tích trạng thái đơn hàng
                </h4>
                <div class="donut-wrapper">
                    <div class="donut-canvas-wrap">
                        <canvas id="orderStatusChart"></canvas>
                    </div>
                    <div class="donut-legend">
                        <div class="legend-item">
                            <span class="legend-dot" style="background: linear-gradient(135deg,#1cc88a,#13855c);"></span>
                            <div>
                                <div class="legend-label">Giao thành công</div>
                                <div class="legend-count" style="color:#1cc88a;"><%= countSuccess %> đơn</div>
                            </div>
                        </div>
                        <div class="legend-item">
                            <span class="legend-dot" style="background: linear-gradient(135deg,#36b9cc,#1a9eac);"></span>
                            <div>
                                <div class="legend-label">Đang giao hàng</div>
                                <div class="legend-count" style="color:#36b9cc;"><%= countShipping %> đơn</div>
                            </div>
                        </div>
                        <div class="legend-item">
                            <span class="legend-dot" style="background: linear-gradient(135deg,#e74a3b,#c0392b);"></span>
                            <div>
                                <div class="legend-label">Đơn đã hủy</div>
                                <div class="legend-count" style="color:#e74a3b;"><%= countCancel %> đơn</div>
                            </div>
                        </div>
                        <div class="legend-item">
                            <span class="legend-dot" style="background: linear-gradient(135deg,#f6c23e,#d4a017);"></span>
                            <div>
                                <div class="legend-label">Đang xử lý</div>
                                <div class="legend-count" style="color:#d4a017;"><%= countProcessing %> đơn</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <% if (request.getParameter("msg") != null) { %>
        <div class="alert-modern">
            <i class="fa-solid fa-circle-check"></i>
            <span>Thao tác thành công! Dữ liệu đã được cập nhật.</span>
        </div>
        <% } %>

        <div class="export-container">
            <h3 class="section-title">
                <i class="fa-solid fa-file-export" style="color: var(--primary);"></i>
                Xuất Báo Cáo Doanh Thu
            </h3>

            <div class="export-tools">
                <form action="admin-export-report" method="get" class="export-form">
                    <input type="hidden" name="type" value="daily">
                    <span class="export-label">📅 Theo ngày:</span>
                    <input type="date" name="date" required class="custom-input">
                    <button type="submit" class="btn-export btn-green">
                        <i class="fa-solid fa-download"></i> Tải về
                    </button>
                </form>

                <form action="admin-export-report" method="get" class="export-form">
                    <input type="hidden" name="type" value="monthly">
                    <span class="export-label">📊 Theo tháng:</span>

                    <select name="month" class="custom-input">
                        <% for(int i=1; i<=12; i++) { %>
                            <option value="<%=i%>" <%= i == currentMonth ? "selected" : "" %>>Tháng <%=i%></option>
                        <% } %>
                    </select>

                    <input type="number" name="year" value="<%= currentYear %>" class="custom-input" style="width: 80px;">

                    <button type="submit" class="btn-export btn-blue">
                        <i class="fa-solid fa-download"></i> Tải về
                    </button>
                </form>
            </div>
        </div>

        <div class="table-container">
            <div class="table-header-box">
                <h3 style="margin: 0; font-size: 18px; color: var(--dark);">
                    <i class="fa-solid fa-list-ul" style="margin-right: 10px;"></i> Đơn hàng gần đây
                </h3>
            </div>

            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Mã Đơn</th>
                        <th>Khách Hàng</th>
                        <th>Ngày Đặt</th>
                        <th>Địa Chỉ</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th>Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    List<Order> list = (List<Order>) request.getAttribute("listOrders");
                    if (list != null && !list.isEmpty()) {
                        for (Order o : list) {
                            String st = o.getStatus();
                            String badgeClass = "bg-process";
                            if (st != null) {
                                if (st.contains("giao") || st.contains("ship")) badgeClass = "bg-shipping";
                                if (st.contains("thành công") || st.contains("HT")) badgeClass = "bg-success";
                                if (st.contains("hủy")) badgeClass = "bg-cancel";
                            } else { st = "Không xác định"; }
                    %>
                    <tr>
                        <td><strong>#<%=o.getId()%></strong></td>
                        <td>
                            <div style="font-weight: 500;"><%=o.getUserName()%></div>
                            <small style="color: #888;"><%=o.getPhoneNumber()%></small>
                        </td>
                        <td><%=o.getCreatedAt()%></td>
                        <td style="max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                            <%=o.getAddress()%>
                        </td>
                        <td class="money"><%=df.format(o.getTotalMoney())%></td>
                        <td><span class="badge <%=badgeClass%>"><%=st%></span></td>
                        <td>
                            <div class="action-group">
                                <a href="order-detail?id=<%=o.getId()%>" class="btn-icon btn-view" title="Xem chi tiết">
                                    <i class="fa-solid fa-eye"></i>
                                </a>
                                <% if ("Đang xử lý".equals(st)) { %>
                                    <form action="update-order" method="post" style="margin: 0;">
                                        <input type="hidden" name="id" value="<%=o.getId()%>">
                                        <input type="hidden" name="action" value="ship">
                                        <button class="btn-icon btn-ship" title="Giao hàng">
                                            <i class="fa-solid fa-truck"></i>
                                        </button>
                                    </form>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="7" style="text-align: center; padding: 40px; color: #999;">
                        <i class="fa-regular fa-folder-open" style="font-size: 40px; margin-bottom: 10px; display: block;"></i>
                        Chưa có đơn hàng nào phát sinh.
                    </td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

<script>
(function() {
    var success  = <%= countSuccess %>;
    var shipping = <%= countShipping %>;
    var cancel   = <%= countCancel %>;
    var process  = <%= countProcessing %>;

    if (success + shipping + cancel + process === 0) return;

    var ctx = document.getElementById('orderStatusChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Giao thành công', 'Đang giao', 'Đã hủy', 'Đang xử lý'],
            datasets: [{
                data: [success, shipping, cancel, process],
                backgroundColor: ['#1cc88a', '#36b9cc', '#e74a3b', '#f6c23e'],
                borderColor: '#ffffff',
                borderWidth: 4,
                hoverOffset: 10
            }]
        },
        options: {
            cutout: '68%',
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: 'rgba(30,30,40,0.85)',
                    padding: 12,
                    cornerRadius: 8,
                    callbacks: {
                        label: function(c) {
                            var total = c.dataset.data.reduce(function(a,b){return a+b;},0);
                            var pct = total ? Math.round(c.raw/total*100) : 0;
                            return '  ' + c.label + ': ' + c.raw + ' đơn (' + pct + '%)';
                        }
                    }
                }
            }
        }
    });
})();
</script>
</body>
</html>
