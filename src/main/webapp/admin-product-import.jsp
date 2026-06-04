<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Product"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phiếu Nhập Kho | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="CSS/admin/Admin.css">
    <link rel="stylesheet" href="CSS/admin/admin-product-import.css">
</head>
<body>
<jsp:include page="sidebarAdmin.jsp">
    <jsp:param name="pageName" value="products" />
</jsp:include>
<main class="main-content">
    <%
        Product p = (Product) request.getAttribute("product");
        java.time.LocalDate today = java.time.LocalDate.now();
    %>
    <div class="content-header">
        <h1 class="page-title">
            <i class="fa-solid fa-truck-ramp-box" style="color:#1cc88a; margin-right:10px;"></i> Phiếu Nhập Kho
        </h1>
        <a href="admin-products" class="btn-add-new" style="background: #858796;">
            <i class="fa-solid fa-arrow-left"></i> Hủy & Quay lại
        </a>
    </div>

    <div class="import-wrapper">
        <div class="im-banner">
            <div>
                <h3><%=p.getPdescription()%></h3>
                <p>Mã SP: <strong>#<%=p.getPid()%></strong> | Đang tồn kho: <strong style="color:var(--danger);"><%=p.getStockquantyti()%> cái</strong></p>
            </div>
            <img src="<%=p.getImage()%>" onerror="this.src='img/no-image.png'">
        </div>

        <form action="admin-products" method="post">
            <input type="hidden" name="action" value="import">
            <input type="hidden" name="pid" value="<%=p.getPid()%>">

            <div class="import-grid">
                <div class="form-group">
                    <label>Ngày lập phiếu *</label>
                    <input type="date" name="importDate" required value="<%=today.toString()%>">
                </div>
                <div class="form-group">
                    <label>Số lượng nhập thêm *</label>
                    <input type="number" name="addQty" required min="1" placeholder="Nhập số lượng...">
                </div>
            </div>

            <div class="form-group">
                <label>Kích thước phân loại *</label>
                <div class="size-selector">
                    <input type="radio" id="sz-S"    name="size" value="S"    required><label for="sz-S">S</label>
                    <input type="radio" id="sz-M"    name="size" value="M"          ><label for="sz-M">M</label>
                    <input type="radio" id="sz-L"    name="size" value="L"          ><label for="sz-L">L</label>
                    <input type="radio" id="sz-XL"   name="size" value="XL"         ><label for="sz-XL">XL</label>
                    <input type="radio" id="sz-XXL"  name="size" value="XXL"        ><label for="sz-XXL">XXL</label>
                    <input type="radio" id="sz-Free" name="size" value="Free"       ><label for="sz-Free">Free Size</label>
                </div>
            </div>

            <div class="form-group">
                <label>Màu sắc phân loại *</label>
                <div class="color-selector">
                    <input type="radio" id="cl-den"   name="color" value="Đen"       required><label for="cl-den"   style="background:#222;"                   title="Đen"></label>
                    <input type="radio" id="cl-trang" name="color" value="Trắng"            ><label for="cl-trang" style="background:#fff; border:2px solid #ddd;" title="Trắng"></label>
                    <input type="radio" id="cl-do"    name="color" value="Đỏ"               ><label for="cl-do"    style="background:#e74a3b;"                 title="Đỏ"></label>
                    <input type="radio" id="cl-navy"  name="color" value="Xanh Navy"        ><label for="cl-navy"  style="background:#224abe;"                 title="Xanh Navy"></label>
                    <input type="radio" id="cl-reu"   name="color" value="Xanh Rêu"         ><label for="cl-reu"   style="background:#1cc88a;"                 title="Xanh Rêu"></label>
                    <input type="radio" id="cl-vang"  name="color" value="Vàng"             ><label for="cl-vang"  style="background:#f6c23e;"                 title="Vàng"></label>
                    <input type="radio" id="cl-xam"   name="color" value="Xám"              ><label for="cl-xam"   style="background:#888;"                   title="Xám"></label>
                    <input type="radio" id="cl-hong"  name="color" value="Hồng"             ><label for="cl-hong"  style="background:#e91e8c;"                 title="Hồng"></label>
                </div>
            </div>

            <button type="submit" class="btn-submit">
                <i class="fa-solid fa-check-to-slot"></i> XÁC NHẬN NHẬP KHO CHÍNH THỨC
            </button>
        </form>
    </div>
</main>
</body>
</html>
