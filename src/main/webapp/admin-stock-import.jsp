<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lập phiếu nhập kho | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/CSS/admin/Admin.css">
    <link rel="stylesheet" href="${ctx}/CSS/admin/admin-stock-import.css?v=20260826.2">
</head>
<body>
<jsp:include page="sidebarAdmin.jsp">
    <jsp:param name="pageName" value="stock-import" />
</jsp:include>

<main class="main-content stock-import-page">
    <header class="content-header stock-page-header">
        <div>
            <p class="eyebrow">Quản lý mua hàng</p>
            <h1 class="page-title">Lập phiếu nhập kho</h1>
        </div>
        <a class="back-link" href="${ctx}/admin-products">
            <i class="fa-solid fa-arrow-left"></i> Danh sách sản phẩm
        </a>
    </header>

    <c:choose>
        <c:when test="${param.msg == 'success'}">
            <div class="stock-alert success">
                <i class="fa-solid fa-circle-check"></i>
                <div>
                    <strong>Đã nhập toàn bộ sản phẩm trong phiếu.</strong>
                    Tồn kho và giá vốn đã đồng bộ.
                    <a href="${ctx}/admin-stock-import/export?receiptId=${param.receiptId}">
                        <i class="fa-solid fa-file-excel"></i> Xuất phiếu vừa tạo
                    </a>
                </div>
            </div>
        </c:when>
        <c:when test="${param.msg == 'invalid'}">
            <div class="stock-alert danger">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <div><strong>Dữ liệu phiếu chưa hợp lệ.</strong> Kiểm tra sản phẩm, size, màu, số lượng và giá nhập.</div>
            </div>
        </c:when>
        <c:when test="${param.msg == 'error'}">
            <div class="stock-alert danger">
                <i class="fa-solid fa-circle-xmark"></i>
                <div><strong>Không thể nhập kho.</strong> Toàn bộ phiếu đã được hoàn tác, không có dòng kho nào bị ghi dở.</div>
            </div>
        </c:when>
    </c:choose>

    <c:choose>
        <c:when test="${empty products}">
            <section class="empty-products">
                <i class="fa-solid fa-box-open"></i>
                <h2>Chưa có sản phẩm để nhập kho</h2>
                <p>Hãy tạo sản phẩm trước, sau đó quay lại lập phiếu nhập.</p>
                <a href="${ctx}/admin-products?type=add">Thêm sản phẩm mới</a>
            </section>
        </c:when>
        <c:otherwise>
            <form action="${ctx}/admin-stock-import" method="post" id="stock-import-form" class="receipt-layout">
                <div class="receipt-main-column">
                    <section class="receipt-form-card receipt-meta-card">
                        <div class="section-heading">
                            <span class="step-number">1</span>
                            <div>
                                <h2>Thông tin phiếu nhập</h2>
                            </div>
                        </div>
                        <div class="form-grid meta-grid">
                            <label class="field">
                                <span>Ngày nhập kho <b>*</b></span>
                                <input type="date" name="importDate" value="${today}" max="${today}" required>
                            </label>
                            <label class="field">
                                <span>Nhà cung cấp</span>
                                <input type="text" name="supplier" maxlength="150" placeholder="Ví dụ: Công ty May Việt">
                            </label>
                            <label class="field note-field">
                                <span>Ghi chú</span>
                                <input type="text" name="note" maxlength="500" placeholder="Mã đơn mua, người giao hàng...">
                            </label>
                        </div>
                    </section>

                    <section class="receipt-form-card line-items-card">
                        <div class="items-heading">
                            <div class="section-heading">
                                <span class="step-number">2</span>
                                <div>
                                    <h2>Sản phẩm cần nhập</h2>
                                </div>
                            </div>
                            <button type="button" class="add-product-line" id="add-product-line">
                                <i class="fa-solid fa-plus"></i> Thêm sản phẩm
                            </button>
                        </div>


                        <div class="product-lines" id="product-lines">
                            <article class="product-line">
                                <div class="line-topbar">
                                    <span class="line-number">Sản phẩm 1</span>
                                    <button type="button" class="remove-line" title="Xóa dòng" disabled>
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </div>
                                <div class="line-fields">
                                    <label class="field product-field">
                                        <span>Sản phẩm <b>*</b></span>
                                        <select name="productId" class="line-product" data-selected-product="${selectedProductId}" required>
                                            <c:forEach var="product" items="${products}">
                                                <option value="${product.pid}"
                                                        data-name="<c:out value='${product.pdescription}' />"
                                                        data-stock="${product.stockquantyti}"
                                                        data-cost="${product.costPrice}">
                                                    #${product.pid} — <c:out value="${product.pdescription}" />
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </label>
                                    <label class="field">
                                        <span>Danh sách size <b>*</b></span>
                                        <input type="text" name="sizes" class="line-sizes" maxlength="300"
                                               placeholder="S, M, XL" required>
                                    </label>
                                    <label class="field">
                                        <span>Danh sách màu <b>*</b></span>
                                        <input type="text" name="colors" class="line-colors" maxlength="500"
                                               placeholder="Đen, Trắng, Xanh navy" required>
                                    </label>
                                    <label class="field quantity-field">
                                        <span>SL mỗi tổ hợp <b>*</b></span>
                                        <input type="number" name="quantity" class="line-quantity" min="1" max="1000000" step="1" value="1" required>
                                    </label>
                                    <label class="field cost-field">
                                        <span>Giá nhập/1 SP <b>*</b></span>
                                        <div class="input-with-unit">
                                            <input type="number" name="unitCost" class="line-cost" min="1" max="999999999" step="1" placeholder="0" required>
                                            <em>VNĐ</em>
                                        </div>
                                    </label>
                                </div>
                                <div class="line-preview">
                                    <div class="variant-preview-tags"></div>
                                    <div class="line-calculation">
                                        <span class="line-combinations">Chưa có phân loại</span>
                                        <strong class="line-total">0 ₫</strong>
                                    </div>
                                </div>
                            </article>
                        </div>
                    </section>
                </div>

                <aside class="receipt-summary-card">
                    <div class="summary-icon"><i class="fa-solid fa-clipboard-list"></i></div>
                    <h2>Tóm tắt phiếu nhập</h2>
                    <dl>
                        <div><dt>Sản phẩm</dt><dd id="summary-products">1</dd></div>
                        <div><dt>Dòng phân loại</dt><dd id="summary-variants">0</dd></div>
                        <div><dt>Tổng số lượng</dt><dd id="summary-quantity">0</dd></div>
                    </dl>
                    <div class="summary-total">
                        <span>Tổng tiền nhập</span>
                        <strong id="summary-total-cost">0 ₫</strong>
                    </div>
                    <button type="submit" class="submit-receipt">
                        <i class="fa-solid fa-file-circle-plus"></i> Tạo phiếu và nhập kho
                    </button>

                </aside>
            </form>

            <template id="product-line-template">
                <article class="product-line">
                    <div class="line-topbar">
                        <span class="line-number"></span>
                        <button type="button" class="remove-line" title="Xóa dòng">
                            <i class="fa-solid fa-trash"></i>
                        </button>
                    </div>
                    <div class="line-fields">
                        <label class="field product-field">
                            <span>Sản phẩm <b>*</b></span>
                            <select name="productId" class="line-product" required>
                                <c:forEach var="product" items="${products}">
                                    <option value="${product.pid}"
                                            data-name="<c:out value='${product.pdescription}' />"
                                            data-stock="${product.stockquantyti}"
                                            data-cost="${product.costPrice}">
                                        #${product.pid} — <c:out value="${product.pdescription}" />
                                    </option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Danh sách size <b>*</b></span>
                            <input type="text" name="sizes" class="line-sizes" maxlength="300" placeholder="S, M, XL" required>
                        </label>
                        <label class="field">
                            <span>Danh sách màu <b>*</b></span>
                            <input type="text" name="colors" class="line-colors" maxlength="500" placeholder="Đen, Trắng, Xanh navy" required>
                        </label>
                        <label class="field quantity-field">
                            <span>SL mỗi tổ hợp <b>*</b></span>
                            <input type="number" name="quantity" class="line-quantity" min="1" max="1000000" step="1" value="1" required>
                        </label>
                        <label class="field cost-field">
                            <span>Giá nhập/1 SP <b>*</b></span>
                            <div class="input-with-unit">
                                <input type="number" name="unitCost" class="line-cost" min="1" max="999999999" step="1" placeholder="0" required>
                                <em>VNĐ</em>
                            </div>
                        </label>
                    </div>
                    <div class="line-preview">
                        <div class="variant-preview-tags"></div>
                        <div class="line-calculation">
                            <span class="line-combinations">Chưa có phân loại</span>
                            <strong class="line-total">0 ₫</strong>
                        </div>
                    </div>
                </article>
            </template>
        </c:otherwise>
    </c:choose>

    <section class="history-card">
        <div class="history-heading">
            <div>
                <p class="eyebrow">Nhật ký mua hàng</p>
                <h2>Phiếu nhập gần đây</h2>
            </div>
            <span>30 phiếu mới nhất</span>
        </div>
        <div class="history-table-wrap">
            <table class="history-table">
                <thead>
                <tr>
                    <th>Mã phiếu</th>
                    <th>Ngày nhập</th>
                    <th>Nhà cung cấp</th>
                    <th>Sản phẩm</th>
                    <th>Phân loại</th>
                    <th>Tổng SL</th>
                    <th>Tổng tiền</th>
                    <th>Xuất phiếu</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="receipt" items="${recentReceipts}">
                    <tr>
                        <td><strong class="receipt-code"><c:out value="${receipt.receiptCode}" /></strong></td>
                        <td><c:out value="${receipt.importDate}" /></td>
                        <td><c:out value="${empty receipt.supplier ? '—' : receipt.supplier}" /></td>
                        <td>${receipt.productCount}</td>
                        <td>${receipt.itemCount}</td>
                        <td><strong class="quantity-added">+${receipt.totalQuantity}</strong></td>
                        <td><strong><fmt:formatNumber value="${receipt.totalAmount}" pattern="#,##0" /> ₫</strong></td>
                        <td>
                            <a class="export-receipt" href="${ctx}/admin-stock-import/export?receiptId=${receipt.id}">
                                <i class="fa-solid fa-file-excel"></i> Excel
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty recentReceipts}">
                    <tr><td colspan="8" class="empty-history">Chưa có phiếu nhập kho nào.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </section>
