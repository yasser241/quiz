<?php
/**
 * User Model
 */

namespace App\Models;

use App\Core\Model;
use App\Core\Security;

class User extends Model {
    protected $table = 'users';
    protected $primaryKey = 'id';
    
    protected $fillable = [
        'username', 'email', 'phone', 'password_hash', 'first_name', 'last_name',
        'avatar', 'role', 'status', 'email_verified', 'phone_verified',
        'email_verified_at', 'phone_verified_at', 'last_login', 'last_login_ip',
        'login_attempts', 'locked_until', 'newsletter_subscribed',
        'sms_notifications', 'email_notifications'
    ];
    
    protected $hidden = ['password_hash', 'login_attempts', 'locked_until'];
    
    protected $casts = [
        'id' => 'int',
        'email_verified' => 'bool',
        'phone_verified' => 'bool',
        'newsletter_subscribed' => 'bool',
        'sms_notifications' => 'bool',
        'email_notifications' => 'bool'
    ];

    public function findByEmail($email) {
        return $this->findBy('email', $email);
    }

    public function findByUsername($username) {
        return $this->findBy('username', $username);
    }

    public function findByPhone($phone) {
        return $this->findBy('phone', $phone);
    }

    public function emailExists($email) {
        return $this->findByEmail($email) !== null;
    }

    public function usernameExists($username) {
        return $this->findByUsername($username) !== null;
    }

    public function phoneExists($phone) {
        return $this->findByPhone($phone) !== null;
    }

    public function setPassword($password) {
        return Security::hashPassword($password);
    }

    public function verifyPassword($password, $hash) {
        return Security::verifyPassword($password, $hash);
    }

    public function register($data) {
        if (empty($data['email']) || empty($data['password']) || empty($data['first_name'])) {
            return ['success' => false, 'message' => 'All fields are required'];
        }
        
        if ($this->emailExists($data['email'])) {
            return ['success' => false, 'message' => 'Email already exists'];
        }
        
        if (!Security::validateEmail($data['email'])) {
            return ['success' => false, 'message' => 'Invalid email format'];
        }
        
        if (strlen($data['password']) < 8) {
            return ['success' => false, 'message' => 'Password must be at least 8 characters'];
        }
        
        $userData = [
            'email' => $data['email'],
            'password_hash' => $this->setPassword($data['password']),
            'first_name' => $data['first_name'],
            'last_name' => $data['last_name'] ?? '',
            'username' => $data['email'],
            'phone' => $data['phone'] ?? null,
            'role' => 'customer',
            'status' => 'pending_verification',
            'email_verified' => 0,
            'phone_verified' => 0
        ];
        
        try {
            $user_id = $this->create($userData);
            
            if ($user_id) {
                return [
                    'success' => true,
                    'message' => 'Registration successful',
                    'user_id' => $user_id
                ];
            }
        } catch (\Exception $e) {
            if (DEBUG) {
                return ['success' => false, 'message' => $e->getMessage()];
            }
        }
        
        return ['success' => false, 'message' => 'Registration failed'];
    }

    public function authenticate($email, $password) {
        if (!Security::checkRateLimit('login_' . $email, RATE_LIMIT_LOGIN, RATE_LIMIT_WINDOW)) {
            return [
                'success' => false,
                'message' => 'Too many login attempts. Please try again later.',
                'remaining' => 0
            ];
        }
        
        $user = $this->findByEmail($email);
        
        if (!$user) {
            return [
                'success' => false,
                'message' => 'Invalid email or password',
                'remaining' => Security::getRateLimitRemaining('login_' . $email, RATE_LIMIT_LOGIN, RATE_LIMIT_WINDOW)
            ];
        }
        
        if (!$this->verifyPassword($password, $user['password_hash'])) {
            return [
                'success' => false,
                'message' => 'Invalid email or password',
                'remaining' => Security::getRateLimitRemaining('login_' . $email, RATE_LIMIT_LOGIN, RATE_LIMIT_WINDOW)
            ];
        }
        
        if ($user['status'] === 'banned') {
            return ['success' => false, 'message' => 'Your account has been suspended'];
        }
        
        $this->update($user['id'], [
            'last_login' => date('Y-m-d H:i:s'),
            'last_login_ip' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
            'login_attempts' => 0,
            'locked_until' => null
        ]);
        
        return [
            'success' => true,
            'message' => 'Login successful',
            'user' => $this->hideFields($user)
        ];
    }

    private function hideFields($user) {
        foreach ($this->hidden as $field) {
            unset($user[$field]);
        }
        return $user;
    }
}
