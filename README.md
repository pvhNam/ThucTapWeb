# 🛍️ DoAnTTweb — Trang Web Kinh Doanh Thời Trang

Website thương mại điện tử bán quần áo thời trang, xây dựng theo mô hình **MVC** với **Jakarta Servlet/JSP** và **MySQL**. Dự án bao gồm đầy đủ luồng mua hàng cho người dùng (xem sản phẩm → giỏ hàng → thanh toán) và trang quản trị dành cho Admin (quản lý sản phẩm, đơn hàng, người dùng, tin tức, voucher, báo cáo...).

## 👥 Danh Sách Thành Viên

| STT | Họ và tên | MSSV |
|-----|------------------------|----------|
| 1 | Phạm Văn Hoài Nam | 23130200 |
| 2 | Nguyễn Quang Thành | 23130307 |
| 3 | Nguyễn Đức Khải | 23130142 |

## ✨ Tính Năng Chính

### 🧑‍💻 Phía Người Dùng (User)
- **Đăng ký / Đăng nhập / Đăng xuất**, đăng nhập nhanh bằng **Google OAuth 2.0**
- **Quên mật khẩu**: gửi mã **OTP qua email**, xác thực OTP và đặt mật khẩu mới
- **Trang chủ, trang giới thiệu (About)**, xem **bộ sưu tập (Collection)** sản phẩm
- **Tìm kiếm sản phẩm**, **lọc theo danh mục**
- **Xem chi tiết sản phẩm** với các biến thể (màu sắc, kích cỡ)
- **Giỏ hàng**: thêm / sửa số lượng / xóa sản phẩm (hiển thị màu sắc, kích cỡ từng món)
- **Mua ngay (Buy Now)** hoặc **thanh toán (Checkout)** từ giỏ hàng
- **Thanh toán online qua ví MoMo** (hoặc thanh toán khi nhận hàng - COD)
- **Áp dụng mã giảm giá (Voucher)** khi đặt hàng
- **Quản lý sổ địa chỉ**: thêm / sửa / xóa / chọn địa chỉ giao hàng
- **Lịch sử đơn hàng**, xem **chi tiết đơn hàng**, hủy / cập nhật đơn
- **Trang cá nhân (Profile)**: cập nhật thông tin, ảnh đại diện
- **Xem tin tức** và chi tiết bài viết
- **Đa ngôn ngữ (i18n)**: hỗ trợ Tiếng Việt 🇻🇳 và Tiếng Anh 🇬🇧

### 🛠️ Phía Quản Trị (Admin)
- **Dashboard** tổng quan, thống kê
- **Quản lý sản phẩm**: thêm / sửa / xóa, quản lý **biến thể sản phẩm** (màu, size, số lượng)
- **Nhập hàng** (import) và theo dõi lịch sử nhập hàng
- **Quản lý đơn hàng**: xem, cập nhật trạng thái đơn
- **Quản lý người dùng**: danh sách, xem chi tiết người dùng
- **Quản lý nhân viên (Staff)**: thêm / quản lý tài khoản nhân viên
- **Quản lý tin tức**: thêm / sửa / xóa bài viết
- **Quản lý voucher**: tạo / sửa mã giảm giá (theo % hoặc số tiền cố định, đơn tối thiểu, hạn dùng)
- **Xuất báo cáo doanh thu ra file Excel** (Apache POI)

## 🏗️ Công Nghệ Sử Dụng

| Thành phần | Công nghệ |
|---------------------|----------------------------------------------|
| Ngôn ngữ | Java 21 |
| Backend | Jakarta Servlet 6.0, JSP, JSTL 3.0 |
| Frontend | JSP, HTML, CSS, JavaScript |
| Cơ sở dữ liệu | MySQL 8.x (`mysql-connector-j`) |
| Build tool | Gradle (plugin `war`) |
| Server | Apache Tomcat 10.1+ (hỗ trợ Jakarta EE 10) |
| Thanh toán | MoMo Payment API (OkHttp + HMAC SHA256) |
| Gửi email | Jakarta Mail (SMTP Gmail) — OTP quên mật khẩu |
| Đăng nhập Google | Google OAuth 2.0 |
| Xuất Excel | Apache POI 5.2.3 |
| Mã hóa mật khẩu | MD5 |

## 📁 Cấu Trúc Dự Án

