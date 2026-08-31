-- ================================================
-- Migration: 001_init.sql
-- Khởi tạo toàn bộ schema database ltweb
-- Dùng CREATE TABLE IF NOT EXISTS để chạy nhiều lần không bị lỗi
-- ================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Bảng users (tạo trước vì các bảng khác phụ thuộc)
CREATE TABLE IF NOT EXISTS `users` (
                                       `uid`         int NOT NULL AUTO_INCREMENT,
                                       `username`    varchar(50)  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `password`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `email`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `fullname`    varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `phonenumber` varchar(20)  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `avatar`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `is_admin`    int DEFAULT '0' COMMENT '0: User, 1: Admin',
    PRIMARY KEY (`uid`),
    UNIQUE KEY `username` (`username`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng category (tạo trước vì product phụ thuộc)
CREATE TABLE IF NOT EXISTS `category` (
                                          `id`   int NOT NULL AUTO_INCREMENT,
                                          `name` varchar(100) NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng vouchers (tạo trước vì user_wallet phụ thuộc)
CREATE TABLE IF NOT EXISTS `vouchers` (
                                          `id`              int NOT NULL AUTO_INCREMENT,
                                          `code`            varchar(50) NOT NULL,
    `description`     text,
    `discount_amount` double NOT NULL,
    `discount_type`   enum('PERCENT','FIXED') NOT NULL,
    `min_order`       double DEFAULT '0',
    `expiry_date`     date DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `code` (`code`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng product
CREATE TABLE IF NOT EXISTS `product` (
                                         `pid`        int NOT NULL AUTO_INCREMENT,
                                         `name`       varchar(255) DEFAULT NULL,
    `price`      double DEFAULT NULL,
    `cateID`     int DEFAULT NULL,
    `color`      varchar(50) DEFAULT NULL,
    `size`       varchar(10) DEFAULT NULL,
    `amount`     int DEFAULT NULL,
    `img`        varchar(500) DEFAULT NULL,
    `cost_price` double DEFAULT '0',
    PRIMARY KEY (`pid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng đánh giá sản phẩm
CREATE TABLE IF NOT EXISTS `product_reviews` (
                                                  `id`         int NOT NULL AUTO_INCREMENT,
                                                  `product_id` int NOT NULL,
    `user_id`    int NOT NULL,
    `rating`     tinyint unsigned NOT NULL,
    `comment`    varchar(1000) DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_product_reviews_product_user` (`product_id`, `user_id`),
    KEY `idx_product_reviews_user` (`user_id`),
    CONSTRAINT `fk_product_reviews_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`pid`) ON DELETE CASCADE,
    CONSTRAINT `fk_product_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`uid`) ON DELETE CASCADE,
    CONSTRAINT `chk_product_reviews_rating` CHECK (`rating` BETWEEN 1 AND 5)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng cart
CREATE TABLE IF NOT EXISTS `cart` (
                                      `id`         int NOT NULL AUTO_INCREMENT,
                                      `user_id`    int NOT NULL,
                                      `product_id` int NOT NULL,
                                      `quantity`   int DEFAULT '1',
                                      `size`       varchar(50) DEFAULT '',
    `color`      varchar(50) DEFAULT '',
    PRIMARY KEY (`id`),
    KEY `user_id` (`user_id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`)    REFERENCES `users`   (`uid`),
    CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`pid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng stock_receipts (đầu phiếu nhập kho)
CREATE TABLE IF NOT EXISTS `stock_receipts` (
                                                   `id`           int NOT NULL AUTO_INCREMENT,
                                                   `receipt_code` varchar(50) NOT NULL,
    `import_date`  date NOT NULL,
    `supplier`     varchar(150) DEFAULT NULL,
    `note`         varchar(500) DEFAULT NULL,
    `total_amount` double NOT NULL DEFAULT '0',
    `created_at`   datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_stock_receipt_code` (`receipt_code`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng import_history (các dòng phân loại thuộc phiếu nhập)
CREATE TABLE IF NOT EXISTS `import_history` (
                                                `id`           int NOT NULL AUTO_INCREMENT,
                                                `receipt_id`   int DEFAULT NULL,
                                                `product_id`   int DEFAULT NULL,
                                                `quantity`     int DEFAULT NULL,
                                                `import_price` double DEFAULT NULL,
                                                `variant_id`   int DEFAULT NULL,
                                                `color`        varchar(50) NOT NULL DEFAULT '',
                                                `size`         varchar(50) NOT NULL DEFAULT '',
                                                `import_date`  date DEFAULT NULL,
                                                `supplier`     varchar(150) DEFAULT NULL,
                                                `note`         varchar(500) DEFAULT NULL,
                                                `created_at`   datetime DEFAULT CURRENT_TIMESTAMP,
                                                PRIMARY KEY (`id`),
    KEY `idx_import_history_receipt` (`receipt_id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `fk_import_history_receipt` FOREIGN KEY (`receipt_id`) REFERENCES `stock_receipts` (`id`) ON DELETE CASCADE,
    CONSTRAINT `import_history_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`pid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng news
CREATE TABLE IF NOT EXISTS `news` (
                                      `id`         int NOT NULL AUTO_INCREMENT,
                                      `title`      varchar(255) NOT NULL,
    `short_desc` varchar(500) DEFAULT NULL,
    `content`    text,
    `image`      varchar(255) DEFAULT NULL,
    `created_at` date DEFAULT (curdate()),
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng orders
CREATE TABLE IF NOT EXISTS `orders` (
                                        `id`             int NOT NULL AUTO_INCREMENT,
                                        `user_id`        int DEFAULT NULL,
                                        `total_money`    double DEFAULT NULL,
                                        `address`        varchar(255) DEFAULT NULL,
    `status`         varchar(50) DEFAULT 'Đang xử lý',
    `created_at`     datetime DEFAULT CURRENT_TIMESTAMP,
    `payment_method` varchar(50) DEFAULT 'CASH',
    PRIMARY KEY (`id`),
    KEY `user_id` (`user_id`),
    CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`uid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng order_details
CREATE TABLE IF NOT EXISTS `order_details` (
                                               `id`         int NOT NULL AUTO_INCREMENT,
                                               `order_id`   int DEFAULT NULL,
                                               `product_id` int DEFAULT NULL,
                                               `price`      double DEFAULT NULL,
                                               `quantity`   int DEFAULT NULL,
                                               `color`      varchar(50) NOT NULL DEFAULT '',
                                               `size`       varchar(50) NOT NULL DEFAULT '',
                                               PRIMARY KEY (`id`),
    KEY `order_id` (`order_id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`)   REFERENCES `orders`  (`id`),
    CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`pid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng product_images
CREATE TABLE IF NOT EXISTS `product_images` (
                                                `id`         int NOT NULL AUTO_INCREMENT,
                                                `product_id` int NOT NULL,
                                                `image_url`  varchar(500) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`pid`) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng product_variants
CREATE TABLE IF NOT EXISTS `product_variants` (
                                                  `id`             int NOT NULL AUTO_INCREMENT,
                                                  `product_id`     int NOT NULL,
                                                  `color`          varchar(50) NOT NULL,
    `size`           varchar(20) NOT NULL,
    `stock_quantity` int DEFAULT '0',
    PRIMARY KEY (`id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`pid`) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng user_wallet
CREATE TABLE IF NOT EXISTS `user_wallet` (
                                             `id`         int NOT NULL AUTO_INCREMENT,
                                             `user_id`    int NOT NULL,
                                             `voucher_id` int NOT NULL,
                                             `is_used`    tinyint(1) DEFAULT '0',
    `saved_at`   timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `user_id` (`user_id`),
    KEY `voucher_id` (`voucher_id`),
    CONSTRAINT `user_wallet_ibfk_1` FOREIGN KEY (`user_id`)    REFERENCES `users`    (`uid`) ON DELETE CASCADE,
    CONSTRAINT `user_wallet_ibfk_2` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`)  ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET FOREIGN_KEY_CHECKS = 1;
