-- Đánh giá sản phẩm: mỗi người dùng chỉ có một đánh giá cho mỗi sản phẩm.
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
    CONSTRAINT `fk_product_reviews_product`
        FOREIGN KEY (`product_id`) REFERENCES `product` (`pid`) ON DELETE CASCADE,
    CONSTRAINT `fk_product_reviews_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`uid`) ON DELETE CASCADE,
    CONSTRAINT `chk_product_reviews_rating` CHECK (`rating` BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
