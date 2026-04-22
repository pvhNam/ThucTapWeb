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
<style>
/* ===== INLINE FALLBACK: đảm bảo CSS hoạt động dù cache cũ ===== */
:root{--primary:#4e73df;--success:#1cc88a;--warning:#f6c23e;--danger:#e74a3b;--dark:#5a5c69;--bg:#f3f4f6;--text:#444;--shadow:0 4px 6px rgba(0,0,0,.07);--radius:10px;--sidebar-width:250px}
body{font-family:'Inter',sans-serif;margin:0;background:var(--bg);display:flex;min-height:100vh}
.main-content{margin-left:var(--sidebar-width);width:calc(100% - var(--sidebar-width));padding:30px;box-sizing:border-box}
.content-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:25px;padding-bottom:15px;border-bottom:2px solid #e3e6f0}
.page-title{font-size:22px;font-weight:700;color:var(--dark);margin:0}
.alert{padding:14px 18px;margin-bottom:20px;border-radius:6px;display:flex;align-items:center;gap:10px;font-weight:500}
.alert-success{background:#d1fae5;color:#065f46;border-left:5px solid var(--success)}
.alert-danger{background:#fce8e6;color:#7f1d1d;border-left:5px solid var(--danger)}
.page-sub{font-size:13px;color:#999;margin:4px 0 0}
.btn-back-page{display:inline-flex;align-items:center;gap:8px;padding:9px 20px;background:#fff;color:var(--dark);text-decoration:none;border-radius:8px;font-weight:600;font-size:14px;box-shadow:var(--shadow);transition:all .2s;white-space:nowrap}
.btn-back-page:hover{background:var(--primary);color:#fff}
.product-layout{display:grid;grid-template-columns:1fr 290px;gap:22px;align-items:start}
.product-main{display:flex;flex-direction:column;gap:20px}
.product-side{display:flex;flex-direction:column;gap:20px;position:sticky;top:20px}
.form-card{background:#fff;border-radius:var(--radius);box-shadow:var(--shadow);padding:24px}
.card-section-title{font-size:13px;font-weight:700;text-transform:uppercase;letter-spacing:.6px;color:var(--primary);display:flex;align-items:center;gap:8px;padding-bottom:14px;margin-bottom:20px;border-bottom:1px solid #f0f0f5}
.section-badge{margin-left:auto;font-size:10px;font-weight:700;background:#e8f0fe;color:var(--primary);padding:2px 10px;border-radius:20px;text-transform:none;letter-spacing:0}
.field-group{display:flex;flex-direction:column;gap:7px;margin-bottom:18px}
.field-group label{font-size:13px;font-weight:600;color:#555}
.req{color:var(--danger)}
.field-row{display:grid;grid-template-columns:1fr 1fr;gap:16px}
.input-icon-wrap{position:relative}
.input-icon-wrap i{position:absolute;left:13px;top:50%;transform:translateY(-50%);color:#b0b5c9;font-size:13px;pointer-events:none}
.input-icon-wrap input,.input-icon-wrap select{width:100%;padding:11px 14px 11px 38px;border:1.5px solid #e3e6f0;border-radius:8px;font-size:14px;font-family:'Inter',sans-serif;color:#333;background:#fafbfc;box-sizing:border-box;transition:border-color .2s,box-shadow .2s}
.input-icon-wrap input:focus,.input-icon-wrap select:focus{border-color:var(--primary);outline:none;box-shadow:0 0 0 3px rgba(78,115,223,.12);background:#fff}
.styled-textarea{width:100%;padding:11px 14px;border:1.5px solid #e3e6f0;border-radius:8px;font-size:14px;font-family:'Inter',sans-serif;color:#333;background:#fafbfc;box-sizing:border-box;resize:vertical;transition:border-color .2s}
.styled-textarea:focus{border-color:var(--primary);outline:none;box-shadow:0 0 0 3px rgba(78,115,223,.12)}
.select-native{-webkit-appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8'%3E%3Cpath fill='%23999' d='M1 1l5 5 5-5'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 12px center;padding-right:34px!important;cursor:pointer}
.profit-display{display:flex;align-items:center;gap:10px;padding:11px 16px;border-radius:8px;font-size:14px;font-weight:600;background:#f8f9fc;color:#aaa;border:1.5px solid #e3e6f0}
.profit-display.profit-pos{background:#eafbf4;color:#1cc88a;border-color:#a8e6cf}
.profit-display.profit-neg{background:#fce8e6;color:var(--danger);border-color:#f5b7b1}
.size-chips{display:flex;flex-wrap:wrap;gap:8px}
.sz-chip{padding:6px 16px;border:2px solid #e3e6f0;border-radius:6px;font-size:13px;font-weight:700;color:#888;cursor:pointer;background:#fafbfc;transition:all .15s;user-select:none}
.sz-chip:hover{border-color:var(--primary);color:var(--primary)}
.sz-chip.active{background:var(--primary);border-color:var(--primary);color:#fff}
.color-swatches{display:flex;flex-wrap:wrap;gap:8px}
.clr-swatch{width:32px;height:32px;border-radius:50%;cursor:pointer;transition:transform .15s,box-shadow .15s;position:relative;box-shadow:0 2px 6px rgba(0,0,0,.15)}
.clr-swatch:hover{transform:scale(1.15);box-shadow:0 4px 10px rgba(0,0,0,.2)}
.clr-swatch.active::after{content:'\f00c';font-family:'Font Awesome 6 Free';font-weight:900;position:absolute;inset:0;display:flex;align-items:center;justify-content:center;font-size:13px;color:#fff;text-shadow:0 1px 3px rgba(0,0,0,.5)}
.img-preview-box{margin-top:12px;min-height:160px;border:2px dashed #d1d3e2;border-radius:10px;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:10px;color:#bbb;font-size:14px;background:#fafbfc;overflow:hidden;transition:border-color .2s}
.img-preview-box i{font-size:38px}
.img-preview-box img{max-width:100%;max-height:220px;object-fit:contain;border-radius:6px}
.select-styled{width:100%;padding:11px 36px 11px 14px;border:1.5px solid #e3e6f0;border-radius:8px;font-size:14px;font-family:'Inter',sans-serif;color:#333;background:#fafbfc;cursor:pointer;transition:border-color .2s;-webkit-appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8'%3E%3Cpath fill='%23999' d='M1 1l5 5 5-5'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 14px center}
.receipt-summary{}
.rs-row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid #f0f0f5;font-size:13px}
.rs-row span{color:#888}.rs-row strong{color:#333;font-size:13px}
.rs-row:last-child{border-bottom:none}
.rs-total{padding-top:14px;margin-top:4px}
.rs-total span{font-weight:700;color:#555;font-size:14px}
.rs-total strong{color:var(--primary);font-size:15px}
.action-card{text-align:center}
.action-note{font-size:13px;color:#999;margin:0 0 18px;line-height:1.5}
.btn-submit-product{width:100%;padding:13px;background:linear-gradient(135deg,var(--primary),#224abe);color:#fff;border:none;border-radius:8px;font-size:14px;font-weight:700;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;box-shadow:0 4px 14px rgba(78,115,223,.4);transition:all .2s;margin-bottom:12px}
.btn-submit-product:hover{transform:translateY(-2px);box-shadow:0 8px 20px rgba(78,115,223,.5)}
.btn-cancel-product{width:100%;padding:11px;background:#f0f0f5;color:#666;border-radius:8px;font-size:14px;font-weight:600;text-decoration:none;display:flex;align-items:center;justify-content:center;gap:8px;transition:all .2s;box-sizing:border-box}
.btn-cancel-product:hover{background:#e0e0ea;color:#333}
@media(max-width:960px){.product-layout{grid-template-columns:1fr}.product-side{position:static;flex-direction:row;flex-wrap:wrap}.product-side .form-card{flex:1;min-width:220px}.field-row{grid-template-columns:1fr}}
</style>
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

            <%-- CỘT TRÁI --%>
            <div class="product-main">

                <%-- SECTION 1: Thông tin nhập hàng --%>
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
                                <input type="date" name="importDate"
                                       value="<%= LocalDate.now() %>" required>
                            </div>
                        </div>
                        <div class="field-group">
                            <label>Mã phiếu nhập</label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-hashtag"></i>
                                <input type="text" name="receiptCode"
                                       value="PN-<%= LocalDate.now().toString().replace("-","") %>"
                                       placeholder="Tự động tạo">
                            </div>
                        </div>
                    </div>

                    <div class="field-row">
                        <div class="field-group">
                            <label>Nhà cung cấp <span class="req">*</span></label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-building"></i>
                                <input type="text" name="supplier" required
                                       placeholder="Tên công ty / nhà cung cấp...">
                            </div>
                        </div>
                        <div class="field-group">
                            <label>Số điện thoại NCC</label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-phone"></i>
                                <input type="text" name="supplierPhone"
                                       placeholder="0xxx xxx xxx">
                            </div>
                        </div>
                    </div>

                    <div class="field-group">
                        <label>Ghi chú nhập hàng</label>
                        <textarea name="importNote" rows="2"
                                  class="styled-textarea"
                                  placeholder="Ghi chú về lô hàng, điều kiện giao hàng..."></textarea>
                    </div>
                </div>

                <%-- SECTION 2: Thông tin sản phẩm --%>
                <div class="form-card">
                    <div class="card-section-title">
                        <i class="fa-solid fa-tag"></i> Thông tin sản phẩm
                    </div>

                    <div class="field-group">
                        <label>Tên sản phẩm <span class="req">*</span></label>
                        <div class="input-icon-wrap">
                            <i class="fa-solid fa-pen-to-square"></i>
                            <input type="text" name="name" required
                                   placeholder="Nhập tên sản phẩm...">
                        </div>
                    </div>

                    <div class="field-row">
                        <div class="field-group">
                            <label>Giá bán (VNĐ) <span class="req">*</span></label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-dong-sign"></i>
                                <input type="number" name="price" id="priceInput"
                                       required min="0" placeholder="0">
                            </div>
                        </div>
                        <div class="field-group">
                            <label>Giá nhập (VNĐ)</label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-coins"></i>
                                <input type="number" name="importPrice"
                                       id="importPriceInput" min="0" placeholder="0">
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

                <%-- SECTION 3: Kho hàng & Thuộc tính --%>
                <div class="form-card">
                    <div class="card-section-title">
                        <i class="fa-solid fa-boxes-stacked"></i> Kho hàng &amp; Thuộc tính
                    </div>

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
                            <input type="text" name="size" id="sizeInput"
                                   placeholder="Hoặc nhập thủ công: S, M, L, XL...">
                        </div>
                    </div>

                    <div class="field-group">
                        <label>Màu sắc</label>
                        <div class="color-row">
                            <div class="color-swatches" id="colorSwatches">
                                <span class="clr-swatch" data-val="Đen"   style="background:#222;" title="Đen"></span>
                                <span class="clr-swatch" data-val="Trắng" style="background:#fff;border:2px solid #ddd;" title="Trắng"></span>
                                <span class="clr-swatch" data-val="Đỏ"   style="background:#e74a3b;" title="Đỏ"></span>
                                <span class="clr-swatch" data-val="Xanh navy" style="background:#224abe;" title="Xanh navy"></span>
                                <span class="clr-swatch" data-val="Xanh lá" style="background:#1cc88a;" title="Xanh lá"></span>
                                <span class="clr-swatch" data-val="Vàng" style="background:#f6c23e;" title="Vàng"></span>
                                <span class="clr-swatch" data-val="Xám"  style="background:#888;" title="Xám"></span>
                                <span class="clr-swatch" data-val="Hồng" style="background:#e91e8c;" title="Hồng"></span>
                            </div>
                        </div>
                        <div class="input-icon-wrap" style="margin-top:10px;">
                            <i class="fa-solid fa-palette"></i>
                            <input type="text" name="color" id="colorInput"
                                   placeholder="Hoặc nhập thủ công: Đỏ, Xanh...">
                        </div>
                    </div>
                </div>

                <%-- SECTION 4: Hình ảnh --%>
                <div class="form-card">
                    <div class="card-section-title">
                        <i class="fa-solid fa-image"></i> Hình ảnh sản phẩm
                    </div>
                    <div class="field-group">
                        <label>Đường dẫn ảnh</label>
                        <div class="input-icon-wrap">
                            <i class="fa-solid fa-link"></i>
                            <input type="text" name="image" id="imgInput"
                                   placeholder="Ví dụ: img/ao-thun-den.jpg">
                        </div>
                    </div>
                    <div class="img-preview-box" id="imgPreview">
                        <i class="fa-regular fa-image"></i>
                        <span>Xem trước hình ảnh sản phẩm</span>
                    </div>
                </div>

            </div>

            <%-- CỘT PHẢI --%>
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

                <%-- RECEIPT SUMMARY --%>
                <div class="form-card receipt-summary">
                    <div class="card-section-title"><i class="fa-solid fa-receipt"></i> Tóm tắt phiếu</div>
                    <div class="rs-row">
                        <span>Nhà cung cấp</span>
                        <strong id="rsSupplier">—</strong>
                    </div>
                    <div class="rs-row">
                        <span>Số lượng</span>
                        <strong id="rsQty">—</strong>
                    </div>
                    <div class="rs-row">
                        <span>Giá nhập / cái</span>
                        <strong id="rsImportPrice">—</strong>
                    </div>
                    <div class="rs-row rs-total">
                        <span>Tổng giá trị nhập</span>
                        <strong id="rsTotal">—</strong>
                    </div>
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
// --- Image preview ---
document.getElementById('imgInput').addEventListener('input', function() {
    var val = this.value.trim();
    var box = document.getElementById('imgPreview');
    box.innerHTML = val
        ? '<img src="' + val + '" alt="preview" onerror="this.style.display=\'none\'">'
        : '<i class="fa-regular fa-image"></i><span>Xem trước hình ảnh sản phẩm</span>';
});

// --- Size chips ---
document.querySelectorAll('.sz-chip').forEach(function(chip) {
    chip.addEventListener('click', function() {
        var input = document.getElementById('sizeInput');
        var val = this.dataset.val;
        var current = input.value.split(',').map(s=>s.trim()).filter(Boolean);
        if (this.classList.contains('active')) {
            this.classList.remove('active');
            current = current.filter(s => s !== val);
        } else {
            this.classList.add('active');
            if (!current.includes(val)) current.push(val);
        }
        input.value = current.join(', ');
    });
});

// --- Color swatches ---
document.querySelectorAll('.clr-swatch').forEach(function(sw) {
    sw.addEventListener('click', function() {
        var input = document.getElementById('colorInput');
        var val = this.dataset.val;
        var current = input.value.split(',').map(s=>s.trim()).filter(Boolean);
        if (this.classList.contains('active')) {
            this.classList.remove('active');
            current = current.filter(s => s !== val);
        } else {
            this.classList.add('active');
            if (!current.includes(val)) current.push(val);
        }
        input.value = current.join(', ');
    });
});

// --- Profit calculator & summary ---
function formatVND(n) {
    return Number(n).toLocaleString('vi') + ' VNĐ';
}

function updateSummary() {
    var supplier = document.querySelector('[name="supplier"]').value.trim();
    var qty      = parseInt(document.querySelector('[name="stock"]').value) || 0;
    var sellP    = parseFloat(document.getElementById('priceInput').value) || 0;
    var importP  = parseFloat(document.getElementById('importPriceInput').value) || 0;

    document.getElementById('rsSupplier').textContent    = supplier || '—';
    document.getElementById('rsQty').textContent         = qty ? qty + ' cái' : '—';
    document.getElementById('rsImportPrice').textContent = importP ? formatVND(importP) : '—';
    document.getElementById('rsTotal').textContent       = (qty && importP) ? formatVND(qty * importP) : '—';

    // Profit display
    var profitBox = document.getElementById('profitDisplay');
    if (sellP && importP) {
        var profit = sellP - importP;
        var pct    = importP > 0 ? ((profit / importP) * 100).toFixed(1) : 0;
        var isPos  = profit >= 0;
        profitBox.className = 'profit-display ' + (isPos ? 'profit-pos' : 'profit-neg');
        profitBox.innerHTML = '<i class="fa-solid fa-' + (isPos ? 'arrow-trend-up' : 'arrow-trend-down') + '"></i>'
            + '<span>' + (isPos ? '+' : '') + formatVND(profit) + ' / cái &nbsp;('
            + (isPos ? '+' : '') + pct + '%)</span>';
    } else {
        profitBox.className = 'profit-display';
        profitBox.innerHTML = '<i class="fa-solid fa-chart-line"></i><span>Nhập giá bán và giá nhập để tính</span>';
    }
}

['[name="supplier"]','[name="stock"]','#priceInput','#importPriceInput'].forEach(function(sel) {
    var el = document.querySelector(sel);
    if (el) el.addEventListener('input', updateSummary);
});
</script>
</body>
</html>
