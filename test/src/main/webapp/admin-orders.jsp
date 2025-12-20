<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order"%>
<%@ page import="java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Đơn Hàng | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f6f9; margin: 0; }
        
        /* Header Admin */
        .admin-header { background: #343a40; color: white; padding: 0 30px; height: 60px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .brand { font-size: 20px; font-weight: bold; letter-spacing: 1px; }
        .logout-link { color: #ff6b6b; text-decoration: none; font-weight: 600; font-size: 14px; }
        .logout-link:hover { color: #ff4c4c; }

        /* Container */
        .admin-container { max-width: 1200px; margin: 40px auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        
        .page-title { font-size: 24px; color: #333; font-weight: 700; margin-bottom: 25px; border-bottom: 2px solid #eee; padding-bottom: 15px; display: flex; align-items: center; gap: 10px; }
        
        /* Table */
        .admin-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .admin-table th { background: #f8f9fa; color: #495057; padding: 15px; text-align: left; font-weight: 600; border-bottom: 2px solid #dee2e6; }
        .admin-table td { padding: 15px; border-bottom: 1px solid #eee; color: #333; font-size: 14px; vertical-align: middle; }
        .admin-table tr:hover { background-color: #f1f1f1; }
        
        /* Badges & Buttons */
        .badge { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; display: inline-block; }
        .bg-process { background-color: #fff3cd; color: #856404; }
        .bg-success { background-color: #d4edda; color: #155724; }
        .bg-cancel { background-color: #f8d7da; color: #721c24; }
        
        .btn-view { background: #333; color: white; padding: 6px 12px; text-decoration: none; border-radius: 4px; font-size: 12px; font-weight: 600; transition: 0.2s; }
        .btn-view:hover { background: #000; }
        .money { color: #d00000; font-weight: 700; }
    </style>
</head>
<body>
    
    <header class="admin-header">
        <div class="brand"><i class="fa-solid fa-shield-halved"></i> ADMIN PANEL</div>
        <div class="user-menu">
            <span style="margin-right: 15px;">Xin chào, Administrator</span>
            <a href="logout" class="logout-link"><i class="fa-solid fa-power-off"></i> Đăng xuất</a>
        </div>
    </header>

    <div class="admin-container">
        <div class="page-title"><i class="fa-solid fa-list-ul"></i> Danh Sách Tất Cả Đơn Hàng</div>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Khách Hàng</th>
                    <th>Ngày Đặt</th>
                    <th>Địa Chỉ Nhận</th>
                    <th>Tổng Tiền</th>
                    <th>Trạng Thái</th>
                    <th>Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Order> list = (List<Order>) request.getAttribute("listOrders");
                    DecimalFormat df = new DecimalFormat("#,### VNĐ");
                    
                    if (list != null && !list.isEmpty()) {
                        for (Order o : list) {
                            // Xử lý màu trạng thái
                            String statusClass = "bg-process";
                            String st = o.getStatus().toLowerCase();
                            if(st.contains("giao") || st.contains("thành công")) statusClass = "bg-success";
                            if(st.contains("hủy")) statusClass = "bg-cancel";
                %>
                <tr>
                    <td><strong>#<%= o.getId() %></strong></td>
                    <td>
                        <i class="fa-regular fa-user" style="color:#888; margin-right:5px;"></i>
                        <%= o.getUserName() != null ? o.getUserName() : "Unknown" %>
                    </td>
                    <td><%= o.getCreatedAt() %></td>
                    <td><%= o.getAddress() %></td>
                    <td class="money"><%= df.format(o.getTotalMoney()) %></td>
                    <td><span class="badge <%= statusClass %>"><%= o.getStatus() %></span></td>
                    <td>
                        <a href="order-detail.jsp?id=<%= o.getId() %>" class="btn-view" target="_blank">
                            <i class="fa-solid fa-eye"></i> Xem
                        </a>
                    </td>
                </tr>
                <% 
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" style="text-align: center; padding: 40px; color: #777;">
                        <i class="fa-solid fa-inbox" style="font-size: 40px; margin-bottom: 10px; display:block;"></i>
                        Chưa có đơn hàng nào trong hệ thống.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

</body>
</html>