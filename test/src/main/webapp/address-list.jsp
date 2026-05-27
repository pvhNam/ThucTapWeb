<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Address" %>
<%!
  private String h(String value) {
    if (value == null) {
      return "";
    }
    return value
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Chọn địa chỉ giao hàng</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .address-container { max-width: 760px; margin: 50px auto; font-family: sans-serif; }
    .address-card { border: 1px solid #ddd; padding: 15px; margin-bottom: 15px; border-radius: 8px; display: flex; justify-content: space-between; gap: 16px; align-items: flex-start; }
    .address-card:hover { border-color: #27ae60; }
    .addr-info { flex: 1; min-width: 0; }
    .addr-info p { margin: 5px 0; color: #555; line-height: 1.45; }
    .addr-name { font-weight: bold; color: #333; font-size: 16px; }
    .default-badge { display: inline-block; margin-left: 8px; padding: 2px 8px; border-radius: 999px; background: #eafaf1; color: #219653; font-size: 12px; font-weight: 600; }
    .address-actions { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; justify-content: flex-end; }
    .address-actions form { margin: 0; }
    .btn-select,
    .btn-edit,
    .btn-delete { border: none; padding: 8px 12px; border-radius: 5px; cursor: pointer; text-decoration: none; font-size: 14px; display: inline-flex; align-items: center; gap: 6px; line-height: 1; }
    .btn-select { background: #27ae60; color: white; }
    .btn-select:hover { background: #219653; }
    .btn-edit { background: #f1c40f; color: #2c2c2c; }
    .btn-edit:hover { background: #d4ac0d; }
    .btn-delete { background: #e74c3c; color: white; }
    .btn-delete:hover { background: #c0392b; }
    .btn-add-new { display: block; text-align: center; padding: 10px; background: #f8f9fa; border: 1px dashed #ccc; border-radius: 8px; text-decoration: none; color: #333; margin-top: 20px; }
    .btn-add-new:hover { border-color: #27ae60; color: #219653; }
    .btn-back { display: block; text-align: center; margin-top: 15px; color: #888; text-decoration: none; }

    @media (max-width: 640px) {
      .address-container { margin: 24px 12px; }
      .address-card { display: block; }
      .address-actions { justify-content: flex-start; margin-top: 12px; }
    }
  </style>
</head>
<body>
<div class="address-container">
  <h2><i class="fa-solid fa-location-dot"></i> Chọn địa chỉ giao hàng</h2>

  <%
    List<Address> addresses = (List<Address>) request.getAttribute("addressList");
    if (addresses != null && !addresses.isEmpty()) {
      for (Address addr : addresses) {
        String fullAddressInfo = addr.getReceiverName() + " - " + addr.getPhone() + " - "
            + addr.getSpecificAddress() + ", " + addr.getWard() + ", "
            + addr.getDistrict() + ", " + addr.getCity();
  %>
  <div class="address-card">
    <div class="addr-info">
      <p class="addr-name">
        <%= h(addr.getReceiverName()) %> | <%= h(addr.getPhone()) %>
        <% if (addr.isDefault()) { %>
          <span class="default-badge">Mặc định</span>
        <% } %>
      </p>
      <p><%= h(addr.getSpecificAddress()) %>, <%= h(addr.getWard()) %>, <%= h(addr.getDistrict()) %>, <%= h(addr.getCity()) %></p>
    </div>

    <div class="address-actions">
      <form action="select-address" method="post">
        <input type="hidden" name="addressId" value="<%= addr.getId() %>">
        <input type="hidden" name="fullAddressInfo" value="<%= h(fullAddressInfo) %>">
        <button type="submit" class="btn-select"><i class="fa-solid fa-check"></i> Chọn</button>
      </form>

      <a href="edit-address?id=<%= addr.getId() %>" class="btn-edit">
        <i class="fa-solid fa-pen"></i> Sửa
      </a>

      <form action="delete-address" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?');">
        <input type="hidden" name="id" value="<%= addr.getId() %>">
        <button type="submit" class="btn-delete"><i class="fa-solid fa-trash"></i> Xóa</button>
      </form>
    </div>
  </div>
  <%      }
  } else { %>
  <p style="text-align:center; color:#888;">Bạn chưa có địa chỉ nào.</p>
  <% } %>

  <a href="add-address" class="btn-add-new"><i class="fa-solid fa-plus"></i> Thêm địa chỉ mới</a>
  <a href="cart" class="btn-back">Quay lại giỏ hàng</a>
</div>
</body>
</html>