<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Product"%>
<%@ page import="java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Sản Phẩm | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="CSS/admin/Admin.css">
    <link rel="stylesheet" href="CSS/admin/AdminProduct.css">
</head>
<body>

<jsp:include page="sidebarAdmin.jsp">
    <jsp:param name="pageName" value="products" />
</jsp:include>

<main class="main-content">
    <div class="content-header">
        <h1 class="page-title">Quản Lý Sản Phẩm</h1>
        <a href="admin-products?type=add" class="btn-add-new" style="text-decoration: none; background: #28a745; color: white; padding: 10px 15px; border-radius: 5px; font-weight: 600;">
            <i class="fa-solid fa-plus" style="margin-right: 8px;"></i> Thêm sản phẩm mới
        </a>
    </div>

    <% if (request.getParameter("msg") != null) {
        String msg = request.getParameter("msg");
        String alertClass = "alert-success";
        String text = "Thao tác thành công!";
        if(msg.contains("error")) { alertClass = "alert-danger"; text = "Có lỗi xảy ra!"; }
        else if(msg.equals("imported")) text = "Đã nhập hàng vào kho thành công!";
    %>
    <div class="alert <%=alertClass%>" style="padding: 10px; margin-bottom: 15px; background: #d4edda; color: #155724; border-radius: 5px; border-left: 4px solid #28a745;">
        <i class="fa-solid fa-circle-check"></i> <%= text %>
    </div>
    <% } %>

    <div class="card-box">
        <table class="admin-table">
            <thead>
            <tr>
                <th style="width: 50px;">ID</th>
                <th style="width: 80px;">Hình ảnh</th>
                <th>Tên Sản Phẩm</th>
                <th>Giá Bán</th>
                <th>Tồn Kho</th>
                <th>Hành Động</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Product> list = (List<Product>) request.getAttribute("listP");
                DecimalFormat df = new DecimalFormat("#,### VNĐ");

                if (list != null && !list.isEmpty()) {
                    for (Product p : list) {
            %>
            <tr>
                <td><strong>#<%=p.getPid()%></strong></td>
                <td><img src="<%=p.getImage()%>" onerror="this.src='img/no-image.png'" class="product-img" alt="Ảnh SP" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px; border: 1px solid #eee;"></td>

                <td style="font-weight: 500;">
                    <!-- LINK CHUYỂN SANG TRANG CHI TIẾT BIẾN THỂ -->
                    <a href="admin-variants?pid=<%=p.getPid()%>"
                       style="color: var(--primary); text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; transition: 0.2s;"
                       onmouseover="this.style.color='#2e59d9'" onmouseout="this.style.color='var(--primary)'" title="Xem chi tiết kho theo màu sắc, size">
                        <%=p.getPdescription()%>
                        <i class="fa-solid fa-arrow-up-right-from-square" style="font-size: 13px; color: #17a2b8;"></i>
                    </a>
                </td>

                <td class="price-text"><%=df.format(p.getPrice())%></td>
                <td>
                    <span class="stock-badge" style="background: #e2e6ea; color: #333; padding: 5px 12px; border-radius: 20px; font-weight: bold; font-size: 13px;">
                        <%=p.getStockquantyti()%>
                    </span>
                </td>
                <td>
                    <div class="action-group">
                        <!-- NÚT CHUYỂN SANG TRANG NHẬP KHO -->
                        <a href="admin-products?type=import&pid=<%=p.getPid()%>" class="btn-icon btn-import" style="background:#1cc88a; color:white; padding:6px 10px; border-radius:4px;" title="Nhập thêm hàng">
                            <i class="fa-solid fa-box-open"></i>
                        </a>

                        <!-- NÚT CHUYỂN SANG TRANG SỬA SẢN PHẨM -->
                        <a href="admin-products?type=edit&pid=<%=p.getPid()%>" class="btn-icon btn-edit" style="background:#f6c23e; color:white; padding:6px 10px; border-radius:4px;" title="Sửa thông tin">
                            <i class="fa-solid fa-pen"></i>
                        </a>

                        <a href="admin-products?type=delete&pid=<%=p.getPid()%>"
                           class="btn-icon btn-delete" style="background:#e74a3b; color:white; padding:6px 10px; border-radius:4px;"
                           onclick="return confirm('Bạn có chắc chắn muốn xóa?')" title="Xóa">
                            <i class="fa-solid fa-trash"></i>
                        </a>
                    </div>
                </td>
            </tr>
            <% } } else { %>
            <tr><td colspan="6" style="text-align: center; padding: 40px; color: #777;"><i class="fa-solid fa-box-open" style="font-size:30px; color:#ccc; margin-bottom:10px;"></i><br>Chưa có sản phẩm nào.</td></tr>
            <% } %>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>