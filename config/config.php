<?php
/**
 * Configuration File
 * All environment variables and base configuration
 */

// Load environment variables
require_once __DIR__ . '/environment.php';

// Database Configuration
define('DB_HOST', getenv('DB_HOST', true) ?: 'localhost');
define('DB_PORT', getenv('DB_PORT', true) ?: 3306);
define('DB_NAME', getenv('DB_NAME', true) ?: 'quiz_shop');
define('DB_USER', getenv('DB_USER', true) ?: 'root');
define('DB_PASSWORD', getenv('DB_PASSWORD', true) ?: '');
define('DB_CHARSET', 'utf8mb4');

// Site Configuration
define('SITE_NAME', getenv('SITE_NAME', true) ?: 'فروشگاه آنلاین');
define('SITE_URL', rtrim(getenv('SITE_URL', true) ?: 'http://localhost', '/'));
define('SITE_ADMIN_EMAIL', getenv('SITE_ADMIN_EMAIL', true) ?: 'admin@example.com');

// Security
define('SECURE_KEY', getenv('SECURE_KEY', true) ?: 'default_insecure_key_change_this');
define('JWT_SECRET', getenv('JWT_SECRET', true) ?: 'default_jwt_secret');
define('CSRF_TOKEN_LIFETIME', 3600); // 1 hour
define('CSRF_TOKEN_NAME', '_csrf_token');

// Session Configuration
define('SESSION_TIMEOUT', getenv('SESSION_TIMEOUT', true) ?: 3600);
define('SESSION_PATH', getenv('SESSION_PATH', true) ?: sys_get_temp_dir());
define('SESSION_NAME', 'QUIZ_SHOP_SESSION');

// Environment
define('APP_ENV', getenv('APP_ENV', true) ?: 'development');
define('DEBUG', filter_var(getenv('DEBUG', true) ?: false, FILTER_VALIDATE_BOOLEAN));

// File Upload
define('UPLOAD_DIR', realpath(__DIR__ . '/../public/uploads/'));
define('MAX_UPLOAD_SIZE', (int)(getenv('MAX_UPLOAD_SIZE', true) ?: 5242880)); // 5MB
define('ALLOWED_UPLOAD_TYPES', array_filter(explode(',', getenv('ALLOWED_UPLOAD_TYPES', true) ?: 'jpg,jpeg,png,gif')));

// Rate Limiting
define('RATE_LIMIT_LOGIN', (int)(getenv('RATE_LIMIT_LOGIN', true) ?: 5));
define('RATE_LIMIT_REGISTER', (int)(getenv('RATE_LIMIT_REGISTER', true) ?: 3));
define('RATE_LIMIT_CONTACT', (int)(getenv('RATE_LIMIT_CONTACT', true) ?: 2));
define('RATE_LIMIT_WINDOW', 3600); // 1 hour

// Payment Gateway
define('PAYMENT_GATEWAY', getenv('PAYMENT_GATEWAY', true) ?: 'zarinpal');
define('PAYMENT_MERCHANT_ID', getenv('PAYMENT_MERCHANT_ID', true) ?: '');

// Email Configuration
define('SMTP_HOST', getenv('SMTP_HOST', true) ?: 'smtp.gmail.com');
define('SMTP_PORT', (int)(getenv('SMTP_PORT', true) ?: 587));
define('SMTP_USER', getenv('SMTP_USER', true) ?: '');
define('SMTP_PASSWORD', getenv('SMTP_PASSWORD', true) ?: '');
define('SMTP_FROM_EMAIL', getenv('SMTP_FROM_EMAIL', true) ?: 'noreply@quiz-shop.com');
define('SMTP_FROM_NAME', getenv('SMTP_FROM_NAME', true) ?: 'فروشگاه آنلاین');

// SMS Configuration
define('SMS_PROVIDER', getenv('SMS_PROVIDER', true) ?: 'kavenegar');
define('SMS_API_KEY', getenv('SMS_API_KEY', true) ?: '');

// Pagination
define('ITEMS_PER_PAGE', 20);
define('ADMIN_ITEMS_PER_PAGE', 25);

// Path Constants
define('ROOT_PATH', realpath(__DIR__ . '/../'));
define('PUBLIC_PATH', ROOT_PATH . '/public');
define('APP_PATH', ROOT_PATH . '/src');
define('CONTROLLER_PATH', APP_PATH . '/Controllers');
define('MODEL_PATH', APP_PATH . '/Models');
define('VIEW_PATH', APP_PATH . '/Views');
define('CONFIG_PATH', __DIR__);

// Error Handler
if (DEBUG) {
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
} else {
    error_reporting(E_ALL);
    ini_set('display_errors', 0);
    ini_set('log_errors', 1);
}

// Set Timezone
date_default_timezone_set('Asia/Tehran');

// Charset
header('Content-Type: text/html; charset=utf-8');
