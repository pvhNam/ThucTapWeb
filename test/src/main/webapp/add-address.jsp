<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Thêm địa chỉ mới</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .form-container { max-width: 500px; margin: 40px auto; font-family: sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);}
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 5px; font-weight: bold; font-size: 14px; color: #333;}
    .form-group input[type="text"],
    .form-group input[type="tel"],
    .form-group select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; background: #fff; }
    .form-group select:disabled { background: #f5f5f5; color: #888; cursor: not-allowed; }
    .address-row { display: flex; gap: 10px; }
    .address-row .form-group { flex: 1; }
    .address-error { display: none; margin-bottom: 12px; padding: 10px; border-radius: 4px; background: #fff3cd; color: #856404; font-size: 14px; }
    .checkbox-group { display: flex; align-items: center; gap: 8px; margin-top: 15px; }
    .btn-submit { width: 100%; padding: 12px; background: #27ae60; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; margin-top: 15px;}
    .btn-submit:hover { background: #219653; }
    .btn-back { display: block; text-align: center; margin-top: 15px; text-decoration: none; color: #888; font-size: 14px;}

    @media (max-width: 520px) {
      .address-row { display: block; }
    }
  </style>
</head>
<body>
<div class="form-container">
  <h2 style="text-align: center; margin-bottom: 20px;">Thêm địa chỉ mới</h2>

  <form action="add-address" method="post">
    <div class="form-group">
      <label for="receiverName">Tên người nhận</label>
      <input type="text" id="receiverName" name="receiverName" required placeholder="Nhập họ và tên">
    </div>
    <div class="form-group">
      <label for="phone">Số điện thoại</label>
      <input type="tel" id="phone" name="phone" required placeholder="Nhập số điện thoại">
    </div>

    <div id="addressError" class="address-error"></div>

    <div class="address-row">
      <div class="form-group">
        <label for="city">Tỉnh/Thành phố</label>
        <select id="city" name="city" required>
          <option value="">Đang tải tỉnh/thành phố...</option>
        </select>
      </div>
      <div class="form-group">
        <label for="district">Quận/Huyện</label>
        <select id="district" name="district" required disabled>
          <option value="">Chọn tỉnh/thành phố trước</option>
        </select>
      </div>
    </div>
    <div class="form-group">
      <label for="ward">Phường/Xã</label>
      <select id="ward" name="ward" required disabled>
        <option value="">Chọn quận/huyện trước</option>
      </select>
    </div>
    <div class="form-group">
      <label for="specificAddress">Địa chỉ cụ thể</label>
      <input type="text" id="specificAddress" name="specificAddress" required placeholder="Số nhà, tên đường...">
    </div>
    <div class="checkbox-group">
      <input type="checkbox" id="isDefault" name="isDefault" value="true">
      <label for="isDefault" style="margin:0; font-weight:normal; cursor:pointer;">Đặt làm địa chỉ mặc định</label>
    </div>

    <button type="submit" class="btn-submit">Lưu địa chỉ</button>
  </form>

  <a href="address-list" class="btn-back">Hủy và quay lại</a>
</div>
</body>
</html>