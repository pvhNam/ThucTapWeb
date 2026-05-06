<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Product, model.ProductVariant"%>
<%@ page import="java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Kho Hàng | Admin</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="CSS/admin/Admin.css">
    <style>
        .variant-header {
            display: flex; gap: 20px; background: white; padding: 25px;
            border-radius: var(--radius); box-shadow: var(--shadow); margin-bottom: 25px;
        }
        .variant-header img { width: 120px; height: 120px; object-fit: cover; border-radius: 8px; border: 1px solid #eee; }
        .v-info h2 { margin: 0 0 10px 0; color: var(--dark); font-size: 22px; }
        .v-info p { margin: 5px 0; color: #555; font-size: 15px; }
    </style>
</head>
<body>

<jsp:include page="sidebarAdmin.jsp">
    <jsp:param name="pageName" value="products" />
</jsp:include>

<main class="main-content">
    <%
        Product p = (Product) request.getAttribute("product");
        List<ProductVariant> variants = (List<ProductVariant>) request.getAttribute("variants");
        DecimalFormat df = new DecimalFormat("#,### VNĐ");
    %>

    <div class="content-header">
        <div>
            <h1 class="page-title"><i class="fa-solid fa-boxes-stacked" style="color:var(--primary); margin-right:10px;"></i> Chi Tiết Kho Theo Phân Loại</h1>
        </div>
        <a href="admin-products" class="btn-add-new" style="background: #5a5c69;">
            <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
        </a>
    </div>

    <div class="variant-header">
        <img src="<%=p.getImage()%>" onerror="this.src='img/no-image.png'" alt="Product Image">
        <div class="v-info">
            <h2><%=p.getPdescription()%></h2>
            <p><strong>Mã SP:</strong> #<%=p.getPid()%></p>
            <p><strong>Giá bán:</strong> <span style="color: var(--danger); font-weight: bold;"><%=df.format(p.getPrice())%></span></p>
            <p><strong>Tổng tồn kho hệ thống:</strong> <span class="badge bg-process"><%=p.getStockquantyti()%></span></p>
        </div>
    </div>

    <div class="card-box">
        <h3 style="margin-top: 0; color: var(--dark); margin-bottom: 20px;">Danh sách Màu sắc & Kích thước</h3>

        <% if (variants != null && !variants.isEmpty()) { %>
        <table class="admin-table">
            <thead>
            <tr>
                <th>Màu Sắc</th>
                <th>Kích Thước (Size)</th>
                <th style="text-align: center;">Số Lượng Trong Kho</th>
            </tr>
            </thead>
            <tbody>
            <% for (ProductVariant v : variants) { %>
            <tr>
                <td><strong style="color: #333;"><%=v.getColor()%></strong></td>
                <td>
                                <span style="background: var(--primary); color: white; padding: 5px 12px; border-radius: 6px; font-size: 13px; font-weight: bold;">
                                    <%=v.getSize()%>
                                </span>
                </td>
                <td style="text-align: center; color: #1cc88a; font-weight: bold; font-size: 16px;">
                    <%=v.getStockQuantity()%>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
        <div style="text-align: center; padding: 40px; color: #888;">
            <i class="fa-solid fa-box-open" style="font-size: 40px; margin-bottom: 15px; color: #ccc;"></i>
            <h3 style="margin:0 0 10px 0; color:#555;">Sản phẩm này chưa có chi tiết phân loại</h3>
            <p>Hãy quay lại trang Danh sách sản phẩm và dùng tính năng <strong>Nhập thêm hàng</strong> để khai báo Màu sắc & Size.</p>
        </div>
        <% } %>
    </div>

</main>
</body>
</html>