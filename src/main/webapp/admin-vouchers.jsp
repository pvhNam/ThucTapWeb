<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Voucher"%>
<%@ page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản lý Voucher | Fashion Store</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/admin/Admin.css">
<link rel="stylesheet" href="CSS/admin/admin-vouchers.css">
</head>
<body>
    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="vouchers" />
    </jsp:include>

    <main class="main-content">

        <div class="content-header">
            <div>
                <h1 class="page-title">Quản lý Mã Giảm Giá</h1>
                <%
                List<Voucher> listV = (List<Voucher>) request.getAttribute("listVouchers");
                int total = (listV != null) ? listV.size() : 0;
                %>
                <p class="voucher-subtitle"><%= total %> voucher đang hoạt động</p>
            </div>
            <a href="admin-vouchers?action=add" class="btn-add-new">
                <i class="fa-solid fa-plus"></i> Thêm Voucher
            </a>
        </div>

        <% if (request.getParameter("msg") != null) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i> Thao tác thành công!
        </div>
        <% } %>

        <%
        DecimalFormat df = new DecimalFormat("#,### VNĐ");
        if (listV != null && !listV.isEmpty()) {
        %>
        <div class="voucher-grid">
            <% for (Voucher v : listV) {
                boolean isPercent = "PERCENT".equals(v.getDiscountType());
                String discountLabel = isPercent ? (int)v.getDiscountAmount() + "%" : df.format(v.getDiscountAmount());
                String cardAccent = isPercent ? "accent-purple" : "accent-green";
            %>
            <div class="voucher-card <%=cardAccent%>">
                <div class="vc-top">
                    <div class="vc-code">
                        <i class="fa-solid fa-ticket"></i>
                        <span><%=v.getCode()%></span>
                    </div>
                    <div class="vc-discount"><%=discountLabel%></div>
                </div>

                <div class="vc-divider">
                    <span class="vc-cut left"></span>
                    <div class="vc-dash"></div>
                    <span class="vc-cut right"></span>
                </div>

                <div class="vc-bottom">
                    <div class="vc-info-row">
                        <i class="fa-solid fa-circle-info"></i>
                        <span><%=v.getDescription() != null && !v.getDescription().isEmpty() ? v.getDescription() : "Không có mô tả"%></span>
                    </div>
                    <div class="vc-info-row">
                        <i class="fa-solid fa-cart-shopping"></i>
                        <span>Đơn tối thiểu: <strong><%=df.format(v.getMinOrder())%></strong></span>
                    </div>
                    <div class="vc-info-row">
                        <i class="fa-regular fa-calendar-xmark"></i>
                        <span>Hết hạn: <strong><%=v.getExpiryDate()%></strong></span>
                    </div>

                    <div class="vc-actions">
                        <a href="admin-vouchers?action=edit&id=<%=v.getId()%>" class="vc-btn vc-edit">
                            <i class="fa-solid fa-pen"></i> Sửa
                        </a>
                        <a href="admin-vouchers?action=delete&id=<%=v.getId()%>"
                           class="vc-btn vc-delete"
                           onclick="return confirm('Xóa voucher <%=v.getCode()%>?')">
                            <i class="fa-solid fa-trash"></i> Xóa
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>

        <% } else { %>
        <div class="empty-state">
            <i class="fa-solid fa-ticket-simple"></i>
            <h3>Chưa có voucher nào</h3>
            <p>Tạo voucher đầu tiên để bắt đầu khuyến mãi</p>
            <a href="admin-vouchers?action=add" class="btn-add-new" style="margin-top:12px;">
                <i class="fa-solid fa-plus"></i> Tạo Voucher
            </a>
        </div>
        <% } %>

    </main>
</body>
</html>
