<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhập Hàng | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="CSS/admin/Admin.css?v=3">
    <link rel="stylesheet" href="CSS/admin/admin-add-product.css?v=3">
</head>
<body>

<jsp:include page="sidebarAdmin.jsp">
    <jsp:param name="pageName" value="products" />
</jsp:include>

<main class="main-content">
    <div class="content-header">
        <div>
            <h1 class="page-title">
                <i class="fa-solid fa-truck-ramp-box" style="color:var(--primary);margin-right:10px;"></i>
                Phiếu Nhập Hàng
            </h1>
            <p class="page-sub">Thêm sản phẩm mới và ghi nhận thông tin nhập kho</p>
        </div>
        <a href="admin-products" class="btn-back-page">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>
    </div>

    <% if (request.getAttribute("successMsg") != null) { %>
    <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("successMsg") %></div>
    <% } %>
    <% if (request.getAttribute("errorMsg") != null) { %>
    <div class="alert alert-danger"><i class="fa-solid fa-circle-xmark"></i> <%= request.getAttribute("errorMsg") %></div>
    <% } %>

    <form action="admin-add-product" method="post" id="productForm">
        <div class="product-layout">

            <div class="product-main">

                <div class="form-card">
                    <div class="card-section-title">
                        <i class="fa-solid fa-file-invoice"></i> Thông tin nhập hàng
                        <span class="section-badge">Phiếu nhập</span>
                    </div>
                    <div class="field-row">
                        <div class="field-group">
                            <label>Ngày nhập <span class="req">*</span></label>
                            <div class="input-icon-wrap">
                                <i class="fa-regular fa-calendar"></i>
                                <input type="date" name="importDate" value="<%= LocalDate.now() %>" required>
                            </div>
                        </div>
                        <div class="field-group">
                            <label>Mã phiếu nhập</label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-hashtag"></i>
                                <input type="text" name="receiptCode" value="PN-<%= LocalDate.now().toString().replace("-","") %>" placeholder="Tự động tạo">
                            </div>
                        </div>
                    </div>
                    <div class="field-row">
                        <div class="field-group">
                            <label>Nhà cung cấp <span class="req">*</span></label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-building"></i>
                                <input type="text" name="supplier" required placeholder="Tên công ty / nhà cung cấp...">
                            </div>
                        </div>
                        <div class="field-group">
                            <label>Số điện thoại NCC</label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-phone"></i>
                                <input type="text" name="supplierPhone" placeholder="0xxx xxx xxx">
                            </div>
                        </div>
                    </div>
                    <div class="field-group">
                        <label>Ghi chú nhập hàng</label>
                        <textarea name="importNote" rows="2" class="styled-textarea" placeholder="Ghi chú về lô hàng..."></textarea>
                    </div>
                </div>

                <div class="form-card">
                    <div class="card-section-title"><i class="fa-solid fa-tag"></i> Thông tin sản phẩm</div>
                    <div class="field-group">
                        <label>Tên sản phẩm <span class="req">*</span></label>
                        <div class="input-icon-wrap">
                            <i class="fa-solid fa-pen-to-square"></i>
                            <input type="text" name="name" required placeholder="Nhập tên sản phẩm...">
                        </div>
                    </div>
                    <div class="field-row">
                        <div class="field-group">
                            <label>Giá bán (VNĐ) <span class="req">*</span></label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-dong-sign"></i>
                                <input type="number" name="price" id="priceInput" required min="0" placeholder="0">
                            </div>
                        </div>
                        <div class="field-group">
                            <label>Giá nhập (VNĐ)</label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-coins"></i>
                                <input type="number" name="importPrice" id="importPriceInput" min="0" placeholder="0">
                            </div>
                        </div>
                    </div>
                    <div class="field-group">
                        <label>Lợi nhuận dự kiến</label>
                        <div class="profit-display" id="profitDisplay">
                            <i class="fa-solid fa-chart-line"></i>
                            <span>Nhập giá bán và giá nhập để tính</span>
                        </div>
                    </div>
                </div>

                <div class="form-card">
                    <div class="card-section-title"><i class="fa-solid fa-boxes-stacked"></i> Kho hàng &amp; Thuộc tính</div>
                    <div class="field-row">
                        <div class="field-group">
                            <label>Số lượng nhập <span class="req">*</span></label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-layer-group"></i>
                                <input type="number" name="stock" value="100" min="1" required>
                            </div>
                        </div>
                        <div class="field-group">
                            <label>Đơn vị tính</label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-cube"></i>
                                <select name="unit" class="select-native">
                                    <option value="cái">Cái / Chiếc</option>
                                    <option value="bộ">Bộ</option>
                                    <option value="đôi">Đôi</option>
                                    <option value="hộp">Hộp</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="field-group">
                        <label>Kích thước (Size)</label>
                        <div class="size-chips" id="sizeChips">
                            <span class="sz-chip" data-val="S">S</span>
                            <span class="sz-chip" data-val="M">M</span>
                            <span class="sz-chip" data-val="L">L</span>
                            <span class="sz-chip" data-val="XL">XL</span>
                            <span class="sz-chip" data-val="XXL">XXL</span>
                            <span class="sz-chip" data-val="XXXL">XXXL</span>
                            <span class="sz-chip" data-val="Freesize">Free</span>
                        </div>
                        <div class="input-icon-wrap" style="margin-top:10px;">
                            <i class="fa-solid fa-ruler-horizontal"></i>
                            <input type="text" name="size" id="sizeInput" placeholder="Hoặc nhập thủ công: S, M, L, XL...">
                        </div>
                    </div>
                    <div class="field-group">
                        <label>Màu sắc</label>
                        <div class="color-swatches" id="colorSwatches">
                            <span class="clr-swatch" data-val="Đen"       style="background:#222;"                    title="Đen"></span>
                            <span class="clr-swatch" data-val="Trắng"     style="background:#fff;border:2px solid #ddd;" title="Trắng"></span>
                            <span class="clr-swatch" data-val="Đỏ"        style="background:#e74a3b;"                 title="Đỏ"></span>
                            <span class="clr-swatch" data-val="Xanh navy" style="background:#224abe;"                 title="Xanh navy"></span>
                            <span class="clr-swatch" data-val="Xanh lá"   style="background:#1cc88a;"                 title="Xanh lá"></span>
                            <span class="clr-swatch" data-val="Vàng"      style="background:#f6c23e;"                 title="Vàng"></span>
                            <span class="clr-swatch" data-val="Xám"       style="background:#888;"                   title="Xám"></span>
                            <span class="clr-swatch" data-val="Hồng"      style="background:#e91e8c;"                 title="Hồng"></span>
                        </div>
                        <div class="input-icon-wrap" style="margin-top:10px;">
                            <i class="fa-solid fa-palette"></i>
                            <input type="text" name="color" id="colorInput" placeholder="Hoặc nhập thủ công: Đỏ, Xanh...">
                        </div>
                    </div>
                </div>

                <div class="form-card">
                    <div class="card-section-title"><i class="fa-solid fa-image"></i> Hình ảnh sản phẩm</div>
                    <div class="field-group">
                        <label>Đường dẫn ảnh</label>
                        <div class="input-icon-wrap">
                            <i class="fa-solid fa-link"></i>
                            <input type="text" name="image" id="imgInput" placeholder="Ví dụ: img/ao-thun-den.jpg">
                        </div>
                    </div>
                    <div class="img-preview-box" id="imgPreview">
                        <i class="fa-regular fa-image"></i>
                        <span>Xem trước hình ảnh sản phẩm</span>
                    </div>
                </div>

            </div>

            <div class="product-side">
                <div class="form-card">
                    <div class="card-section-title"><i class="fa-solid fa-layer-group"></i> Danh mục</div>
                    <div class="field-group" style="margin-bottom:0;">
                        <label>Loại sản phẩm <span class="req">*</span></label>
                        <select name="cateId" class="select-styled">
                            <option value="1">👕 Áo</option>
                            <option value="2">👖 Quần</option>
                            <option value="3">👜 Phụ kiện</option>
                        </select>
                    </div>
                </div>

                <div class="form-card">
                    <div class="card-section-title"><i class="fa-solid fa-receipt"></i> Tóm tắt phiếu</div>
                    <div class="rs-row"><span>Nhà cung cấp</span><strong id="rsSupplier">—</strong></div>
                    <div class="rs-row"><span>Số lượng</span><strong id="rsQty">—</strong></div>
                    <div class="rs-row"><span>Giá nhập / cái</span><strong id="rsImportPrice">—</strong></div>
                    <div class="rs-row rs-total"><span>Tổng giá trị nhập</span><strong id="rsTotal">—</strong></div>
                </div>

                <div class="form-card action-card">
                    <div class="card-section-title"><i class="fa-solid fa-floppy-disk"></i> Xác nhận nhập</div>
                    <p class="action-note">Kiểm tra kỹ thông tin trước khi xác nhận nhập hàng vào hệ thống.</p>
                    <button type="submit" class="btn-submit-product">
                        <i class="fa-solid fa-truck-ramp-box"></i> Xác Nhận Nhập Hàng
                    </button>
                    <a href="admin-products" class="btn-cancel-product">
                        <i class="fa-solid fa-xmark"></i> Hủy bỏ
                    </a>
                </div>
            </div>
        </div>
    </form>
