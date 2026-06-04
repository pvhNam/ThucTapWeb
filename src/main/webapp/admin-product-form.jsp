<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Product"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm/Sửa Sản Phẩm | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="CSS/admin/Admin.css">
    <link rel="stylesheet" href="CSS/admin/admin-product-form.css">
</head>
<body>
<jsp:include page="sidebarAdmin.jsp">
    <jsp:param name="pageName" value="products" />
</jsp:include>
<main class="main-content">
    <%
        Product p = (Product) request.getAttribute("product");
        boolean isEdit = (p != null);
    %>
    <div class="content-header">
        <h1 class="page-title">
            <i class="fa-solid fa-shirt" style="color:var(--primary); margin-right:10px;"></i>
            <%= isEdit ? "Cập Nhật Sản Phẩm" : "Thêm Sản Phẩm Mới" %>
        </h1>
        <a href="admin-products" class="btn-add-new" style="background: #858796;">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>
    </div>

    <div class="form-wrapper">
        <form action="admin-products" method="post">
            <input type="hidden" name="action" value="<%= isEdit ? "update" : "add" %>">
            <% if(isEdit) { %><input type="hidden" name="pid" value="<%=p.getPid()%>"><% } %>

            <div class="form-group">
                <label>Tên sản phẩm *</label>
                <input type="text" name="name" required value="<%= isEdit ? p.getPdescription() : "" %>" placeholder="Nhập tên sản phẩm...">
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Giá tiền (VNĐ) *</label>
                    <input type="number" name="price" step="0.01" required value="<%= isEdit ? p.getPrice() : "" %>">
                </div>
                <div class="form-group">
                    <label>Danh mục *</label>
                    <select name="cateId">
                        <option value="1" <%= (isEdit && p.getCid()==1) ? "selected" : "" %>>1 - Năng động (Áo thun, Short...)</option>
                        <option value="2" <%= (isEdit && p.getCid()==2) ? "selected" : "" %>>2 - Công sở (Sơ mi, Quần tây...)</option>
                        <option value="3" <%= (isEdit && p.getCid()==3) ? "selected" : "" %>>3 - Dạ hội (Đầm, Suit...)</option>
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Màu sắc chung (Không bắt buộc)</label>
                    <input type="text" name="color" value="<%= isEdit ? (p.getColor()!=null?p.getColor():"") : "" %>" placeholder="Để trống nếu muốn quản lý qua biến thể">
                </div>
                <div class="form-group">
                    <label>Kích thước chung (Không bắt buộc)</label>
                    <input type="text" name="size" value="<%= isEdit ? (p.getSize()!=null?p.getSize():"") : "" %>" placeholder="Để trống nếu muốn quản lý qua biến thể">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Tổng tồn kho ban đầu *</label>
                    <input type="number" name="stock" required value="<%= isEdit ? p.getStockquantyti() : "0" %>">
                </div>
            </div>
            <div class="form-group">
                <label>Link Hình ảnh (Ảnh đại diện chính) *</label>
                <input type="text" name="image" required value="<%= isEdit ? p.getImage() : "" %>" placeholder="Ví dụ: img/sanpham.jpg">
            </div>

            <div class="form-group gallery-box">
                <label><i class="fa-solid fa-images"></i> Hình ảnh phụ (Gallery)</label>
                <div id="extra-images-container">
                    <%
                        if (isEdit && p.getExtraImages() != null && !p.getExtraImages().isEmpty()) {
                            for (String imgUrl : p.getExtraImages()) {
                    %>
                    <div class="extra-img-row">
                        <input type="text" name="extraImages" value="<%=imgUrl%>" placeholder="Nhập link ảnh phụ...">
                        <button type="button" class="btn-remove-img" onclick="this.parentElement.remove()" title="Xóa ô này">
                            <i class="fa-solid fa-trash"></i>
                        </button>
                    </div>
                    <%      }
                    }
                    %>
                </div>
                <button type="button" class="btn-add-img" onclick="addExtraImageField()">
                    <i class="fa-solid fa-plus"></i> Thêm link ảnh phụ
                </button>
            </div>

            <button type="submit" class="btn-submit">
                <i class="fa-solid fa-floppy-disk"></i> Lưu Dữ Liệu Sản Phẩm
            </button>
        </form>
    </div>
</main>

<script>
    function addExtraImageField() {
        const container = document.getElementById('extra-images-container');
        const div = document.createElement('div');
        div.className = 'extra-img-row';
        div.innerHTML = `
            <input type="text" name="extraImages" placeholder="Nhập link ảnh phụ...">
            <button type="button" class="btn-remove-img" onclick="this.parentElement.remove()" title="Xóa ô này">
                <i class="fa-solid fa-trash"></i>
            </button>
        `;
        container.appendChild(div);
    }
</script>
</body>
</html>
