<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Voucher"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Voucher | Admin</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/admin/Admin.css">
<link rel="stylesheet" href="CSS/admin/admin-voucher-form.css">
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

        <div class="content-header">
            <div>
                <h1 class="page-title">
                    <i class="fa-solid fa-ticket" style="color:var(--primary);margin-right:10px;"></i>
                    <%= isEdit ? "Cập nhật Voucher" : "Tạo Voucher Mới" %>
                </h1>
                <p class="vf-sub"><%= isEdit ? "Chỉnh sửa thông tin mã giảm giá" : "Điền thông tin để tạo mã giảm giá mới" %></p>
            </div>
            <a href="admin-vouchers" class="btn-back-vf">
                <i class="fa-solid fa-arrow-left"></i> Quay lại
            </a>
        </div>

        <div class="vf-layout">

            <div class="vf-form-card">
                <form action="admin-vouchers" method="post">
                    <input type="hidden" name="action" value="<%= isEdit ? "update" : "insert" %>">
                    <% if (isEdit) { %><input type="hidden" name="id" value="<%= v.getId() %>"><% } %>

                    <div class="vf-section">
                        <div class="vf-section-title"><i class="fa-solid fa-id-card"></i> Thông tin voucher</div>

                        <div class="vf-field">
                            <label>Mã Code <span class="req">*</span></label>
                            <div class="vf-input-wrap">
                                <i class="fa-solid fa-ticket"></i>
                                <input type="text" name="code" required
                                       value="<%= isEdit ? v.getCode() : "" %>"
                                       placeholder="Ví dụ: SALE20, FREESHIP..."
                                       style="text-transform:uppercase;">
                            </div>
                            <small class="vf-hint">Mã code phân biệt chữ hoa/thường</small>
                        </div>

                        <div class="vf-field">
                            <label>Mô tả</label>
                            <div class="vf-input-wrap">
                                <i class="fa-solid fa-align-left"></i>
                                <input type="text" name="description"
                                       value="<%= isEdit ? v.getDescription() : "" %>"
                                       placeholder="Mô tả ngắn về voucher...">
                            </div>
                        </div>
                    </div>

                    <div class="vf-section">
                        <div class="vf-section-title"><i class="fa-solid fa-percent"></i> Giảm giá</div>

                        <div class="vf-row">
                            <div class="vf-field">
                                <label>Loại giảm giá <span class="req">*</span></label>
                                <div class="vf-type-toggle">
                                    <label class="vf-type-option">
                                        <input type="radio" name="discountType" value="FIXED"
                                               <%= (!isEdit || "FIXED".equals(v.getDiscountType())) ? "checked" : "" %>>
                                        <span><i class="fa-solid fa-dong-sign"></i> Tiền mặt</span>
                                    </label>
                                    <label class="vf-type-option">
                                        <input type="radio" name="discountType" value="PERCENT"
                                               <%= (isEdit && "PERCENT".equals(v.getDiscountType())) ? "checked" : "" %>>
                                        <span><i class="fa-solid fa-percent"></i> Phần trăm</span>
                                    </label>
                                </div>
                            </div>
                            <div class="vf-field">
                                <label>Giá trị giảm <span class="req">*</span></label>
                                <div class="vf-input-wrap">
                                    <i class="fa-solid fa-tag"></i>
                                    <input type="number" name="discountAmount" required step="0.01" min="0"
                                           value="<%= isEdit ? v.getDiscountAmount() : "" %>"
                                           placeholder="0">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="vf-section">
                        <div class="vf-section-title"><i class="fa-solid fa-sliders"></i> Điều kiện áp dụng</div>

                        <div class="vf-row">
                            <div class="vf-field">
                                <label>Đơn hàng tối thiểu (VNĐ)</label>
                                <div class="vf-input-wrap">
                                    <i class="fa-solid fa-cart-shopping"></i>
                                    <input type="number" name="minOrder" required min="0"
                                           value="<%= isEdit ? (long)v.getMinOrder() : "0" %>"
                                           placeholder="0">
                                </div>
                            </div>
                            <div class="vf-field">
                                <label>Ngày hết hạn <span class="req">*</span></label>
                                <div class="vf-input-wrap">
                                    <i class="fa-regular fa-calendar"></i>
                                    <input type="date" name="expiryDate" required
                                           value="<%= isEdit ? v.getExpiryDate() : "" %>">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="vf-actions">
                        <a href="admin-vouchers" class="btn-vf-cancel">
                            <i class="fa-solid fa-xmark"></i> Hủy
                        </a>
                        <button type="submit" class="btn-vf-save">
                            <i class="fa-solid fa-<%= isEdit ? "floppy-disk" : "plus" %>"></i>
                            <%= isEdit ? "Lưu thay đổi" : "Tạo Voucher" %>
                        </button>
                    </div>
                </form>
            </div>

            <%-- Preview card bên phải --%>
            <div class="vf-preview-wrap">
                <div class="vf-preview-label"><i class="fa-solid fa-eye"></i> Xem trước</div>
                <div class="voucher-preview-card">
                    <div class="vp-top">
                        <div class="vp-store"><i class="fa-solid fa-store"></i> Fashion Store</div>
                        <div class="vp-badge" id="pvBadge">GIẢM GIÁ</div>
                    </div>
                    <div class="vp-code" id="pvCode"><i class="fa-solid fa-ticket"></i> <span>CODE</span></div>
                    <div class="vp-discount" id="pvDiscount">--</div>
                    <div class="vp-meta">
                        <span id="pvMin">Không giới hạn đơn tối thiểu</span>
                        <span id="pvExpiry">Hết hạn: --</span>
                    </div>
                </div>
            </div>

        </div>
    </main>

<script>
(function() {
    var codeInput    = document.querySelector('[name="code"]');
    var amountInput  = document.querySelector('[name="discountAmount"]');
    var minInput     = document.querySelector('[name="minOrder"]');
    var expiryInput  = document.querySelector('[name="expiryDate"]');
    var typeInputs   = document.querySelectorAll('[name="discountType"]');

    function update() {
        var code = codeInput.value.toUpperCase() || 'CODE';
        var amount = amountInput.value || '--';
        var min = minInput.value;
        var expiry = expiryInput.value;
        var type = document.querySelector('[name="discountType"]:checked')?.value || 'FIXED';

        document.getElementById('pvCode').innerHTML = '<i class="fa-solid fa-ticket"></i> <span>' + code + '</span>';

        if (amount !== '--') {
            document.getElementById('pvDiscount').textContent = type === 'PERCENT'
                ? amount + '%' : Number(amount).toLocaleString('vi') + ' VNĐ';
            document.getElementById('pvBadge').textContent = type === 'PERCENT' ? 'PHẦN TRĂM' : 'TIỀN MẶT';
        } else {
            document.getElementById('pvDiscount').textContent = '--';
        }

        document.getElementById('pvMin').textContent = min && Number(min) > 0
            ? 'Đơn tối thiểu: ' + Number(min).toLocaleString('vi') + ' VNĐ'
            : 'Không giới hạn đơn tối thiểu';

        document.getElementById('pvExpiry').textContent = expiry ? 'Hết hạn: ' + expiry : 'Hết hạn: --';
    }

    [codeInput, amountInput, minInput, expiryInput].forEach(function(el) {
        el.addEventListener('input', update);
    });
    typeInputs.forEach(function(el) { el.addEventListener('change', update); });

    update();
})();
</script>
</body>
</html>
