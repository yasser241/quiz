<?php
/**
 * Security Helper Class
 * Handles encryption, hashing, and security utilities
 */

namespace App\Core;

class Security {
    /**
     * Hash a password using bcrypt
     */
    public static function hashPassword($password) {
        return password_hash($password, PASSWORD_BCRYPT, [
            'cost' => 12
        ]);
    }

    /**
     * Verify password against hash
     */
    public static function verifyPassword($password, $hash) {
        return password_verify($password, $hash);
    }

    /**
     * Generate CSRF token
     */
    public static function generateCSRFToken() {
        if (!isset($_SESSION[CSRF_TOKEN_NAME])) {
            $_SESSION[CSRF_TOKEN_NAME] = bin2hex(random_bytes(32));
        }
        return $_SESSION[CSRF_TOKEN_NAME];
    }

    /**
     * Verify CSRF token
     */
    public static function verifyCSRFToken($token) {
        return isset($_SESSION[CSRF_TOKEN_NAME]) && 
               hash_equals($_SESSION[CSRF_TOKEN_NAME], $token);
    }

    /**
     * Sanitize input
     */
    public static function sanitize($data, $type = 'string') {
        switch ($type) {
            case 'email':
                return filter_var($data, FILTER_SANITIZE_EMAIL);
            case 'url':
                return filter_var($data, FILTER_SANITIZE_URL);
            case 'int':
                return filter_var($data, FILTER_SANITIZE_NUMBER_INT);
            case 'float':
                return filter_var($data, FILTER_SANITIZE_NUMBER_FLOAT);
            case 'string':
            default:
                return htmlspecialchars(trim($data), ENT_QUOTES, 'UTF-8');
        }
    }

    /**
     * Escape output for HTML
     */
    public static function escape($data) {
        return htmlspecialchars($data, ENT_QUOTES, 'UTF-8');
    }

    /**
     * Generate secure random token
     */
    public static function generateToken($length = 32) {
        return bin2hex(random_bytes($length / 2));
    }

    /**
     * Hash data using HMAC
     */
    public static function hash($data, $algo = 'sha256') {
        return hash_hmac($algo, $data, SECURE_KEY);
    }

    /**
     * Validate email format
     */
    public static function validateEmail($email) {
        return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
    }

    /**
     * Validate phone format
     */
    public static function validatePhone($phone) {
        $phone = preg_replace('/[^0-9]/', '', $phone);
        return (strlen($phone) >= 10 && strlen($phone) <= 15);
    }

    /**
     * Validate URL format
     */
    public static function validateUrl($url) {
        return filter_var($url, FILTER_VALIDATE_URL) !== false;
    }

    /**
     * Rate limit check
     */
    public static function checkRateLimit($identifier, $limit, $window = 3600) {
        $key = 'rate_limit_' . md5($identifier);
        
        if (!isset($_SESSION[$key])) {
            $_SESSION[$key] = [
                'attempts' => 0,
                'first_attempt' => time(),
                'locked_until' => null
            ];
        }
        
        $attempt = &$_SESSION[$key];
        
        if ($attempt['locked_until'] !== null && time() < $attempt['locked_until']) {
            return false;
        }
        
        if (time() - $attempt['first_attempt'] > $window) {
            $attempt['attempts'] = 0;
            $attempt['first_attempt'] = time();
            $attempt['locked_until'] = null;
        }
        
        $attempt['attempts']++;
        
        if ($attempt['attempts'] > $limit) {
            $attempt['locked_until'] = time() + $window;
            return false;
        }
        
        return true;
    }

    /**
     * Get remaining rate limit attempts
     */
    public static function getRateLimitRemaining($identifier, $limit, $window = 3600) {
        $key = 'rate_limit_' . md5($identifier);
        
        if (!isset($_SESSION[$key])) {
            return $limit;
        }
        
        $attempt = $_SESSION[$key];
        
        if (time() - $attempt['first_attempt'] > $window) {
            return $limit;
        }
        
        return max(0, $limit - $attempt['attempts']);
    }
}
