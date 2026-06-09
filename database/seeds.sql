-- =====================================================
-- Sample Data for Quiz Shop
-- =====================================================

-- Admin User (Password: admin123 - bcrypt hash)
INSERT INTO `users` (
    `username`, `email`, `phone`, `password_hash`, `first_name`, `last_name`,
    `role`, `status`, `email_verified`, `phone_verified`, `email_verified_at`, `phone_verified_at`
) VALUES (
    'admin', 'admin@example.com', '09121234567',
    '$2y$10$S9G8c6q7YqH5vz3p2m1n0OqK8L7M6N5O4P3Q2R1S0T9U8V7W6X5Y4Z3',
    'مدیر', 'سیستم',
    'admin', 'active', 1, 1, NOW(), NOW()
);

-- Customer User (Password: customer123)
INSERT INTO `users` (
    `username`, `email`, `phone`, `password_hash`, `first_name`, `last_name`,
    `role`, `status`, `email_verified`, `phone_verified`, `email_verified_at`, `phone_verified_at`
) VALUES (
    'customer1', 'customer@example.com', '09121234568',
    '$2y$10$S9G8c6q7YqH5vz3p2m1n0OqK8L7M6N5O4P3Q2R1S0T9U8V7W6X5Y4Z3',
    'علی', 'محمدی',
    'customer', 'active', 1, 1, NOW(), NOW()
);

-- Support Staff (Password: support123)
INSERT INTO `users` (
    `username`, `email`, `phone`, `password_hash`, `first_name`, `last_name`,
    `role`, `status`, `email_verified`, `phone_verified`, `email_verified_at`, `phone_verified_at`
) VALUES (
    'support', 'support@example.com', '09121234569',
    '$2y$10$S9G8c6q7YqH5vz3p2m1n0OqK8L7M6N5O4P3Q2R1S0T9U8V7W6X5Y4Z3',
    'پشتیبان', 'فروشگاه',
    'support', 'active', 1, 1, NOW(), NOW()
);

-- Sample Categories
INSERT INTO `categories` (`name`, `slug`, `description`, `show_in_menu`, `sort_order`, `status`) VALUES
('الکترونیک', 'electronics', 'محصولات الکترونیکی', 1, 1, 'active'),
('پوشاک', 'clothing', 'پوشاک و لباس', 1, 2, 'active'),
('کتاب', 'books', 'کتاب های مختلف', 1, 3, 'active'),
('مبلمان', 'furniture', 'مبلمان و دکوراسیون', 1, 4, 'active'),
('سلامت و زیبایی', 'health-beauty', 'محصولات سلامت و زیبایی', 1, 5, 'active');

-- Sample Attributes
INSERT INTO `attributes` (`name`, `slug`, `type`) VALUES
('رنگ', 'color', 'color'),
('سایز', 'size', 'select'),
('برند', 'brand', 'select'),
('جنس', 'material', 'select');

-- Sample Attribute Values
INSERT INTO `attribute_values` (`attribute_id`, `value`, `label`, `sort_order`) VALUES
(1, 'red', 'قرمز', 1),
(1, 'blue', 'آبی', 2),
(1, 'black', 'سیاه', 3),
(2, 's', 'کوچک', 1),
(2, 'm', 'متوسط', 2),
(2, 'l', 'بزرگ', 3),
(3, 'samsung', 'سامسونگ', 1),
(3, 'lg', 'ال جی', 2),
(4, 'cotton', 'پنبه', 1),
(4, 'polyester', 'پلی استر', 2);

-- Sample Shipping Methods
INSERT INTO `shipping_methods` (`name`, `slug`, `description`, `cost_type`, `base_cost`, `estimated_days`, `sort_order`, `status`) VALUES
('پیک فوری', 'express', 'ارسال در سایز 24 ساعت', 'flat', 50000, 1, 1, 'active'),
('پست پیشتاز', 'standard', 'ارسال عادی توسط پست', 'flat', 25000, 5, 2, 'active'),
('تحویل فروشگاهی', 'pickup', 'تحویل در فروشگاه', 'flat', 0, 0, 3, 'active');