</main>

<script>
(() => {
    const form = document.getElementById('stock-import-form');
    if (!form) return;

    const linesContainer = document.getElementById('product-lines');
    const template = document.getElementById('product-line-template');
    const addButton = document.getElementById('add-product-line');
    const money = new Intl.NumberFormat('vi-VN');
    const compactSizes = new Set(['3XS', 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL', '2XL', '3XL', '4XL', '5XL']);

    function unique(values) {
        const result = [];
        const seen = new Set();
        values.forEach(value => {
            const normalized = value.trim();
            const key = normalized.toLocaleLowerCase('vi');
            if (normalized && !seen.has(key)) {
                seen.add(key);
                result.push(normalized);
            }
        });
        return result;
    }

    function parseColors(value) {
        return unique(value.split(/[,;|\r\n]+/));
    }

    function isCompactSize(value) {
        const normalized = value.toUpperCase();
        return compactSizes.has(normalized) || /^\d+(?:\.\d+)?$/.test(normalized);
    }

    function parseSizes(value) {
        const result = [];
        unique(value.split(/[,;|\r\n]+/)).forEach(chunk => {
            const parts = chunk.trim().split(/\s+/);
            if (parts.length > 1 && parts.every(isCompactSize)) result.push(...parts);
            else result.push(chunk);
        });
        return unique(result);
    }

    function updateLine(line) {
        const sizes = parseSizes(line.querySelector('.line-sizes').value);
        const colors = parseColors(line.querySelector('.line-colors').value);
        const quantity = Math.max(Number(line.querySelector('.line-quantity').value || 0), 0);
        const cost = Math.max(Number(line.querySelector('.line-cost').value || 0), 0);
        const combinations = sizes.length * colors.length;
        const units = combinations * quantity;
        const tags = line.querySelector('.variant-preview-tags');
        tags.replaceChildren();

        const previewValues = [];
        colors.forEach(color => sizes.forEach(size => previewValues.push(`${color} · ${size}`)));
        previewValues.slice(0, 8).forEach(value => {
            const tag = document.createElement('span');
            tag.textContent = value;
            tags.appendChild(tag);
        });
        if (previewValues.length > 8) {
            const more = document.createElement('span');
            more.textContent = `+${previewValues.length - 8} tổ hợp`;
            more.className = 'more-tag';
            tags.appendChild(more);
        }

        line.dataset.combinations = String(combinations);
        line.dataset.units = String(units);
        line.dataset.total = String(units * cost);
        line.querySelector('.line-combinations').textContent = combinations
            ? `${colors.length} màu × ${sizes.length} size = ${combinations} phân loại · ${money.format(units)} SP`
            : 'Chưa có phân loại';
        line.querySelector('.line-total').textContent = money.format(units * cost) + ' ₫';
        updateSummary();
    }

    function updateSummary() {
        const lines = [...linesContainer.querySelectorAll('.product-line')];
        const products = new Set(lines.map(line => line.querySelector('.line-product').value));
        const variants = lines.reduce((sum, line) => sum + Number(line.dataset.combinations || 0), 0);
        const units = lines.reduce((sum, line) => sum + Number(line.dataset.units || 0), 0);
        const total = lines.reduce((sum, line) => sum + Number(line.dataset.total || 0), 0);
        document.getElementById('summary-products').textContent = money.format(products.size);
        document.getElementById('summary-variants').textContent = money.format(variants);
        document.getElementById('summary-quantity').textContent = money.format(units);
        document.getElementById('summary-total-cost').textContent = money.format(total) + ' ₫';
        form.dataset.variantCount = String(variants);
    }

    function renumberLines() {
        const lines = [...linesContainer.querySelectorAll('.product-line')];
        lines.forEach((line, index) => {
            line.querySelector('.line-number').textContent = `Sản phẩm ${index + 1}`;
            line.querySelector('.remove-line').disabled = lines.length === 1;
        });
        addButton.disabled = lines.length >= 30;
        updateSummary();
    }

    function bindLine(line) {
        const selectedId = line.querySelector('.line-product').dataset.selectedProduct;
        if (selectedId && line.querySelector(`.line-product option[value="${selectedId}"]`)) {
            line.querySelector('.line-product').value = selectedId;
        }
        line.querySelectorAll('input, select').forEach(control => {
            control.addEventListener('input', () => updateLine(line));
            control.addEventListener('change', () => updateLine(line));
        });
        line.querySelector('.remove-line').addEventListener('click', () => {
            if (linesContainer.children.length <= 1) return;
            line.remove();
            renumberLines();
        });
        updateLine(line);
    }

    addButton.addEventListener('click', () => {
        if (linesContainer.children.length >= 30) return;
        const line = template.content.firstElementChild.cloneNode(true);
        linesContainer.appendChild(line);
        bindLine(line);
        renumberLines();
        line.querySelector('.line-product').focus();
    });

    form.addEventListener('submit', event => {
        const variantCount = Number(form.dataset.variantCount || 0);
        if (variantCount <= 0 || variantCount > 120) {
            event.preventDefault();
            alert(variantCount > 120
                ? 'Một phiếu chỉ được tối đa 120 dòng phân loại. Hãy tách thành nhiều phiếu.'
                : 'Vui lòng nhập ít nhất một size và một màu.');
            return;
        }
        if (!form.checkValidity()) {
            event.preventDefault();
            form.reportValidity();
        }
    });

    linesContainer.querySelectorAll('.product-line').forEach(bindLine);
    renumberLines();
})();
</script>
</body>
</html>
