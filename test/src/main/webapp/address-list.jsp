<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Address" %> <!-- Giả sử bạn có model Address -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Chọn địa chỉ giao hàng</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .address-container { max-width: 600px; margin: 50px auto; font-family: sans-serif; }
    .address-card { border: 1px solid #ddd; padding: 15px; margin-bottom: 15px; border-radius: 8px; display: flex; justify-content: space-between; align-items: center; }
    .address-card:hover { border-color: #27ae60; }
    .addr-info p { margin: 5px 0; color: #555; }
    .addr-name { font-weight: bold; color: #333; font-size: 16px; }
    .btn-select { background: #27ae60; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; text-decoration: none;}
    .btn-select:hover { background: #219653; }
    .btn-add-new { display: block; text-align: center; padding: 10px; background: #f8f9fa; border: 1px dashed #ccc; border-radius: 8px; text-decoration: none; color: #333; margin-top: 20px;}
  </style>
</head>
<body>
<div class="address-container">
  <h2><i class="fa-solid fa-location-dot"></i> Chọn địa chỉ giao hàng</h2>

  <%
    // Lấy danh sách địa chỉ từ Servlet truyền sang
    List<Address> addresses = (List<Address>) request.getAttribute("addressList");
    if (addresses != null && !addresses.isEmpty()) {
      for (Address addr : addresses) {
  %>
  <div class="address-card">
    <div class="addr-info">
      <p class="addr-name"><%= addr.getReceiverName() %> | <%= addr.getPhone() %></p>
      <p><%= addr.getSpecificAddress() %>, <%= addr.getWard() %>, <%= addr.getDistrict() %>, <%= addr.getCity() %></p>
    </div>

    <!-- Form gửi ID địa chỉ đã chọn về Servlet -->
    <form action="select-address" method="post">
      <input type="hidden" name="addressId" value="<%= addr.getId() %>">
      <input type="hidden" name="fullAddressInfo"
             value="<%= addr.getReceiverName() %> - <%= addr.getPhone() %> - <%= addr.getSpecificAddress() %>, <%= addr.getWard() %>, <%= addr.getDistrict() %>, <%= addr.getCity() %>">
      <button type="submit" class="btn-select">Chọn</button>
    </form>
  </div>
  <%      }
  } else { %>
  <p style="text-align:center; color:#888;">Bạn chưa có địa chỉ nào.</p>
  <% } %>

  <a href="add-address.jsp" class="btn-add-new"><i class="fa-solid fa-plus"></i> Thêm địa chỉ mới</a>
  <a href="cart" style="display:block; text-align:center; margin-top:15px; color:#888; text-decoration:none;">Quay lại giỏ hàng</a>
</div>
</body>
</html>