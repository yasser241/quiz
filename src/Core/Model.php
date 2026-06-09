<?php
/**
 * Core Database Model Class
 * Base class for all models
 */

namespace App\Core;

use PDO;
use PDOException;

class Model {
    protected $db;
    protected $table;
    protected $primaryKey = 'id';
    protected $fillable = [];
    protected $hidden = [];
    protected $casts = [];

    public function __construct() {
        $this->db = \Config\Database::connect();
    }

    /**
     * Find a record by ID
     */
    public function find($id) {
        try {
            $query = "SELECT * FROM {$this->table} WHERE {$this->primaryKey} = :id LIMIT 1";
            $stmt = $this->db->prepare($query);
            $stmt->execute([':id' => $id]);
            
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            return $result ? $this->castData($result) : null;
        } catch (PDOException $e) {
            if (DEBUG) {
                throw new \Exception('Database Error: ' . $e->getMessage());
            }
            return null;
        }
    }

    /**
     * Find by custom column
     */
    public function findBy($column, $value, $multiple = false) {
        try {
            $query = "SELECT * FROM {$this->table} WHERE {$column} = :value";
            if (!$multiple) {
                $query .= " LIMIT 1";
            }
            
            $stmt = $this->db->prepare($query);
            $stmt->execute([':value' => $value]);
            
            if ($multiple) {
                $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
                return array_map([$this, 'castData'], $results);
            } else {
                $result = $stmt->fetch(PDO::FETCH_ASSOC);
                return $result ? $this->castData($result) : null;
            }
        } catch (PDOException $e) {
            if (DEBUG) {
                throw new \Exception('Database Error: ' . $e->getMessage());
            }
            return $multiple ? [] : null;
        }
    }

    /**
     * Get all records
     */
    public function all($limit = null, $offset = 0) {
        try {
            $query = "SELECT * FROM {$this->table}";
            if ($limit) {
                $query .= " LIMIT :limit OFFSET :offset";
            }
            
            $stmt = $this->db->prepare($query);
            if ($limit) {
                $stmt->bindValue(':limit', (int)$limit, PDO::PARAM_INT);
                $stmt->bindValue(':offset', (int)$offset, PDO::PARAM_INT);
            }
            $stmt->execute();
            
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            return array_map([$this, 'castData'], $results);
        } catch (PDOException $e) {
            if (DEBUG) {
                throw new \Exception('Database Error: ' . $e->getMessage());
            }
            return [];
        }
    }

    /**
     * Create a new record
     */
    public function create($data) {
        try {
            $data = array_intersect_key($data, array_flip($this->fillable));
            
            if (empty($data)) {
                throw new \Exception('No valid data to insert');
            }
            
            $columns = array_keys($data);
            $placeholders = array_map(fn($col) => ':' . $col, $columns);
            
            $query = "INSERT INTO {$this->table} (" . implode(',', $columns) . ") ";
            $query .= "VALUES (" . implode(',', $placeholders) . ")";
            
            $stmt = $this->db->prepare($query);
            
            foreach ($data as $key => $value) {
                $stmt->bindValue(':' . $key, $value);
            }
            
            $stmt->execute();
            
            return $this->db->lastInsertId();
        } catch (PDOException $e) {
            if (DEBUG) {
                throw new \Exception('Database Error: ' . $e->getMessage());
            }
            return false;
        }
    }

    /**
     * Update a record
     */
    public function update($id, $data) {
        try {
            $data = array_intersect_key($data, array_flip($this->fillable));
            
            if (empty($data)) {
                throw new \Exception('No valid data to update');
            }
            
            $columns = array_keys($data);
            $updates = array_map(fn($col) => $col . ' = :' . $col, $columns);
            
            $query = "UPDATE {$this->table} SET " . implode(',', $updates);
            $query .= " WHERE {$this->primaryKey} = :id";
            
            $stmt = $this->db->prepare($query);
            $stmt->bindValue(':id', $id);
            
            foreach ($data as $key => $value) {
                $stmt->bindValue(':' . $key, $value);
            }
            
            $stmt->execute();
            
            return $stmt->rowCount();
        } catch (PDOException $e) {
            if (DEBUG) {
                throw new \Exception('Database Error: ' . $e->getMessage());
            }
            return false;
        }
    }

    /**
     * Delete a record
     */
    public function delete($id) {
        try {
            $query = "DELETE FROM {$this->table} WHERE {$this->primaryKey} = :id";
            $stmt = $this->db->prepare($query);
            $stmt->execute([':id' => $id]);
            
            return $stmt->rowCount();
        } catch (PDOException $e) {
            if (DEBUG) {
                throw new \Exception('Database Error: ' . $e->getMessage());
            }
            return false;
        }
    }

    /**
     * Cast data based on defined casts
     */
    protected function castData($data) {
        foreach ($this->casts as $column => $type) {
            if (isset($data[$column])) {
                switch ($type) {
                    case 'int':
                        $data[$column] = (int)$data[$column];
                        break;
                    case 'float':
                        $data[$column] = (float)$data[$column];
                        break;
                    case 'bool':
                        $data[$column] = (bool)$data[$column];
                        break;
                }
            }
        }
        return $data;
    }
}