-- Sample Products
INSERT INTO `products` (
    `sku`, `name`, `slug`, `short_description`, `description`, `price`, `cost_price`,
    `discount_price`, `discount_percentage`, `type`, `manage_stock`, `stock_quantity`,
    `low_stock_threshold`, `featured`, `status`, `rating`, `rating_count`
) VALUES
('SKU-001', 'گوشی هوشمند سامسونگ', 'samsung-smartphone',
    'گوشی هوشمند با صفحه AMOLED',
    '<p>گوشی هوشمند سامسونگ با صفحه AMOLED و دوربین 64 مگاپیکسل</p>',
    5000000, 3500000, 4200000, 16, 'simple', 1, 50, 5, 1, 'published', 4.5, 120),

('SKU-002', 'لپ تاپ ایسوس', 'asus-laptop',
    'لپ تاپ با پردازنده i7',
    '<p>لپ تاپ ایسوس با پردازنده i7 و رم 16 گیگابایت</p>',
    15000000, 10000000, 13500000, 10, 'simple', 1, 20, 3, 1, 'published', 4.2, 85),

('SKU-003', 'تی شرت مردانه', 'mens-tshirt',
    'تی شرت پنبه ای مردانه',
    '<p>تی شرت با کیفیت بالا از پنبه 100%</p>',
    150000, 80000, 120000, 20, 'variable', 1, 100, 10, 0, 'published', 4.0, 45),

('SKU-004', 'صندلی اداری', 'office-chair',
    'صندلی با طراحی ارگونومیک',
    '<p>صندلی اداری با پشتی بلند و تنظیمات متعدد</p>',
    2500000, 1500000, null, null, 'simple', 1, 15, 3, 0, 'published', 3.8, 32),

('SKU-005', 'کتاب شهرهای کاغذی', 'paper-towns-book',
    'رمان فانتزی محبوب',
    '<p>کتاب معروف جان گرین با ترجمه فارسی</p>',
    180000, 100000, null, null, 'simple', 1, 200, 20, 1, 'published', 4.6, 215);

-- Link Products to Categories
INSERT INTO `product_categories` (`product_id`, `category_id`) VALUES
(1, 1), -- گوشی به الکترونیک
(2, 1), -- لپ تاپ به الکترونیک
(3, 2), -- تی شرت به پوشاک
(4, 4), -- صندلی به مبلمان
(5, 3); -- کتاب به کتاب

-- Sample Blog Categories
INSERT INTO `blog_categories` (`name`, `slug`, `description`, `sort_order`) VALUES
('نکات مفید', 'tips', 'نکات و راهنمایی های مفید', 1),
('اخبار', 'news', 'اخبار و آپدیت', 2),
('بررسی محصولات', 'reviews', 'بررسی محصولات جدید', 3);

-- Sample Blog Post
INSERT INTO `blog_posts` (
    `title`, `slug`, `content`, `excerpt`, `category_id`, `author_id`,
    `status`, `published_at`
) VALUES
('چگونه گوشی هوشمند خود را محافظت کنید', 'protect-your-smartphone',
    '<p>گوشی هوشمند یک دارایی ارزشمند است و نیاز به محافظت دارد...</p>',
    'نکات مفید برای محافظت از گوشی هوشمند شما',
    1, 1, 'published', NOW());

-- Sample Stories
INSERT INTO `stories` (`title`, `media_url`, `media_type`, `link`, `duration`, `sort_order`, `start_date`, `end_date`, `status`) VALUES
('تخفیف 50% برای گوشی‌ها', '/img/stories/phones-discount.jpg', 'image', '/shop?category=electronics', 5, 1, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 'active'),
('کالکشن نوی پوشاک', '/img/stories/new-collection.jpg', 'image', '/shop?category=clothing', 5, 2, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 'active');

-- Sample Settings
INSERT INTO `settings` (`setting_key`, `setting_value`) VALUES
('site_name', 'فروشگاه آنلاین'),
('site_description', 'فروشگاه اینترنتی با بهترین محصولات'),
('company_phone', '02612345678'),
('company_email', 'info@example.com'),
('company_address', 'تهران، خیابان کاوه، شماره 123'),
('currency', 'تومان'),
('allow_comments', '1'),
('require_comment_approval', '1'),
('posts_per_page', '10'),
('products_per_page', '20');
