<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.product"%>
<%@ page import="java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản Lý Sản Phẩm | Admin</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/AdminProduct.css">

<style>
    /* CSS Modal (Popup) - Giữ nguyên như cũ */
    .modal { display: none; position: fixed; z-index: 2000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); align-items: center; justify-content: center; backdrop-filter: blur(4px); }
    .modal-content { background-color: white; padding: 30px; border-radius: 10px; width: 600px; max-width: 90%; box-shadow: 0 10px 25px rgba(0,0,0,0.2); position: relative; animation: slideDown 0.3s ease-out; max-height: 90vh; overflow-y: auto; }
    @keyframes slideDown { from { transform: translateY(-50px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
    .close-btn { position: absolute; right: 20px; top: 15px; font-size: 28px; cursor: pointer; color: #aaa; transition: color 0.2s; }
    .close-btn:hover { color: #dc3545; }
    .modal-title { text-align: center; margin-top: 0; color: #333; margin-bottom: 20px; font-weight: 700; }
    .form-row { display: flex; gap: 15px; margin-bottom: 15px; }
    .form-group { flex: 1; margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #555; font-size: 14px; }
    .form-group input, .form-group select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; font-size: 14px; transition: border-color 0.2s; }
    .form-group input:focus, .form-group select:focus { border-color: #3498db; outline: none; }
    .btn-submit-modal { background: #28a745; color: white; padding: 12px; border: none; width: 100%; cursor: pointer; font-size: 16px; border-radius: 6px; font-weight: 600; margin-top: 10px; transition: background 0.2s; }
    .btn-submit-modal:hover { background: #218838; }
</style>

</head>
<body>

    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="products" />
    </jsp:include>

    <main class="main-content">
        <div class="content-header">
            <h1 class="page-title">Quản Lý Sản Phẩm</h1>
            <button class="btn-add-new" onclick="openAddModal()" style="border: none; cursor: pointer;">
                <i class="fa-solid fa-plus" style="margin-right: 8px;"></i> Thêm sản phẩm mới
            </button>
        </div>

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
                    List<product> list = (List<product>) request.getAttribute("listP");
                    DecimalFormat df = new DecimalFormat("#,### VNĐ");
                    
                    if (list != null && !list.isEmpty()) {
                        for (product p : list) {
                    %>
                    <tr>
                        <td>#<%=p.getPid()%></td>
                        <td><img src="<%=p.getImage()%>" class="product-img" alt="Ảnh SP"></td>
                        <td style="font-weight: 500;"><%=p.getPdescription()%></td>
                        <td class="price-text"><%=df.format(p.getPrice())%></td>
                        <td><span class="stock-badge"><%=p.getStockquantyti()%> sp</span></td>
                        <td>
                            <div class="action-group">
                                <button type="button" class="btn-action btn-edit" title="Sửa"
                                    onclick="openEditModal(
                                        '<%=p.getPid()%>', 
                                        '<%=p.getPdescription()%>', 
                                        '<%=p.getPrice()%>', 
                                        '<%=p.getCid()%>', 
                                        '<%=p.getColor()%>', 
                                        '<%=p.getSize()%>', 
                                        '<%=p.getStockquantyti()%>', 
                                        '<%=p.getImage()%>'
                                    )">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                
                                <a href="admin-products?type=delete&pid=<%=p.getPid()%>" 
                                   class="btn-action btn-del" 
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa?')" title="Xóa">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% 
                        }
                    } else { 
                    %>
                    <tr><td colspan="6" style="text-align: center; padding: 30px; color: #777;">Chưa có sản phẩm nào.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <div id="productModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal()">&times;</span>
            <h2 class="modal-title" id="modal-title">Thông Tin Sản Phẩm</h2>
            
            <form action="admin-products" method="post" id="productForm">
                <input type="hidden" id="form-action" name="action" value="add">
                
                <input type="hidden" id="pid" name="pid">

                <div class="form-group">
                    <label>Tên sản phẩm:</label>
                    <input type="text" id="name" name="name" required placeholder="Nhập tên sản phẩm...">
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Giá tiền (VNĐ):</label>
                        <input type="number" id="price" name="price" step="0.01" required>
                    </div>
                    <div class="form-group">
                        <label>Danh mục:</label>
                        <select id="cateId" name="cateId">
                            <option value="1">1 - Áo</option>
                            <option value="2">2 - Quần</option>
                            <option value="3">3 - Phụ kiện</option>
                            <option value="4">4 - Khác</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Màu sắc:</label>
                        <input type="text" id="color" name="color">
                    </div>
                    <div class="form-group">
                        <label>Kích thước (Size):</label>
                        <input type="text" id="size" name="size" placeholder="S, M, L...">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Số lượng kho:</label>
                        <input type="number" id="stock" name="stock" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Link Hình ảnh:</label>
                    <input type="text" id="image" name="image" placeholder="Ví dụ: img/ao-thun.jpg">
                </div>
                
                <div style="text-align: center; margin-bottom: 15px;">
                     <img id="preview-image" src="" style="max-height: 100px; display: none; border-radius: 5px; border: 1px solid #ddd;">
                </div>

                <button type="submit" class="btn-submit-modal">
                    <i class="fa-solid fa-floppy-disk"></i> <span id="btn-text">Lưu Dữ Liệu</span>
                </button>
            </form>
        </div>
    </div>

    <script>
        var modal = document.getElementById('productModal');
        var imgPreview = document.getElementById('preview-image');

        // 1. Hàm mở Modal để THÊM MỚI (Reset form)
        function openAddModal() {
            // Đặt tiêu đề và nút bấm
            document.getElementById('modal-title').innerText = "Thêm Sản Phẩm Mới";
            document.getElementById('btn-text').innerText = "Thêm Mới";
            
            // Set action là "add" để Controller biết
            document.getElementById('form-action').value = "add";
            
            // Xóa trắng các ô input
            document.getElementById('pid').value = "0";
            document.getElementById('name').value = "";
            document.getElementById('price').value = "";
            document.getElementById('cateId').value = "1"; // Mặc định chọn cái đầu
            document.getElementById('color').value = "";
            document.getElementById('size').value = "";
            document.getElementById('stock').value = "100";
            document.getElementById('image').value = "";
            
            // Ẩn ảnh preview
            imgPreview.style.display = 'none';
            imgPreview.src = "";

            // Hiện Modal
            modal.style.display = 'flex';
        }

        // 2. Hàm mở Modal để SỬA (Điền dữ liệu cũ)
        function openEditModal(id, name, price, cateId, color, size, stock, image) {
            // Đặt tiêu đề và nút bấm
            document.getElementById('modal-title').innerText = "Cập Nhật Sản Phẩm";
            document.getElementById('btn-text').innerText = "Lưu Thay Đổi";
            
            // Set action là "update"
            document.getElementById('form-action').value = "update";
            
            // Điền dữ liệu vào form
            document.getElementById('pid').value = id;
            document.getElementById('name').value = name;
            document.getElementById('price').value = price;
            document.getElementById('cateId').value = cateId; // Tự động chọn đúng option
            document.getElementById('color').value = color;
            document.getElementById('size').value = size;
            document.getElementById('stock').value = stock;
            document.getElementById('image').value = image;

            // Hiện ảnh preview
            if(image) {
                imgPreview.src = image;
                imgPreview.style.display = 'inline-block';
            } else {
                imgPreview.style.display = 'none';
            }

            // Hiện Modal
            modal.style.display = 'flex';
        }

        function closeModal() {
            modal.style.display = 'none';
        }

        window.onclick = function(event) {
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>

</body>
</html>