</main>

<script>
    document.getElementById('imgInput').addEventListener('input', function() {
        var val = this.value.trim();
        var box = document.getElementById('imgPreview');
        box.innerHTML = val ? '<img src="' + val + '" alt="preview" onerror="this.style.display=\'none\'">' : '<i class="fa-regular fa-image"></i><span>Xem trước hình ảnh sản phẩm</span>';
    });

    document.querySelectorAll('.sz-chip').forEach(function(chip) {
        chip.addEventListener('click', function() {
            var input = document.getElementById('sizeInput');
            var val = this.dataset.val;
            var current = input.value.split(',').map(s=>s.trim()).filter(Boolean);
            if (this.classList.contains('active')) { this.classList.remove('active'); current = current.filter(s => s !== val); }
            else { this.classList.add('active'); if (!current.includes(val)) current.push(val); }
            input.value = current.join(', ');
        });
    });

    document.querySelectorAll('.clr-swatch').forEach(function(sw) {
        sw.addEventListener('click', function() {
            var input = document.getElementById('colorInput');
            var val = this.dataset.val;
            var current = input.value.split(',').map(s=>s.trim()).filter(Boolean);
            if (this.classList.contains('active')) { this.classList.remove('active'); current = current.filter(s => s !== val); }
            else { this.classList.add('active'); if (!current.includes(val)) current.push(val); }
            input.value = current.join(', ');
        });
    });

    function formatVND(n) { return Number(n).toLocaleString('vi') + ' VNĐ'; }

    function updateSummary() {
        var supplier = document.querySelector('[name="supplier"]').value.trim();
        var qty      = parseInt(document.querySelector('[name="stock"]').value) || 0;
        var sellP    = parseFloat(document.getElementById('priceInput').value) || 0;
        var importP  = parseFloat(document.getElementById('importPriceInput').value) || 0;
        document.getElementById('rsSupplier').textContent    = supplier || '—';
        document.getElementById('rsQty').textContent         = qty ? qty + ' cái' : '—';
        document.getElementById('rsImportPrice').textContent = importP ? formatVND(importP) : '—';
        document.getElementById('rsTotal').textContent       = (qty && importP) ? formatVND(qty * importP) : '—';
        var profitBox = document.getElementById('profitDisplay');
        if (sellP && importP) {
            var profit = sellP - importP; var pct = importP > 0 ? ((profit / importP) * 100).toFixed(1) : 0; var isPos = profit >= 0;
            profitBox.className = 'profit-display ' + (isPos ? 'profit-pos' : 'profit-neg');
            profitBox.innerHTML = '<i class="fa-solid fa-' + (isPos ? 'arrow-trend-up' : 'arrow-trend-down') + '"></i><span>' + (isPos ? '+' : '') + formatVND(profit) + ' / cái &nbsp;(' + (isPos ? '+' : '') + pct + '%)</span>';
        } else {
            profitBox.className = 'profit-display';
            profitBox.innerHTML = '<i class="fa-solid fa-chart-line"></i><span>Nhập giá bán và giá nhập để tính</span>';
        }
    }

    ['[name="supplier"]','[name="stock"]','#priceInput','#importPriceInput'].forEach(function(sel) {
        var el = document.querySelector(sel); if (el) el.addEventListener('input', updateSummary);
    });
</script>
</body>
</html>
