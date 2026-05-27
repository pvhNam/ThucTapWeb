<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Address" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Chọn địa chỉ giao hàng</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="CSS/user/address-list.css">
</head>
<body>
<div class="address-container">
  <h2><i class="fa-solid fa-location-dot"></i> Chọn địa chỉ giao hàng</h2>

  <%
    List<Address> addresses = (List<Address>) request.getAttribute("addressList");
    if (addresses != null && !addresses.isEmpty()) {
      for (Address addr : addresses) {
  %>
  <div class="address-card">
    <div class="addr-info">
      <p class="addr-name"><%= addr.getReceiverName() %> | <%= addr.getPhone() %></p>
      <p><%= addr.getSpecificAddress() %>, <%= addr.getWard() %>, <%= addr.getDistrict() %>, <%= addr.getCity() %></p>
    </div>
    <form action="select-address" method="post">
      <input type="hidden" name="addressId" value="<%= addr.getId() %>">
      <input type="hidden" name="fullAddressInfo"
             value="<%= addr.getReceiverName() %> - <%= addr.getPhone() %> - <%= addr.getSpecificAddress() %>, <%= addr.getWard() %>, <%= addr.getDistrict() %>, <%= addr.getCity() %>">
      <button type="submit" class="btn-select">Chọn</button>
    </form>
  </div>
  <%
    }
  } else {
  %>
  <p style="text-align:center; color:#888;">Bạn chưa có địa chỉ nào.</p>
  <% } %>

  <a href="add-address.jsp" class="btn-add-new"><i class="fa-solid fa-plus"></i> Thêm địa chỉ mới</a>
  <a href="cart" class="btn-back-cart">Quay lại giỏ hàng</a>
</div>
</body>
</html>
