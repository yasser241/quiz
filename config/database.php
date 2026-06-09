<?php
/**
 * Database Connection Configuration
 */

namespace Config;

class Database {
    private static $connection = null;

    /**
     * Get or create database connection
     */
    public static function connect() {
        if (self::$connection !== null) {
            return self::$connection;
        }

        try {
            $dsn = 'mysql:host=' . DB_HOST . ':' . DB_PORT . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET;
            
            $options = [
                \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,
                \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC,
                \PDO::ATTR_EMULATE_PREPARES => false,
            ];
            
            self::$connection = new \PDO($dsn, DB_USER, DB_PASSWORD, $options);
            
            // Set timezone for MySQL
            self::$connection->exec("SET SESSION sql_mode='STRICT_TRANS_TABLES'");
            self::$connection->exec("SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci");
            
            return self::$connection;
        } catch (\PDOException $e) {
            if (DEBUG) {
                die('Database Connection Error: ' . $e->getMessage());
            } else {
                die('Database connection failed. Please try again later.');
            }
        }
    }

    /**
     * Close connection
     */
    public static function disconnect() {
        self::$connection = null;
    }
}
