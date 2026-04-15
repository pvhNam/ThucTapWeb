<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Voucher"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thông tin Voucher</title>
<link rel="stylesheet" href="CSS/Admin.css">
<style>
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 5px; font-weight: 600; }
    .form-control { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
    .btn-save { background: #28a745; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; }
</style>
</head>
<body>
    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="vouchers" />
    </jsp:include>

    <main class="main-content">
        <%
            Voucher v = (Voucher) request.getAttribute("voucher");
            boolean isEdit = (v != null);
        %>
        <h2 class="page-title"><%= isEdit ? "Cập nhật Voucher" : "Thêm Voucher Mới" %></h2>
        
        <div class="card-box" style="max-width: 600px; margin: 0 auto;">
            <form action="admin-vouchers" method="post">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "insert" %>">
                <% if(isEdit) { %> <input type="hidden" name="id" value="<%= v.getId() %>"> <% } %>

                <div class="form-group">
                    <label>Mã Code:</label>
                    <input type="text" name="code" class="form-control" required value="<%= isEdit ? v.getCode() : "" %>">
                </div>
                
                <div class="form-group">
                    <label>Mô tả:</label>
                    <input type="text" name="description" class="form-control" value="<%= isEdit ? v.getDescription() : "" %>">
                </div>

                <div class="form-group" style="display: flex; gap: 20px;">
                    <div style="flex: 1;">
                        <label>Giá trị giảm:</label>
                        <input type="number" name="discountAmount" class="form-control" required step="0.01" value="<%= isEdit ? v.getDiscountAmount() : "" %>">
                    </div>
                    <div style="flex: 1;">
                        <label>Loại giảm giá:</label>
                        <select name="discountType" class="form-control">
                            <option value="FIXED" <%= isEdit && "FIXED".equals(v.getDiscountType()) ? "selected" : "" %>>Tiền mặt (VNĐ)</option>
                            <option value="PERCENT" <%= isEdit && "PERCENT".equals(v.getDiscountType()) ? "selected" : "" %>>Phần trăm (%)</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Đơn tối thiểu:</label>
                    <input type="number" name="minOrder" class="form-control" required value="<%= isEdit ? v.getMinOrder() : "0" %>">
                </div>

                <div class="form-group">
                    <label>Hạn sử dụng:</label>
                    <input type="date" name="expiryDate" class="form-control" required value="<%= isEdit ? v.getExpiryDate() : "" %>">
                </div>

                <button type="submit" class="btn-save">Lưu Voucher</button>
                <a href="admin-vouchers" style="margin-left: 10px; color: #666; text-decoration: none;">Hủy</a>
            </form>
        </div>
    </main>
</body>
</html>