<?php
/**
 * Authentication Controller
 */

namespace App\Controllers;

use App\Core\Security;
use App\Models\User;

class AuthController {
    private $userModel;

    public function __construct() {
        $this->userModel = new User();
    }

    public function showLogin() {
        if (isset($_SESSION['user_id'])) {
            header('Location: ' . SITE_URL . '/dashboard');
            exit;
        }
        
        return $this->render('auth/login');
    }

    public function login() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            http_response_code(405);
            return ['error' => 'Method not allowed'];
        }
        
        if (!isset($_POST[CSRF_TOKEN_NAME]) || !Security::verifyCSRFToken($_POST[CSRF_TOKEN_NAME])) {
            return ['success' => false, 'message' => 'Invalid request'];
        }
        
        $email = Security::sanitize($_POST['email'] ?? '', 'email');
        $password = $_POST['password'] ?? '';
        
        if (empty($email) || empty($password)) {
            return ['success' => false, 'message' => 'Email and password are required'];
        }
        
        $result = $this->userModel->authenticate($email, $password);
        
        if ($result['success']) {
            $_SESSION['user_id'] = $result['user']['id'];
            $_SESSION['user_role'] = $result['user']['role'];
            $_SESSION['user_email'] = $result['user']['email'];
            
            return [
                'success' => true,
                'message' => 'Login successful',
                'redirect' => SITE_URL . '/dashboard'
            ];
        }
        
        return $result;
    }

    public function showRegister() {
        if (isset($_SESSION['user_id'])) {
            header('Location: ' . SITE_URL . '/dashboard');
            exit;
        }
        
        return $this->render('auth/register');
    }

    public function register() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            http_response_code(405);
            return ['error' => 'Method not allowed'];
        }
        
        if (!Security::checkRateLimit('register', RATE_LIMIT_REGISTER, RATE_LIMIT_WINDOW)) {
            return [
                'success' => false,
                'message' => 'Too many registration attempts. Please try again later.'
            ];
        }
        
        if (!isset($_POST[CSRF_TOKEN_NAME]) || !Security::verifyCSRFToken($_POST[CSRF_TOKEN_NAME])) {
            return ['success' => false, 'message' => 'Invalid request'];
        }
        
        $data = [
            'email' => Security::sanitize($_POST['email'] ?? '', 'email'),
            'password' => $_POST['password'] ?? '',
            'password_confirm' => $_POST['password_confirm'] ?? '',
            'first_name' => Security::sanitize($_POST['first_name'] ?? ''),
            'last_name' => Security::sanitize($_POST['last_name'] ?? ''),
            'phone' => Security::sanitize($_POST['phone'] ?? '')
        ];
        
        if ($data['password'] !== $data['password_confirm']) {
            return ['success' => false, 'message' => 'Passwords do not match'];
        }
        
        $result = $this->userModel->register($data);
        
        if ($result['success']) {
            return [
                'success' => true,
                'message' => 'Registration successful. Please verify your email.',
                'redirect' => SITE_URL . '/login'
            ];
        }
        
        return $result;
    }

    public function logout() {
        $_SESSION = [];
        session_destroy();
        
        header('Location: ' . SITE_URL);
        exit;
    }

    private function render($view) {
        $viewPath = VIEW_PATH . '/' . $view . '.php';
        
        if (!file_exists($viewPath)) {
            http_response_code(404);
            return ['error' => 'View not found'];
        }
        
        ob_start();
        include $viewPath;
        return ob_get_clean();
    }
}
