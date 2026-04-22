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
<link rel="stylesheet" href="CSS/admin/admin-products-modal.css">
</head>
<body>

    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="products" />
    </jsp:include>

    <main class="main-content">
        <div class="content-header">
            <h1 class="page-title">Quản Lý Sản Phẩm</h1>
            <button class="btn-add-new" onclick="openAddModal()" style="border: none; cursor: pointer; background: #28a745; color: white; padding: 10px 15px; border-radius: 5px;">
                <i class="fa-solid fa-plus" style="margin-right: 8px;"></i> Thêm sản phẩm mới
            </button>
        </div>

        <% if (request.getParameter("msg") != null) {
            String msg = request.getParameter("msg");
            String alertClass = "alert-success";
            String text = "Thao tác thành công!";
            if(msg.contains("error")) { alertClass = "alert-danger"; text = "Có lỗi xảy ra!"; }
            else if(msg.equals("imported")) text = "Đã nhập thêm hàng vào kho thành công!";
        %>
            <div class="alert <%=alertClass%>" style="padding: 10px; margin-bottom: 15px; background: #d4edda; color: #155724; border-radius: 5px;">
                <%= text %>
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
                        <td>#<%=p.getPid()%></td>
                        <td><img src="<%=p.getImage()%>" class="product-img" alt="Ảnh SP" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px;"></td>
                        <td style="font-weight: 500;"><%=p.getPdescription()%></td>
                        <td class="price-text"><%=df.format(p.getPrice())%></td>
                        <td><span class="stock-badge" style="background: #e2e6ea; padding: 5px 10px; border-radius: 15px; font-weight: bold;"><%=p.getStockquantyti()%></span></td>
                        <td>
                            <div class="action-group">
                                <button type="button" class="btn-icon btn-import" title="Nhập thêm hàng"
                                    onclick="openImportModal('<%=p.getPid()%>', '<%=p.getPdescription()%>', <%=p.getStockquantyti()%>)">
                                    <i class="fa-solid fa-box-open"></i>
                                </button>

                                <button type="button" class="btn-icon btn-edit" title="Sửa"
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
                                   class="btn-icon btn-delete"
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
                <div class="form-group"><label>Tên sản phẩm:</label><input type="text" id="name" name="name" required placeholder="Nhập tên sản phẩm..."></div>
                <div class="form-row">
                    <div class="form-group"><label>Giá tiền (VNĐ):</label><input type="number" id="price" name="price" step="0.01" required></div>
                    <div class="form-group"><label>Danh mục:</label><select id="cateId" name="cateId"><option value="1">1 - Áo</option><option value="2">2 - Quần</option><option value="3">3 - Phụ kiện</option><option value="4">4 - Khác</option></select></div>
                </div>
                <div class="form-row">
                    <div class="form-group"><label>Màu sắc:</label><input type="text" id="color" name="color"></div>
                    <div class="form-group"><label>Kích thước (Size):</label><input type="text" id="size" name="size" placeholder="S, M, L..."></div>
                </div>
                <div class="form-row">
                    <div class="form-group"><label>Số lượng kho (Tổng):</label><input type="number" id="stock" name="stock" required><small style="color: #666;">Chỉnh sửa trực tiếp tổng kho (nếu cần)</small></div>
                </div>
                <div class="form-group"><label>Link Hình ảnh:</label><input type="text" id="image" name="image" placeholder="Ví dụ: img/ao-thun.jpg"></div>
                <div style="text-align: center; margin-bottom: 15px;"><img id="preview-image" src="" style="max-height: 100px; display: none; border-radius: 5px; border: 1px solid #ddd;"></div>
                <button type="submit" class="btn-submit-modal"><i class="fa-solid fa-floppy-disk"></i> <span id="btn-text">Lưu Dữ Liệu</span></button>
            </form>
        </div>
    </div>

    <div id="importModal" class="modal">
        <div class="modal-content import-modal-content">
            <button class="close-btn" onclick="closeImportModal()" style="background:none;border:none;">&times;</button>

            <div class="im-header">
                <div class="im-header-icon"><i class="fa-solid fa-truck-ramp-box"></i></div>
                <div>
                    <h3 class="im-title">Phiếu Nhập Kho</h3>
                    <p class="im-sub">Cộng thêm hàng vào kho sản phẩm</p>
                </div>
            </div>

            <div class="im-product-banner">
                <div class="im-banner-row">
                    <i class="fa-solid fa-box"></i>
                    <span>Sản phẩm: <strong id="import-name"></strong></span>
                </div>
                <div class="im-banner-row">
                    <i class="fa-solid fa-warehouse"></i>
                    <span>Tồn kho hiện tại: <strong id="current-stock" style="color:var(--danger);"></strong></span>
                </div>
            </div>

            <form action="admin-products" method="post">
                <input type="hidden" name="action" value="import">
                <input type="hidden" name="pid" id="import-pid">

                <div class="im-row">
                    <div class="im-field">
                        <label>Ngày nhập <span class="req">*</span></label>
                        <div class="im-input-wrap">
                            <i class="fa-regular fa-calendar"></i>
                            <input type="date" name="importDate" id="importDateField" required>
                        </div>
                    </div>
                    <div class="im-field">
                        <label>Nhà cung cấp <span class="req">*</span></label>
                        <div class="im-input-wrap">
                            <i class="fa-solid fa-building"></i>
                            <input type="text" name="supplier" required placeholder="Tên công ty / NCC...">
                        </div>
                    </div>
                </div>

                <div class="im-field">
                    <label>Số lượng nhập thêm <span class="req">*</span></label>
                    <div class="im-input-wrap">
                        <i class="fa-solid fa-layer-group"></i>
                        <input type="number" name="addQty" id="addQtyInput" min="1" required placeholder="0">
                    </div>
                    <div class="im-hint">Tồn kho sau nhập: <strong id="newStockDisplay">—</strong></div>
                </div>

                <div class="im-field">
                    <label>Kích thước nhập</label>
                    <div class="im-size-chips" id="imSizeChips">
                        <span class="im-sz-chip" data-val="S">S</span>
                        <span class="im-sz-chip" data-val="M">M</span>
                        <span class="im-sz-chip" data-val="L">L</span>
                        <span class="im-sz-chip" data-val="XL">XL</span>
                        <span class="im-sz-chip" data-val="XXL">XXL</span>
                        <span class="im-sz-chip" data-val="Freesize">Free</span>
                    </div>
                    <div class="im-input-wrap" style="margin-top:8px;">
                        <i class="fa-solid fa-ruler-horizontal"></i>
                        <input type="text" name="size" id="imSizeInput" placeholder="Hoặc nhập thủ công: S, M, L...">
                    </div>
                </div>

                <div class="im-field">
                    <label>Màu sắc nhập</label>
                    <div class="im-color-swatches" id="imColorSwatches">
                        <span class="im-clr" data-val="Đen"   style="background:#222;"     title="Đen"></span>
                        <span class="im-clr" data-val="Trắng" style="background:#fff;border:2px solid #ddd;" title="Trắng"></span>
                        <span class="im-clr" data-val="Đỏ"   style="background:#e74a3b;" title="Đỏ"></span>
                        <span class="im-clr" data-val="Xanh navy" style="background:#224abe;" title="Xanh navy"></span>
                        <span class="im-clr" data-val="Xanh lá"  style="background:#1cc88a;" title="Xanh lá"></span>
                        <span class="im-clr" data-val="Vàng" style="background:#f6c23e;" title="Vàng"></span>
                        <span class="im-clr" data-val="Xám"  style="background:#888;"    title="Xám"></span>
                        <span class="im-clr" data-val="Hồng" style="background:#e91e8c;" title="Hồng"></span>
                    </div>
                    <div class="im-input-wrap" style="margin-top:8px;">
                        <i class="fa-solid fa-palette"></i>
                        <input type="text" name="color" id="imColorInput" placeholder="Hoặc nhập thủ công: Đỏ, Xanh...">
                    </div>
                </div>

                <div class="im-field">
                    <label>Ghi chú</label>
                    <textarea name="importNote" rows="2" class="im-textarea"
                              placeholder="Ghi chú về lô hàng, điều kiện, chất lượng..."></textarea>
                </div>

                <button type="submit" class="im-submit-btn">
                    <i class="fa-solid fa-circle-check"></i> Xác Nhận Nhập Kho
                </button>
            </form>
        </div>
    </div>

    <script>
        var modal = document.getElementById('productModal');
        var importModal = document.getElementById('importModal');
        var imgPreview = document.getElementById('preview-image');

        function openAddModal() {
            document.getElementById('modal-title').innerText = "Thêm Sản Phẩm Mới";
            document.getElementById('btn-text').innerText = "Thêm Mới";
            document.getElementById('form-action').value = "add";
            document.getElementById('pid').value = "0";
            document.getElementById('name').value = "";
            document.getElementById('price').value = "";
            document.getElementById('cateId').value = "1";
            document.getElementById('color').value = "";
            document.getElementById('size').value = "";
            document.getElementById('stock').value = "100";
            document.getElementById('image').value = "";
            imgPreview.style.display = 'none';
            imgPreview.src = "";
            modal.style.display = 'flex';
        }

        function openEditModal(id, name, price, cateId, color, size, stock, image) {
            document.getElementById('modal-title').innerText = "Cập Nhật Sản Phẩm";
            document.getElementById('btn-text').innerText = "Lưu Thay Đổi";
            document.getElementById('form-action').value = "update";
            document.getElementById('pid').value = id;
            document.getElementById('name').value = name;
            document.getElementById('price').value = price;
            document.getElementById('cateId').value = cateId;
            document.getElementById('color').value = color;
            document.getElementById('size').value = size;
            document.getElementById('stock').value = stock;
            document.getElementById('image').value = image;
            if(image) { imgPreview.src = image; imgPreview.style.display = 'inline-block'; }
            else { imgPreview.style.display = 'none'; }
            modal.style.display = 'flex';
        }

        var currentStockVal = 0;

        function openImportModal(id, name, currentStock) {
            currentStockVal = parseInt(currentStock);
            document.getElementById('import-pid').value = id;
            document.getElementById('import-name').innerText = name;
            document.getElementById('current-stock').innerText = currentStock + ' sản phẩm';
            document.getElementById('newStockDisplay').innerText = '—';
            document.getElementById('addQtyInput').value = '';

            // Set today's date
            var today = new Date().toISOString().split('T')[0];
            document.getElementById('importDateField').value = today;

            // Reset chips & inputs
            document.querySelectorAll('.im-sz-chip').forEach(function(c){ c.classList.remove('active'); });
            document.querySelectorAll('.im-clr').forEach(function(c){ c.classList.remove('active'); });
            document.getElementById('imSizeInput').value = '';
            document.getElementById('imColorInput').value = '';

            importModal.style.display = 'flex';
        }

        // Live calc new stock
        document.getElementById('addQtyInput') && document.getElementById('addQtyInput').addEventListener('input', function() {
            var qty = parseInt(this.value) || 0;
            document.getElementById('newStockDisplay').innerText = qty > 0 ? (currentStockVal + qty) + ' sản phẩm' : '—';
        });

        // Size chips in modal
        document.querySelectorAll('.im-sz-chip').forEach(function(chip) {
            chip.addEventListener('click', function() {
                var input = document.getElementById('imSizeInput');
                var val = this.dataset.val;
                var current = input.value.split(',').map(function(s){return s.trim();}).filter(Boolean);
                if (this.classList.contains('active')) {
                    this.classList.remove('active');
                    current = current.filter(function(s){ return s !== val; });
                } else {
                    this.classList.add('active');
                    if (!current.includes(val)) current.push(val);
                }
                input.value = current.join(', ');
            });
        });

        // Color swatches in modal
        document.querySelectorAll('.im-clr').forEach(function(sw) {
            sw.addEventListener('click', function() {
                var input = document.getElementById('imColorInput');
                var val = this.dataset.val;
                var current = input.value.split(',').map(function(s){return s.trim();}).filter(Boolean);
                if (this.classList.contains('active')) {
                    this.classList.remove('active');
                    current = current.filter(function(s){ return s !== val; });
                } else {
                    this.classList.add('active');
                    if (!current.includes(val)) current.push(val);
                }
                input.value = current.join(', ');
            });
        });

        function closeModal() { modal.style.display = 'none'; }
        function closeImportModal() { importModal.style.display = 'none'; }

        window.onclick = function(event) {
            if (event.target == modal) closeModal();
            if (event.target == importModal) closeImportModal();
        }
    </script>

</body>
</html>
