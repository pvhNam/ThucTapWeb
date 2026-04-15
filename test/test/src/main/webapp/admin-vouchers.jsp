<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Voucher"%>
<%@ page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản lý Voucher | Fashion Store</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/Admin.css">
</head>
<body>
    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="vouchers" />
    </jsp:include>

    <main class="main-content">
     <div class="content-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
    <h1 class="page-title" style="margin: 0;">Quản lý Mã Giảm Giá</h1>
    
    <a href="admin-vouchers?action=add" class="btn-add-new">
        <i class="fa-solid fa-plus"></i> <span>Thêm Voucher mới</span>
    </a>
</div>

<style>
    .btn-add-new {
        background-color: #28a745; /* Màu xanh lá */
        color: white;
        padding: 10px 20px; /* Tăng khoảng cách đệm */
        border-radius: 8px; /* Bo góc mềm mại hơn */
        text-decoration: none;
        font-weight: 600;
        font-size: 14px;
        display: inline-flex; /* Giúp icon và chữ thẳng hàng */
        align-items: center;
        gap: 8px; /* Khoảng cách giữa icon và chữ */
        transition: all 0.3s ease;
        box-shadow: 0 2px 5px rgba(40, 167, 69, 0.3); /* Đổ bóng nhẹ */
        white-space: nowrap; /* QUAN TRỌNG: Chống xuống dòng */
    }

    .btn-add-new:hover {
        background-color: #218838;
        transform: translateY(-2px); /* Hiệu ứng nhấc nút lên khi di chuột */
        box-shadow: 0 4px 8px rgba(40, 167, 69, 0.4);
    }
</style>

        <div class="card-box">
            <div class="chart-title" style="margin-bottom: 20px; font-weight: bold; color: #444;">
                Danh sách Voucher hiện có
            </div>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Mã Code</th>
                        <th>Giảm giá</th>
                        <th>Đơn tối thiểu</th>
                        <th>Hạn sử dụng</th>
                        <th>Mô tả</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    List<Voucher> list = (List<Voucher>) request.getAttribute("listVouchers");
                    DecimalFormat df = new DecimalFormat("#,### VNĐ");
                    if (list != null && !list.isEmpty()) {
                        for (Voucher v : list) {
                            String discountDisplay = v.getDiscountType().equals("PERCENT") ? 
                                                     (int)v.getDiscountAmount() + "%" : 
                                                     df.format(v.getDiscountAmount());
                    %>
                    <tr>
                        <td>#<%=v.getId()%></td>
                        <td><strong style="color:#007bff"><%=v.getCode()%></strong></td>
                        <td style="font-weight:bold; color:#e63946"><%=discountDisplay%></td>
                        <td><%=df.format(v.getMinOrder())%></td>
                        <td><%=v.getExpiryDate()%></td>
                        <td><%=v.getDescription()%></td>
                        <td>
                            <div class="action-group">
                                <a href="admin-vouchers?action=edit&id=<%=v.getId()%>" class="btn-action btn-view" title="Sửa">
                                    <i class="fa-solid fa-pen"></i>
                                </a>
                                <a href="admin-vouchers?action=delete&id=<%=v.getId()%>" class="btn-action btn-ship" style="background:#dc3545;" onclick="return confirm('Bạn chắc chắn muốn xóa?')" title="Xóa">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } } else { %>
                        <tr><td colspan="7" style="text-align:center; padding:20px;">Không có voucher nào.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>