CREATE TABLE `address` (
                           `id` int NOT NULL AUTO_INCREMENT,
                           `user_id` int NOT NULL,
                           `receiver_name` varchar(100) NOT NULL,
                           `phone` varchar(20) NOT NULL,
                           `specific_address` varchar(255) NOT NULL,
                           `ward` varchar(100) NOT NULL,
                           `district` varchar(100) NOT NULL,
                           `city` varchar(100) NOT NULL,
                           `is_default` tinyint(1) DEFAULT '0',
                           PRIMARY KEY (`id`),
                           KEY `user_id` (`user_id`),
                           CONSTRAINT `address_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`uid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;