<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Lấy tham số "pageName" được truyền từ file cha vào để set class active
    String activePage = request.getParameter("pageName");
    if (activePage == null) activePage = "";
%>

<style>
    /* --- CSS RIÊNG CHO SIDEBAR --- */
    :root {
        --sidebar-width: 250px;
        --sidebar-bg: #343a40;
        --sidebar-color: white;
        --active-color: #3498db; /* Màu xanh dương cho item đang chọn */
        --hover-bg: rgba(255, 255, 255, 0.1);
    }

    /* Khung sidebar cố định bên trái */
    .sidebar {
        width: var(--sidebar-width);
        background-color: var(--sidebar-bg);
        color: var(--sidebar-color);
        display: flex;
        flex-direction: column;
        position: fixed; /* Cố định vị trí */
        height: 100vh;   /* Full chiều cao màn hình */
        left: 0;
        top: 0;
        z-index: 1000;   /* Luôn nổi lên trên */
        box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        font-family: 'Inter', sans-serif; /* Đảm bảo font chữ đẹp */
    }

    /* Logo / Brand */
    .sidebar-brand {
        height: 60px; /* Chiều cao bằng header */
        display: flex;
        align-items: center;
        padding: 0 20px;
        font-size: 18px;
        font-weight: bold;
        border-bottom: 1px solid rgba(255,255,255,0.1);
        letter-spacing: 1px;
        text-transform: uppercase;
    }

    /* Menu container */
    .sidebar-menu {
        padding: 20px 0;
        flex-grow: 1; /* Đẩy footer xuống dưới cùng */
        overflow-y: auto; /* Cuộn nếu menu quá dài */
    }

    /* Từng mục menu */
    .menu-item {
        display: flex;
        align-items: center;
        padding: 12px 20px;
        color: #c2c7d0; /* Màu xám nhạt */
        text-decoration: none;
        transition: all 0.3s ease;
        font-size: 15px;
        border-left: 3px solid transparent; /* Viền trái ẩn */
    }

    .menu-item i {
        width: 25px;
        text-align: center;
        margin-right: 10px;
    }

    /* Hiệu ứng Hover và Active */
    .menu-item:hover, .menu-item.active {
        background-color: var(--hover-bg);
        color: white;
        border-left-color: var(--active-color); /* Hiện viền trái màu xanh */
    }

    /* Footer chứa nút đăng xuất */
    .sidebar-footer {
        padding: 20px;
        border-top: 1px solid rgba(255,255,255,0.1);
        background-color: var(--sidebar-bg);
    }

    /* Nút đăng xuất */
    .btn-logout {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 100%;
        padding: 10px;
        background-color: #ff6b6b; /* Màu đỏ nhẹ */
        color: white;
        text-decoration: none;
        border-radius: 5px;
        font-weight: 600;
        transition: background 0.2s;
        box-sizing: border-box; /* Đảm bảo padding không làm vỡ khung */
    }

    .btn-logout:hover {
        background-color: #ff4c4c; /* Đỏ đậm hơn khi hover */
    }
</style>

<nav class="sidebar">
    <div class="sidebar-brand">
        <i class="fa-solid fa-shield-halved" style="margin-right: 10px;"></i> ADMIN PANEL
    </div>
    
    <div class="sidebar-menu">
        <a href="admin" class="menu-item <%= activePage.equals("dashboard") ? "active" : "" %>">
            <i class="fa-solid fa-chart-pie"></i> Tổng quan
        </a>
        
        <a href="admin-orders" class="menu-item <%= activePage.equals("orders") ? "active" : "" %>">
            <i class="fa-solid fa-box"></i> Quản lý Đơn hàng
        </a>
        
        <a href="admin-products" class="menu-item <%= activePage.equals("products") ? "active" : "" %>">
            <i class="fa-solid fa-shirt"></i> Quản lý Sản phẩm
        </a>
        
        <a href="admin-news" class="menu-item <%= activePage.equals("news") ? "active" : "" %>">
            <i class="fa-solid fa-newspaper"></i> Quản lý Tin tức
        </a>
        
        <a href="admin-users" class="menu-item <%= activePage.equals("users") ? "active" : "" %>">
            <i class="fa-solid fa-users"></i> Quản lý Khách hàng
        </a>
    </div>

    <div class="sidebar-footer">
        <a href="logout" class="btn-logout">
            <i class="fa-solid fa-power-off" style="margin-right: 8px;"></i> Đăng xuất
        </a>
    </div>
</nav>