```
ThucTapWeb/
├── build.gradle                  # Cấu hình Gradle & dependencies
├── settings.gradle
├── migrations/                   # Script khởi tạo database
│   ├── 001_init.sql              # Schema chính (users, product, orders, ...)
│   └── 002_address.sql           # Bảng địa chỉ giao hàng
└── src/main/
    ├── java/
    │   ├── controller/
    │   │   ├── admin/            # Các servlet trang quản trị
    │   │   │   ├── AdminController.java          (/admin)
    │   │   │   ├── AdminProductController.java   (/admin-products)
    │   │   │   ├── AdminOrderController.java     (/admin-orders)
    │   │   │   ├── AdminUserController.java      (/admin-users)
    │   │   │   ├── AdminStaffController.java     (/admin-staffs)
    │   │   │   ├── AdminNewsController.java      (/admin-news)
    │   │   │   ├── AdminVoucherController.java   (/admin-vouchers)
    │   │   │   ├── AdminVariantController.java   (/admin-variants)
    │   │   │   └── ExportReportController.java   (/admin-export-report)
    │   │   └── user/             # Các servlet phía người dùng
    │   │       ├── HomeController, LoginController, RegisterController
    │   │       ├── GoogleLoginController, GoogleCallbackController
    │   │       ├── ForgotPasswordController, ValidateOtpController, NewPasswordController
    │   │       ├── CartController, AddToCartController, BuyNowController
    │   │       ├── CheckoutController, MomoCallbackController, VoucherController
    │   │       ├── OrderHistoryController, OrderDetailController, OrderSuccessController
    │   │       ├── AddressListServlet, AddAddressServlet, EditAddressServlet, ...
    │   │       ├── ProductDetailController, CollectionController, SearchController
    │   │       ├── NewsController, NewsDetailController, AboutController
    │   │       ├── ProfileController, LanguageController, LogoutController
    │   │       └── ...
    │   ├── dao/                  # Tầng truy cập dữ liệu
    │   │   ├── DBConnect.java    # Kết nối MySQL
    │   │   ├── UserDAO, ProductDAO, CartDAO, OrderDAO
    │   │   ├── AddressDAO, NewsDAO, VoucherDAO, ReportDAO
    │   ├── model/                # Các lớp thực thể
    │   │   ├── User, Product, ProductVariant, Category
    │   │   ├── CartItem, Order, OrderDetail, Address
    │   │   ├── News, Voucher, ...
    │   ├── service/
    │   │   └── MomoService.java  # Tích hợp thanh toán MoMo
    │   └── util/
    │       ├── EmailUtil.java    # Gửi email OTP qua SMTP
    │       ├── MD5.java          # Mã hóa mật khẩu
    │       └── LoggingConfigListener.java
    ├── resources/                # File ngôn ngữ i18n
    │   ├── messages_vi.properties
    │   └── messages_en.properties
    └── webapp/
        ├── WEB-INF/web.xml       # Cấu hình Google OAuth
        ├── index.jsp             # Trang chủ
        ├── login.jsp, register.jsp, forgot_password.jsp, verify_otp.jsp
        ├── collection.jsp, product-detail.jsp, cartitem.jsp
        ├── order-history.jsp, order-detail.jsp, order-success.jsp
        ├── profile.jsp, address-list.jsp, add-address.jsp
        ├── news.jsp, news-detail.jsp, about.jsp
        ├── admin*.jsp            # Các trang quản trị
        └── CSS/                  # Stylesheet (user/ và admin/)
```

## 🗄️ Cơ Sở Dữ Liệu

Database tên **`ltweb`**, gồm các bảng chính:

| Bảng | Mô tả |
|-------------------|--------------------------------------------------|
| `users` | Tài khoản người dùng / admin (`is_admin`: 0-User, 1-Admin) |
| `category` | Danh mục sản phẩm |
| `product` | Sản phẩm (tên, giá, giá vốn, màu, size, tồn kho, ảnh) |
| `cart` | Giỏ hàng của người dùng |
| `orders` | Đơn hàng (trạng thái, phương thức thanh toán) |
| `order_details` | Chi tiết từng sản phẩm trong đơn |
| `vouchers` | Mã giảm giá (PERCENT / FIXED, đơn tối thiểu, hạn dùng) |
| `news` | Bài viết tin tức |
| `import_history` | Lịch sử nhập hàng |
| `addresses` | Sổ địa chỉ giao hàng của người dùng |

## 🚀 Hướng Dẫn Cài Đặt & Chạy

