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
    <link rel="stylesheet" href="CSS/admin/admin-variants.css">
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
            <h1 class="page-title">
                <i class="fa-solid fa-boxes-stacked" style="color:var(--primary); margin-right:10px;"></i>
                Chi Tiết Kho Theo Phân Loại
            </h1>
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
            <p><strong>Tổng tồn kho hệ thống:</strong>
                <span class="badge" style="background-color: var(--primary); color: white;"><%=p.getStockquantyti()%> cái</span>
            </p>
        </div>
    </div>

    <div class="card-box">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h3 style="margin: 0; color: var(--dark);">Danh sách Màu sắc & Kích thước</h3>
            <% if ("success".equals(request.getParameter("msg"))) { %>
            <span class="msg-success"><i class="fa-solid fa-circle-check"></i> Đã cập nhật kho hàng thành công!</span>
            <% } else if ("error".equals(request.getParameter("msg"))) { %>
            <span class="msg-error"><i class="fa-solid fa-circle-exclamation"></i> Có lỗi xảy ra, vui lòng thử lại!</span>
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
                <td style="text-align: center;">
                    <form action="admin-variants" method="post" class="form-inline variant-qty-form">
                        <input type="hidden" name="action" value="update-qty">
                        <input type="hidden" name="pid" value="<%=p.getPid()%>">
                        <input type="hidden" name="vid" value="<%=v.getId()%>">
                        <input type="number" name="newQty" value="<%=v.getStockQuantity()%>" class="variant-qty-input" min="0">
                        <button type="submit" class="btn-icon btn-icon-save" title="Lưu thay đổi số lượng">
                            <i class="fa-solid fa-save"></i>
                        </button>
                    </form>
                </td>
                <td style="text-align: center;">
                    <form action="admin-variants" method="post" class="form-inline"
                          onsubmit="return confirm('Bạn có chắc muốn xóa phân loại Màu/Size này không?')">
                        <input type="hidden" name="action" value="delete-variant">
                        <input type="hidden" name="pid" value="<%=p.getPid()%>">
                        <input type="hidden" name="vid" value="<%=v.getId()%>">
                        <button type="submit" class="btn-icon btn-icon-delete" title="Xóa phân loại này">
                            <i class="fa-solid fa-trash"></i>
                        </button>
                    </form>
                </td>
            </tr>
            <% } %>

            <%
                int unclassified = p.getStockquantyti() - totalDetailed;
                if (unclassified > 0) {
            %>
            <tr class="unclassified-row">
                <td class="unclassified-label">
                    <strong>Chưa phân loại</strong><br>
                    <small style="opacity: 0.8;">(Dữ liệu cũ chưa khai báo Màu/Size)</small>
                </td>
                <td>
                    <span style="background: #ccc; color: #555; padding: 5px 12px; border-radius: 6px; font-size: 13px; font-weight: bold;">N/A</span>
                </td>
                <td style="text-align: center; color: #856404; font-weight: bold; font-size: 16px;"><%=unclassified%></td>
                <td style="text-align: center;"><i class="fa-solid fa-ban" style="color: #ccc;" title="Không thể xóa"></i></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
        <div class="empty-variants">
            <i class="fa-solid fa-box-open"></i>
            <h3 style="margin:0 0 10px 0; color:#555;">Sản phẩm này chưa có chi tiết phân loại</h3>
            <p>Hãy quay lại trang Danh sách sản phẩm và dùng tính năng <strong>Nhập thêm hàng</strong> để khai báo Màu sắc & Size.</p>
        </div>
        <% } %>
    </div>
</main>
</body>
</html>
