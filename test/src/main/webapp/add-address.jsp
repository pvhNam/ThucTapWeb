<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Thêm địa chỉ mới</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="CSS/user/add-address.css">
</head>
<body>
<div class="form-container">
  <h2 class="page-heading">Thêm địa chỉ mới</h2>

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
<script>
  const provinceApiBaseUrl = 'https://provinces.open-api.vn/api/v1';
  const citySelect = document.getElementById('city');
  const districtSelect = document.getElementById('district');
  const wardSelect = document.getElementById('ward');
  const addressError = document.getElementById('addressError');
  const provinceCache = {};
  const districtCache = {};

  function setPlaceholder(select, text, disabled) {
    select.innerHTML = '';
    const option = document.createElement('option');
    option.value = '';
    option.textContent = text;
    select.appendChild(option);
    select.disabled = disabled;
  }

  function fillSelect(select, items, placeholder) {
    setPlaceholder(select, placeholder, false);
    items.forEach(function(item) {
      const option = document.createElement('option');
      option.value = item.name;
      option.textContent = item.name;
      option.dataset.code = item.code;
      select.appendChild(option);
    });
  }

  function selectedCode(select) {
    return select.selectedOptions[0] ? Number(select.selectedOptions[0].dataset.code) : null;
  }

  function fetchJson(url) {
    return fetch(url).then(function(response) {
      if (!response.ok) throw new Error('Không tải được dữ liệu địa chỉ');
      return response.json();
    });
  }

  function showAddressError(message) {
    addressError.style.display = 'block';
    addressError.textContent = message;
  }

  function clearAddressError() {
    addressError.style.display = 'none';
    addressError.textContent = '';
  }

  citySelect.addEventListener('change', function() {
    clearAddressError();
    const provinceCode = selectedCode(citySelect);
    setPlaceholder(districtSelect, 'Chọn quận/huyện', true);
    setPlaceholder(wardSelect, 'Chọn quận/huyện trước', true);
    if (!provinceCode) return;
    if (provinceCache[provinceCode]) {
      fillSelect(districtSelect, provinceCache[provinceCode].districts || [], 'Chọn quận/huyện');
      return;
    }
    setPlaceholder(districtSelect, 'Đang tải quận/huyện...', true);
    fetchJson(provinceApiBaseUrl + '/p/' + provinceCode + '?depth=2')
            .then(function(province) {
              provinceCache[provinceCode] = province;
              if (selectedCode(citySelect) === provinceCode)
                fillSelect(districtSelect, province.districts || [], 'Chọn quận/huyện');
            })
            .catch(function() {
              showAddressError('Không tải được danh sách quận/huyện. Vui lòng chọn lại hoặc tải lại trang.');
              setPlaceholder(districtSelect, 'Không tải được quận/huyện', true);
            });
  });

  districtSelect.addEventListener('change', function() {
    clearAddressError();
    const districtCode = selectedCode(districtSelect);
    setPlaceholder(wardSelect, 'Chọn phường/xã', true);
    if (!districtCode) return;
    if (districtCache[districtCode]) {
      fillSelect(wardSelect, districtCache[districtCode].wards || [], 'Chọn phường/xã');
      return;
    }
    setPlaceholder(wardSelect, 'Đang tải phường/xã...', true);
    fetchJson(provinceApiBaseUrl + '/d/' + districtCode + '?depth=2')
            .then(function(district) {
              districtCache[districtCode] = district;
              if (selectedCode(districtSelect) === districtCode)
                fillSelect(wardSelect, district.wards || [], 'Chọn phường/xã');
            })
            .catch(function() {
              showAddressError('Không tải được danh sách phường/xã. Vui lòng chọn lại hoặc tải lại trang.');
              setPlaceholder(wardSelect, 'Không tải được phường/xã', true);
            });
  });

  fetchJson(provinceApiBaseUrl + '/p/')
          .then(function(provinces) {
            clearAddressError();
            fillSelect(citySelect, provinces, 'Chọn tỉnh/thành phố');
          })
          .catch(function() {
            setPlaceholder(citySelect, 'Không tải được tỉnh/thành phố', true);
            showAddressError('Không tải được danh sách địa chỉ. Vui lòng kiểm tra kết nối mạng và tải lại trang.');
          });
</script>
</body>
</html>
