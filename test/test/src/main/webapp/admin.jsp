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

<link rel="stylesheet" href="CSS/Admin.css">

<style>
    :root {
        --primary: #4e73df;
        --success: #1cc88a;
        --warning: #f6c23e;
        --danger: #e74a3b;
        --dark: #5a5c69;
        --light: #f8f9fc;
        --text: #444;
        --shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        --shadow-hover: 0 8px 15px rgba(0, 0, 0, 0.1);
    }

    body {
        font-family: 'Inter', sans-serif;
        background-color: #f3f4f6;
        color: var(--text);
    }

    /* --- 1. HEADER AREA --- */
    .content-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #e3e6f0;
    }

    .page-title {
        font-size: 24px;
        font-weight: 700;
        color: var(--dark);
        margin: 0;
    }

    .user-info {
        background: white;
        padding: 8px 20px;
        border-radius: 50px;
        box-shadow: var(--shadow);
        font-weight: 600;
        color: var(--primary);
        display: flex;
        align-items: center;
        gap: 10px;
    }

    /* --- 2. STATS CARDS (THẺ THỐNG KÊ) --- */
    .stats-cards {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        gap: 24px;
        margin-bottom: 30px;
    }

    .card-stat {
        background: white;
        padding: 25px;
        border-radius: 12px;
        box-shadow: var(--shadow);
        display: flex;
        justify-content: space-between;
        align-items: center;
        transition: all 0.3s ease;
        border-left: 5px solid transparent;
        position: relative;
        overflow: hidden;
    }

    .card-stat:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-hover);
    }

    /* Màu sắc riêng cho từng thẻ */
    .card-stat.blue { border-left-color: var(--primary); }
    .card-stat.blue .stat-icon { color: var(--primary); background: #e8f0fe; }
    
    .card-stat.green { border-left-color: var(--success); }
    .card-stat.green .stat-icon { color: var(--success); background: #e0fdf4; }
    
    .card-stat.orange { border-left-color: var(--warning); }
    .card-stat.orange .stat-icon { color: var(--warning); background: #fff8e1; }
    
    .card-stat.red { border-left-color: var(--danger); }
    .card-stat.red .stat-icon { color: var(--danger); background: #fce8e6; }

    .stat-info h3 {
        font-size: 28px;
        font-weight: 800;
        margin: 0;
        color: #333;
    }

    .stat-info p {
        margin: 5px 0 0;
        color: #888;
        font-size: 13px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        font-weight: 600;
    }

    .stat-icon {
        width: 55px;
        height: 55px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
    }

    /* --- 3. EXPORT SECTION (KHU VỰC BÁO CÁO) --- */
    .export-container {
        background: white;
        border-radius: 12px;
        padding: 25px;
        box-shadow: var(--shadow);
        margin-bottom: 30px;
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .section-title {
        font-size: 18px;
        font-weight: 700;
        color: var(--dark);
        display: flex;
        align-items: center;
        gap: 10px;
        padding-bottom: 15px;
        border-bottom: 1px solid #eee;
        margin: 0;
    }

    .export-tools {
        display: flex;
        flex-wrap: wrap;
        gap: 30px;
    }

    .export-form {
        display: flex;
        align-items: center;
        gap: 15px;
        background: #f8f9fc;
        padding: 10px 20px;
        border-radius: 8px;
        border: 1px dashed #d1d3e2;
    }

    .export-label {
        font-weight: 600;
        font-size: 14px;
        color: var(--dark);
        white-space: nowrap;
    }

    .custom-input {
        padding: 8px 12px;
        border: 1px solid #d1d3e2;
        border-radius: 6px;
        outline: none;
        color: #555;
        font-family: 'Inter', sans-serif;
    }

    .custom-input:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(78, 115, 223, 0.1);
    }

    .btn-export {
        padding: 8px 16px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-weight: 600;
        color: white;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: all 0.2s;
    }

    .btn-green { background-color: var(--success); }
    .btn-green:hover { background-color: #169b6b; box-shadow: 0 4px 10px rgba(28, 200, 138, 0.3); }

    .btn-blue { background-color: #36b9cc; }
    .btn-blue:hover { background-color: #2c9faf; box-shadow: 0 4px 10px rgba(54, 185, 204, 0.3); }

    /* --- 4. DATA TABLE (BẢNG DỮ LIỆU) --- */
    .table-container {
        background: white;
        border-radius: 12px;
        box-shadow: var(--shadow);
        overflow: hidden; /* Để bo tròn góc bảng */
    }

    .table-header-box {
        padding: 20px 25px;
        background: white;
        border-bottom: 1px solid #e3e6f0;
    }

    .admin-table {
        width: 100%;
        border-collapse: collapse;
    }

    .admin-table thead th {
        background-color: #f8f9fc;
        color: var(--primary);
        font-weight: 700;
        text-transform: uppercase;
        font-size: 12px;
        letter-spacing: 0.5px;
        padding: 15px 25px;
        text-align: left;
        border-bottom: 2px solid #e3e6f0;
    }

    .admin-table tbody td {
        padding: 15px 25px;
        border-bottom: 1px solid #e3e6f0;
        color: #555;
        font-size: 14px;
        vertical-align: middle;
    }

    .admin-table tbody tr:hover {
        background-color: #fafbfc;
    }

    .money {
        font-family: 'Consolas', monospace;
        font-weight: 700;
        color: var(--dark);
    }

    /* Badges */
    .badge {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        display: inline-block;
    }

    .bg-process { background-color: #fff3cd; color: #856404; }
    .bg-shipping { background-color: #cce5ff; color: #004085; }
    .bg-success { background-color: #d4edda; color: #155724; }
    .bg-cancel { background-color: #f8d7da; color: #721c24; }

    /* Action Buttons in Table */
    .action-group { display: flex; gap: 8px; }
    .btn-icon {
        width: 32px;
        height: 32px;
        border-radius: 6px;
        display: flex;
        align-items: center;
        justify-content: center;
        border: none;
        cursor: pointer;
        color: white;
        transition: transform 0.2s;
        text-decoration: none;
    }
    .btn-icon:hover { transform: scale(1.1); }
    .btn-view { background: var(--dark); }
    .btn-ship { background: var(--warning); color: #333; }

    /* Alert */
    .alert-modern {
        padding: 15px 20px;
        background: #d1fae5;
        color: #065f46;
        border-left: 5px solid #10b981;
        border-radius: 8px;
        margin-bottom: 25px;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 10px;
        box-shadow: var(--shadow);
    }
</style>
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
            int countCancel = request.getAttribute("countCancel") != null ? (int) request.getAttribute("countCancel") : 0;
            
            // Format tiền tệ & Thời gian
            DecimalFormat df = new DecimalFormat("#,### VNĐ");
            int currentYear = LocalDate.now().getYear();
            int currentMonth = LocalDate.now().getMonthValue();
        %>

        <div class="stats-cards">
            <div class="card-stat blue">
                <div class="stat-info">
                    <h3><%= totalOrders %></h3>
                    <p>Tổng đơn hàng</p>
                </div>
                <div class="stat-icon"><i class="fa-solid fa-cart-shopping"></i></div>
            </div>
            
            <div class="card-stat green">
                <div class="stat-info">
                    <h3 style="color: var(--success);"><%= df.format(totalRevenue) %></h3>
                    <p>Doanh thu thực</p>
                </div>
                <div class="stat-icon"><i class="fa-solid fa-sack-dollar"></i></div>
            </div>
            
            <div class="card-stat orange">
                <div class="stat-info">
                    <h3><%= countProcessing %></h3>
                    <p>Đang chờ xử lý</p>
                </div>
                <div class="stat-icon"><i class="fa-solid fa-clock"></i></div>
            </div>
            
            <div class="card-stat red">
                <div class="stat-info">
                    <h3><%= countCancel %></h3>
                    <p>Đơn bị hủy</p>
                </div>
                <div class="stat-icon"><i class="fa-solid fa-ban"></i></div>
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
</body>
</html>