### Yêu cầu môi trường
- **JDK 21** trở lên
- **MySQL 8.x**
- **Apache Tomcat 10.1+** (bắt buộc, vì dự án dùng Jakarta Servlet 6)
- **IntelliJ IDEA** (khuyến nghị) hoặc IDE hỗ trợ Gradle

### Bước 1 — Clone dự án
```bash
git clone <repository-url>
cd ThucTapWeb
```

### Bước 2 — Tạo database
Mở MySQL và chạy lần lượt các file migration:
```sql
CREATE DATABASE ltweb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ltweb;
SOURCE migrations/001_init.sql;
SOURCE migrations/002_address.sql;
```

### Bước 3 — Cấu hình kết nối database
Sửa thông tin tài khoản MySQL trong `src/main/java/dao/DBConnect.java`:
```java
private static final String url  = "jdbc:mysql://localhost:3306/ltweb?useSSL=false&allowPublicKeyRetrieval=true";
private static final String user = "admin";   // đổi thành user MySQL của bạn
private static final String pass = "2123";    // đổi thành mật khẩu của bạn
```

### Bước 4 — Cấu hình các dịch vụ tích hợp (tùy chọn)

**Google OAuth** — điền vào `src/main/webapp/WEB-INF/web.xml`:
```xml
<context-param>
    <param-name>google.clientId</param-name>
    <param-value>YOUR_CLIENT_ID</param-value>
</context-param>
<context-param>
    <param-name>google.clientSecret</param-name>
    <param-value>YOUR_CLIENT_SECRET</param-value>
</context-param>
```

**Email OTP** — sửa email gửi và App Password trong `src/main/java/util/EmailUtil.java` (dùng [App Password của Gmail](https://myaccount.google.com/apppasswords)).

**Thanh toán MoMo** — mặc định dùng **môi trường test (sandbox)** của MoMo. Có thể ghi đè bằng biến môi trường hoặc system property:
`MOMO_PARTNER_CODE`, `MOMO_ACCESS_KEY`, `MOMO_SECRET_KEY`, `MOMO_ENDPOINT`.

### Bước 5 — Build và deploy
```bash
# Build file WAR
./gradlew war
```
File WAR nằm tại `build/libs/ThucTapWeb-1.0-SNAPSHOT.war`.

**Cách 1 — Chạy bằng IntelliJ IDEA:**
1. `Run > Edit Configurations > + > Tomcat Server > Local`
2. Trỏ tới thư mục cài Tomcat 10.1+
3. Tab `Deployment` → Add Artifact → chọn `war exploded`
4. Run ▶️ — trình duyệt mở `http://localhost:8080/<context-path>/`

**Cách 2 — Deploy thủ công:** copy file `.war` vào thư mục `webapps/` của Tomcat rồi khởi động Tomcat.

### Bước 6 — Truy cập
| Trang | Đường dẫn |
|----------------|----------------------------|
| Trang chủ | `http://localhost:8080/<context-path>/home` |
| Đăng nhập | `http://localhost:8080/<context-path>/login` |
| Trang quản trị | `http://localhost:8080/<context-path>/admin` |

> 💡 Tài khoản có `is_admin = 1` trong bảng `users` mới truy cập được trang quản trị.

## 🔗 Danh Sách URL Chính

| Chức năng | URL |
|--------------------------|--------------------|
| Trang chủ | `/home` |
| Bộ sưu tập / cửa hàng | `/collection` |
| Tìm kiếm | `/search` |
| Chi tiết sản phẩm | `/product-detail` |
| Giỏ hàng | `/cart` |
| Thanh toán | `/checkout` |
| Lịch sử đơn hàng | `/order-history` |
| Trang cá nhân | `/profile` |
| Tin tức | `/news` |
| Đổi ngôn ngữ | `/change-lang` |
| Quản trị - Sản phẩm | `/admin-products` |
| Quản trị - Đơn hàng | `/admin-orders` |
| Quản trị - Người dùng | `/admin-users` |
| Quản trị - Voucher | `/admin-vouchers` |
| Quản trị - Xuất báo cáo | `/admin-export-report` |

## 📝 Ghi Chú

- Dự án dùng encoding **UTF-8** toàn bộ (code, database, giao diện) để hiển thị tiếng Việt chính xác.
- MoMo callback trả về tại `/momo-callback`; khi chạy local cần đảm bảo `redirectUrl` trỏ đúng context path của ứng dụng.
- Đây là đồ án môn học **Lập Trình Web** — chỉ dùng cho mục đích học tập.
