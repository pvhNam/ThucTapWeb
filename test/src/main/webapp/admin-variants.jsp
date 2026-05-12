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
        .form-inline { margin: 0; padding: 0; display: inline-block; }
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
            <p><strong>Tổng tồn kho hệ thống:</strong> <span class="badge" style="background-color: var(--primary); color: white;"><%=p.getStockquantyti()%> cái</span></p>
        </div>
    </div>

    <div class="card-box">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h3 style="margin: 0; color: var(--dark);">Danh sách Màu sắc & Kích thước</h3>

            <%-- Hiển thị thông báo khi Cập nhật / Xóa thành công --%>
            <% if ("success".equals(request.getParameter("msg"))) { %>
            <span style="color: var(--success); font-weight: 600; font-size: 14px; background: #e0fdf4; padding: 6px 12px; border-radius: 6px;">
                    <i class="fa-solid fa-circle-check"></i> Đã cập nhật kho hàng thành công!
                </span>
            <% } else if ("error".equals(request.getParameter("msg"))) { %>
            <span style="color: var(--danger); font-weight: 600; font-size: 14px; background: #fce8e6; padding: 6px 12px; border-radius: 6px;">
                    <i class="fa-solid fa-circle-exclamation"></i> Có lỗi xảy ra, vui lòng thử lại!
                </span>
            <% } %>
        </div>

        <% if (variants != null && !variants.isEmpty()) { %>
        <table class="admin-table">
            <thead>
            <tr>
                <th>Màu Sắc</th>
                <th>Kích Thước (Size)</th>
                <th style="width: 220px; text-align: center;">Số Lượng Trong Kho</th>
                <th style="width: 120px; text-align: center;">Hành Động</th>
            </tr>
            </thead>
            <tbody>
            <%
                int totalDetailed = 0;
                for (ProductVariant v : variants) {
                    totalDetailed += v.getStockQuantity();
            %>
            <tr>
                <td><strong style="color: #333;"><%=v.getColor()%></strong></td>
                <td>
                    <span style="background: var(--primary); color: white; padding: 5px 12px; border-radius: 6px; font-size: 13px; font-weight: bold;">
                        <%=v.getSize()%>
                    </span>
                </td>

                <%-- CỘT CẬP NHẬT SỐ LƯỢNG (SỬA NHANH TẠI CHỖ) --%>
                <td style="text-align: center;">
                    <form action="admin-variants" method="post" class="form-inline" style="display: flex; align-items: center; gap: 8px; justify-content: center;">
                        <input type="hidden" name="action" value="update-qty">
                        <input type="hidden" name="pid" value="<%=p.getPid()%>">
                        <input type="hidden" name="vid" value="<%=v.getId()%>">

                        <input type="number" name="newQty" value="<%=v.getStockQuantity()%>"
                               style="width: 80px; padding: 6px; border: 2px solid #e3e6f0; border-radius: 6px; text-align: center; font-weight: bold; color: var(--success); font-size: 15px; outline: none;" min="0">

                        <button type="submit" class="btn-icon" style="background: var(--primary); color: white; width: 34px; height: 34px; border: none; border-radius: 6px; cursor: pointer; transition: 0.2s;" title="Lưu thay đổi số lượng">
                            <i class="fa-solid fa-save"></i>
                        </button>
                    </form>
                </td>

                <%-- CỘT XÓA PHÂN LOẠI --%>
                <td style="text-align: center;">
                    <form action="admin-variants" method="post" class="form-inline" onsubmit="return confirm('Bạn có chắc muốn xóa phân loại Màu/Size này không? (Hệ thống sẽ tự trừ đi số lượng tương ứng ra khỏi tổng kho)')">
                        <input type="hidden" name="action" value="delete-variant">
                        <input type="hidden" name="pid" value="<%=p.getPid()%>">
                        <input type="hidden" name="vid" value="<%=v.getId()%>">
                        <button type="submit" class="btn-icon" style="background: var(--danger); color: white; width: 34px; height: 34px; border: none; border-radius: 6px; cursor: pointer; transition: 0.2s;" title="Xóa phân loại này">
                            <i class="fa-solid fa-trash"></i>
                        </button>
                    </form>
                </td>
            </tr>
            <% } %>

            <%-- DÒNG ĐỐI CHIẾU: HÀNG CHƯA ĐƯỢC PHÂN LOẠI (NẾU CÓ CHÊNH LỆCH) --%>
            <%
                int unclassified = p.getStockquantyti() - totalDetailed;
                if (unclassified > 0) {
            %>
            <tr style="background-color: #fff3cd;">
                <td style="color: #856404;">
                    <strong>Chưa phân loại</strong> <br>
                    <small style="opacity: 0.8;">(Dữ liệu cũ chưa khai báo Màu/Size)</small>
                </td>
                <td>
                    <span style="background: #ccc; color: #555; padding: 5px 12px; border-radius: 6px; font-size: 13px; font-weight: bold;">N/A</span>
                </td>
                <td style="text-align: center; color: #856404; font-weight: bold; font-size: 16px;">
                    <%=unclassified%>
                </td>
                <td style="text-align: center;">
                    <i class="fa-solid fa-ban" style="color: #ccc;" title="Không thể xóa"></i>
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