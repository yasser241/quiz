-- =====================================================
-- Quiz Shop Database Schema
-- =====================================================

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE='STRICT_TRANS_TABLES';

-- =====================================================
-- 1. USERS TABLE
-- =====================================================
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(100) UNIQUE NOT NULL,
    `email` VARCHAR(150) UNIQUE NOT NULL,
    `phone` VARCHAR(20) UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `first_name` VARCHAR(100),
    `last_name` VARCHAR(100),
    `avatar` VARCHAR(255),
    `role` ENUM('admin', 'manager', 'support', 'accountant', 'customer') DEFAULT 'customer',
    `status` ENUM('active', 'inactive', 'banned', 'pending_verification') DEFAULT 'pending_verification',
    `email_verified` TINYINT(1) DEFAULT 0,
    `phone_verified` TINYINT(1) DEFAULT 0,
    `phone_verified_at` TIMESTAMP NULL,
    `email_verified_at` TIMESTAMP NULL,
    `last_login` TIMESTAMP NULL,
    `last_login_ip` VARCHAR(45),
    `login_attempts` INT DEFAULT 0,
    `locked_until` TIMESTAMP NULL,
    `newsletter_subscribed` TINYINT(1) DEFAULT 1,
    `sms_notifications` TINYINT(1) DEFAULT 1,
    `email_notifications` TINYINT(1) DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    INDEX `idx_email` (`email`),
    INDEX `idx_phone` (`phone`),
    INDEX `idx_role` (`role`),
    INDEX `idx_status` (`status`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 2. USER_ADDRESSES TABLE
-- =====================================================
DROP TABLE IF EXISTS `user_addresses`;
CREATE TABLE `user_addresses` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `receiver_name` VARCHAR(150) NOT NULL,
    `receiver_phone` VARCHAR(20) NOT NULL,
    `province` VARCHAR(100) NOT NULL,
    `city` VARCHAR(100) NOT NULL,
    `postal_code` VARCHAR(20),
    `address` TEXT NOT NULL,
    `is_default` TINYINT(1) DEFAULT 0,
    `type` ENUM('home', 'work', 'other') DEFAULT 'home',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_default` (`is_default`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 3. CATEGORIES TABLE
-- =====================================================
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `parent_id` BIGINT,
    `name` VARCHAR(150) NOT NULL,
    `slug` VARCHAR(200) UNIQUE NOT NULL,
    `description` TEXT,
    `image` VARCHAR(255),
    `icon` VARCHAR(100),
    `show_in_menu` TINYINT(1) DEFAULT 1,
    `sort_order` INT DEFAULT 0,
    `meta_title` VARCHAR(160),
    `meta_description` VARCHAR(160),
    `meta_keywords` VARCHAR(255),
    `status` ENUM('active', 'inactive') DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`parent_id`) REFERENCES `categories`(`id`) ON DELETE SET NULL,
    INDEX `idx_parent_id` (`parent_id`),
    INDEX `idx_slug` (`slug`),
    INDEX `idx_status` (`status`),
    INDEX `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 4. PRODUCTS TABLE
-- =====================================================
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `sku` VARCHAR(100) UNIQUE NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(300) UNIQUE NOT NULL,
    `short_description` VARCHAR(500),
    `description` LONGTEXT,
    `price` DECIMAL(15,2) NOT NULL,
    `cost_price` DECIMAL(15,2),
    `discount_price` DECIMAL(15,2),
    `discount_start_date` TIMESTAMP NULL,
    `discount_end_date` TIMESTAMP NULL,
    `discount_percentage` DECIMAL(5,2),
    `type` ENUM('simple', 'variable') DEFAULT 'simple',
    `manage_stock` TINYINT(1) DEFAULT 1,
    `stock_quantity` INT DEFAULT 0,
    `low_stock_threshold` INT DEFAULT 5,
    `allow_backorder` TINYINT(1) DEFAULT 0,
    `featured` TINYINT(1) DEFAULT 0,
    `status` ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    `rating` DECIMAL(3,2) DEFAULT 0,
    `rating_count` INT DEFAULT 0,
    `view_count` INT DEFAULT 0,
    `sale_count` INT DEFAULT 0,
    `weight` DECIMAL(8,3),
    `dimensions` VARCHAR(100),
    `barcode` VARCHAR(100),
    `meta_title` VARCHAR(160),
    `meta_description` VARCHAR(160),
    `meta_keywords` VARCHAR(255),
    `created_by` BIGINT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL,
    INDEX `idx_slug` (`slug`),
    INDEX `idx_sku` (`sku`),
    INDEX `idx_status` (`status`),
    INDEX `idx_featured` (`featured`),
    INDEX `idx_type` (`type`),
    INDEX `idx_rating` (`rating`),
    INDEX `idx_created_at` (`created_at`),
    FULLTEXT INDEX `fti_search` (`name`, `description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 5. PRODUCT_CATEGORIES TABLE (Many-to-Many)
-- =====================================================
DROP TABLE IF EXISTS `product_categories`;
CREATE TABLE `product_categories` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `category_id` BIGINT NOT NULL,
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`) ON DELETE CASCADE,
    UNIQUE KEY `unique_product_category` (`product_id`, `category_id`),
    INDEX `idx_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 6. PRODUCT_TAGS TABLE
-- =====================================================
DROP TABLE IF EXISTS `product_tags`;
CREATE TABLE `product_tags` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `tag` VARCHAR(100) NOT NULL,
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE,
    INDEX `idx_tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 7. PRODUCT_IMAGES TABLE
-- =====================================================
DROP TABLE IF EXISTS `product_images`;
CREATE TABLE `product_images` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `image_url` VARCHAR(255) NOT NULL,
    `sort_order` INT DEFAULT 0,
    `is_featured` TINYINT(1) DEFAULT 0,
    `alt_text` VARCHAR(255),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE,
    INDEX `idx_product_id` (`product_id`),
    INDEX `idx_featured` (`is_featured`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 8. ATTRIBUTES TABLE
-- =====================================================
DROP TABLE IF EXISTS `attributes`;
CREATE TABLE `attributes` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `slug` VARCHAR(100) UNIQUE NOT NULL,
    `type` ENUM('select', 'text', 'color', 'image') DEFAULT 'select',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_name` (`name`),
    INDEX `idx_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 9. ATTRIBUTE_VALUES TABLE
-- =====================================================
DROP TABLE IF EXISTS `attribute_values`;
CREATE TABLE `attribute_values` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `attribute_id` BIGINT NOT NULL,
    `value` VARCHAR(255) NOT NULL,
    `label` VARCHAR(255),
    `sort_order` INT DEFAULT 0,
    FOREIGN KEY (`attribute_id`) REFERENCES `attributes`(`id`) ON DELETE CASCADE,
    INDEX `idx_attribute_id` (`attribute_id`),
    INDEX `idx_value` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 10. PRODUCT_VARIATIONS TABLE
-- =====================================================
DROP TABLE IF EXISTS `product_variations`;
CREATE TABLE `product_variations` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `sku` VARCHAR(100) UNIQUE,
    `price` DECIMAL(15,2) NOT NULL,
    `discount_price` DECIMAL(15,2),
    `stock_quantity` INT DEFAULT 0,
    `image_url` VARCHAR(255),
    `attributes_json` JSON,
    `status` ENUM('active', 'inactive') DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE,
    INDEX `idx_product_id` (`product_id`),
    INDEX `idx_sku` (`sku`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 11. WISHLISTS TABLE
-- =====================================================
DROP TABLE IF EXISTS `wishlists`;
CREATE TABLE `wishlists` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `product_id` BIGINT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE,
    UNIQUE KEY `unique_user_product` (`user_id`, `product_id`),
    INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 12. CARTS TABLE
-- =====================================================
DROP TABLE IF EXISTS `carts`;
CREATE TABLE `carts` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT,
    `session_id` VARCHAR(100),
    `product_id` BIGINT NOT NULL,
    `variation_id` BIGINT,
    `quantity` INT NOT NULL DEFAULT 1,
    `price` DECIMAL(15,2) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`variation_id`) REFERENCES `product_variations`(`id`) ON DELETE SET NULL,
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 13. ORDERS TABLE
-- =====================================================
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `order_number` VARCHAR(50) UNIQUE NOT NULL,
    `user_id` BIGINT NOT NULL,
    `billing_address_id` BIGINT,
    `shipping_address_id` BIGINT,
    `subtotal` DECIMAL(15,2) NOT NULL,
    `shipping_cost` DECIMAL(15,2) DEFAULT 0,
    `tax_amount` DECIMAL(15,2) DEFAULT 0,
    `discount_amount` DECIMAL(15,2) DEFAULT 0,
    `total_amount` DECIMAL(15,2) NOT NULL,
    `coupon_code` VARCHAR(100),
    `shipping_method_id` BIGINT,
    `payment_method` VARCHAR(50),
    `payment_status` ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    `payment_transaction_id` VARCHAR(255),
    `payment_date` TIMESTAMP NULL,
    `order_status` ENUM('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled', 'returned') DEFAULT 'pending',
    `tracking_number` VARCHAR(100),
    `admin_notes` TEXT,
    `customer_notes` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT,
    FOREIGN KEY (`billing_address_id`) REFERENCES `user_addresses`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`shipping_address_id`) REFERENCES `user_addresses`(`id`) ON DELETE SET NULL,
    INDEX `idx_order_number` (`order_number`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_status` (`order_status`),
    INDEX `idx_payment_status` (`payment_status`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 14. ORDER_ITEMS TABLE
-- =====================================================
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `order_id` BIGINT NOT NULL,
    `product_id` BIGINT NOT NULL,
    `variation_id` BIGINT,
    `product_name` VARCHAR(255) NOT NULL,
    `sku` VARCHAR(100),
    `quantity` INT NOT NULL,
    `unit_price` DECIMAL(15,2) NOT NULL,
    `total_price` DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE RESTRICT,
    FOREIGN KEY (`variation_id`) REFERENCES `product_variations`(`id`) ON DELETE SET NULL,
    INDEX `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 15. COUPONS TABLE
-- =====================================================
DROP TABLE IF EXISTS `coupons`;
CREATE TABLE `coupons` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `code` VARCHAR(100) UNIQUE NOT NULL,
    `description` TEXT,
    `type` ENUM('percentage', 'fixed') DEFAULT 'percentage',
    `value` DECIMAL(15,2) NOT NULL,
    `min_order_amount` DECIMAL(15,2) DEFAULT 0,
    `max_discount_amount` DECIMAL(15,2),
    `usage_limit` INT,
    `per_customer_limit` INT DEFAULT 1,
    `applicable_to_products` LONGTEXT COMMENT 'JSON array of product IDs',
    `applicable_to_categories` LONGTEXT COMMENT 'JSON array of category IDs',
    `start_date` TIMESTAMP NULL,
    `end_date` TIMESTAMP NULL,
    `used_count` INT DEFAULT 0,
    `status` ENUM('active', 'inactive') DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_code` (`code`),
    INDEX `idx_status` (`status`),
    INDEX `idx_end_date` (`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 16. SHIPPING_METHODS TABLE
-- =====================================================
DROP TABLE IF EXISTS `shipping_methods`;
CREATE TABLE `shipping_methods` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `slug` VARCHAR(100) UNIQUE NOT NULL,
    `description` TEXT,
    `cost_type` ENUM('flat', 'weight', 'amount') DEFAULT 'flat',
    `base_cost` DECIMAL(15,2) DEFAULT 0,
    `cost_per_unit` DECIMAL(15,2),
    `free_shipping_above` DECIMAL(15,2),
    `estimated_days` INT,
    `provinces` LONGTEXT COMMENT 'JSON array of province IDs',
    `sort_order` INT DEFAULT 0,
    `status` ENUM('active', 'inactive') DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 17. PAYMENTS TABLE
-- =====================================================
DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `order_id` BIGINT NOT NULL,
    `user_id` BIGINT NOT NULL,
    `amount` DECIMAL(15,2) NOT NULL,
    `method` VARCHAR(50) NOT NULL,
    `transaction_id` VARCHAR(255) UNIQUE,
    `reference_number` VARCHAR(100),
    `status` ENUM('pending', 'processing', 'completed', 'failed', 'cancelled') DEFAULT 'pending',
    `response_code` VARCHAR(50),
    `response_message` TEXT,
    `payment_date` TIMESTAMP NULL,
    `verified_at` TIMESTAMP NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE RESTRICT,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT,
    INDEX `idx_transaction_id` (`transaction_id`),
    INDEX `idx_order_id` (`order_id`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 18. REVIEWS TABLE
-- =====================================================
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `user_id` BIGINT NOT NULL,
    `order_item_id` BIGINT,
    `rating` INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    `title` VARCHAR(255),
    `comment` TEXT,
    `verified_purchase` TINYINT(1) DEFAULT 0,
    `helpful_count` INT DEFAULT 0,
    `status` ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    `admin_response` TEXT,
    `admin_response_date` TIMESTAMP NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`order_item_id`) REFERENCES `order_items`(`id`) ON DELETE SET NULL,
    INDEX `idx_product_id` (`product_id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_rating` (`rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 19. BLOG_CATEGORIES TABLE
-- =====================================================
DROP TABLE IF EXISTS `blog_categories`;
CREATE TABLE `blog_categories` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(150) NOT NULL,
    `slug` VARCHAR(200) UNIQUE NOT NULL,
    `description` TEXT,
    `sort_order` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 20. BLOG_POSTS TABLE
-- =====================================================
DROP TABLE IF EXISTS `blog_posts`;
CREATE TABLE `blog_posts` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(300) UNIQUE NOT NULL,
    `content` LONGTEXT NOT NULL,
    `excerpt` VARCHAR(500),
    `featured_image` VARCHAR(255),
    `category_id` BIGINT,
    `author_id` BIGINT NOT NULL,
    `view_count` INT DEFAULT 0,
    `status` ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    `published_at` TIMESTAMP NULL,
    `meta_title` VARCHAR(160),
    `meta_description` VARCHAR(160),
    `meta_keywords` VARCHAR(255),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`category_id`) REFERENCES `blog_categories`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`author_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT,
    INDEX `idx_slug` (`slug`),
    INDEX `idx_status` (`status`),
    INDEX `idx_author_id` (`author_id`),
    FULLTEXT INDEX `fti_blog_search` (`title`, `content`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 21. BLOG_TAGS TABLE
-- =====================================================
DROP TABLE IF EXISTS `blog_tags`;
CREATE TABLE `blog_tags` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `post_id` BIGINT NOT NULL,
    `tag` VARCHAR(100) NOT NULL,
    FOREIGN KEY (`post_id`) REFERENCES `blog_posts`(`id`) ON DELETE CASCADE,
    INDEX `idx_tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 22. BLOG_COMMENTS TABLE
-- =====================================================
DROP TABLE IF EXISTS `blog_comments`;
CREATE TABLE `blog_comments` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `post_id` BIGINT NOT NULL,
    `user_id` BIGINT,
    `author_name` VARCHAR(150),
    `author_email` VARCHAR(150),
    `content` TEXT NOT NULL,
    `status` ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`post_id`) REFERENCES `blog_posts`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
    INDEX `idx_post_id` (`post_id`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 23. STORIES TABLE
-- =====================================================
DROP TABLE IF EXISTS `stories`;
CREATE TABLE `stories` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `media_url` VARCHAR(255) NOT NULL,
    `media_type` ENUM('image', 'video') DEFAULT 'image',
    `link` VARCHAR(500),
    `duration` INT DEFAULT 5 COMMENT 'Display duration in seconds',
    `sort_order` INT DEFAULT 0,
    `start_date` TIMESTAMP,
    `end_date` TIMESTAMP,
    `status` ENUM('active', 'inactive') DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_status` (`status`),
    INDEX `idx_start_date` (`start_date`),
    INDEX `idx_end_date` (`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 24. SUPPORT_TICKETS TABLE
-- =====================================================
DROP TABLE IF EXISTS `support_tickets`;
CREATE TABLE `support_tickets` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `ticket_number` VARCHAR(50) UNIQUE NOT NULL,
    `user_id` BIGINT NOT NULL,
    `subject` VARCHAR(255) NOT NULL,
    `category` ENUM('order', 'payment', 'technical', 'suggestion', 'other') DEFAULT 'other',
    `priority` ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    `description` TEXT NOT NULL,
    `status` ENUM('open', 'in_progress', 'closed', 'on_hold') DEFAULT 'open',
    `assigned_to` BIGINT,
    `related_order_id` BIGINT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `closed_at` TIMESTAMP NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT,
    FOREIGN KEY (`assigned_to`) REFERENCES `users`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`related_order_id`) REFERENCES `orders`(`id`) ON DELETE SET NULL,
    INDEX `idx_ticket_number` (`ticket_number`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_priority` (`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 25. TICKET_REPLIES TABLE
-- =====================================================
DROP TABLE IF EXISTS `ticket_replies`;
CREATE TABLE `ticket_replies` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `ticket_id` BIGINT NOT NULL,
    `user_id` BIGINT NOT NULL,
    `message` TEXT NOT NULL,
    `is_staff_reply` TINYINT(1) DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`ticket_id`) REFERENCES `support_tickets`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT,
    INDEX `idx_ticket_id` (`ticket_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 26. PAGES TABLE (CMS)
-- =====================================================
DROP TABLE IF EXISTS `pages`;
CREATE TABLE `pages` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(300) UNIQUE NOT NULL,
    `content` LONGTEXT,
    `status` ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    `meta_title` VARCHAR(160),
    `meta_description` VARCHAR(160),
    `meta_keywords` VARCHAR(255),
    `author_id` BIGINT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`author_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
    INDEX `idx_slug` (`slug`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 27. SETTINGS TABLE
-- =====================================================
DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `setting_key` VARCHAR(100) UNIQUE NOT NULL,
    `setting_value` LONGTEXT,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 28. ACTIVITY_LOG TABLE
-- =====================================================
DROP TABLE IF EXISTS `activity_log`;
CREATE TABLE `activity_log` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT,
    `action` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `entity_type` VARCHAR(50),
    `entity_id` BIGINT,
    `ip_address` VARCHAR(45),
    `user_agent` VARCHAR(255),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_action` (`action`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 29. EMAIL_QUEUE TABLE
-- =====================================================
DROP TABLE IF EXISTS `email_queue`;
CREATE TABLE `email_queue` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `recipient` VARCHAR(255) NOT NULL,
    `subject` VARCHAR(255) NOT NULL,
    `body` LONGTEXT NOT NULL,
    `template` VARCHAR(100),
    `template_data` JSON,
    `status` ENUM('pending', 'sent', 'failed') DEFAULT 'pending',
    `attempts` INT DEFAULT 0,
    `last_attempt` TIMESTAMP NULL,
    `error_message` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `sent_at` TIMESTAMP NULL,
    INDEX `idx_status` (`status`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 30. SMS_QUEUE TABLE
-- =====================================================
DROP TABLE IF EXISTS `sms_queue`;
CREATE TABLE `sms_queue` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `recipient_phone` VARCHAR(20) NOT NULL,
    `message` TEXT NOT NULL,
    `template` VARCHAR(100),
    `status` ENUM('pending', 'sent', 'failed') DEFAULT 'pending',
    `attempts` INT DEFAULT 0,
    `last_attempt` TIMESTAMP NULL,
    `error_message` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `sent_at` TIMESTAMP NULL,
    INDEX `idx_status` (`status`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS=1;
