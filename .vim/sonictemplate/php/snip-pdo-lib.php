<?php
// DBFactory::set(array(
//     "dsn" => 'mysql:dbname=test;host=127.0.0.1',
//     "user" => 'root',
//     "password" => 'root',
//     "attr" => array(
//         PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
//         PDO::MYSQL_ATTR_INIT_COMMAND => "SET CHARACTER SET `utf8`",
//     )
// ));

class DBFactory
{
    static $options = array();
    static $defaultValues = array(
        "attr" => array(),
    );

    public static function set($options, $name = "default")
    {
        self::$options[$name] = $options;
    }

    public static function connect($name = "default")
    {
        $options = self::$options[$name];
        return new DBHandler(
            self::get("dsn"),
            self::get("user"),
            self::get("password"),
            self::get("attr")
        );
    }

    public static function get($key = null, $name = "default")
    {
        if (is_null($key)) {
            return self::$options[$name];
        }
        if (isset(self::$options[$name][$key])) {
            return self::$options[$name][$key];
        }
        if (isset(self::$defaultValues[$key])) {
            return self::$defaultValues[$key];
        }
        return null;
    }
}

class DBHandler_RuntimeException extends RuntimeException
{
    public $lastQuery = null;
    public $lastQueryParams = null;
    public function setLastQuery($sql, $params)
    {
        $this->lastQuery = $sql;
        $this->lastQueryParams = $params;
        if (!is_null($this->lastQuery)) {
            $s = sprintf("[LAST QUERY] = %s, [WITH] = %s", $this->lastQuery, var_export($this->lastQueryParams, true));
            $s = preg_replace('/\s+/', ' ', str_replace(array("\r\n", "\n", "\r"), " ", $s));
            $this->message = $this->message . ", " . $s;
        }
    }

    static function handle($e, $sql = null, $params = array())
    {
        // $ex = new DBHandler_RuntimeException($e->getMessage(), (int)$e->getCode(), $e);
        $ex = new DBHandler_RuntimeException($e->getMessage(), (int)$e->getCode());
        if (!is_null($sql)) {
            $ex->setLastQuery($sql, $params);
        }
        throw $ex;
    }
}

class DBHandler
{
    public $dbh;

    public function __construct($dsn, $user = null, $password = null, $attr = array())
    {
        try {
            $this->dbh = new PDO($dsn, $user, $password, $attr);
            $this->dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            DBHandler_RuntimeException::handle($e);
        }
    }

    public function find($sql, $params = array())
    {
        try {
            $stmt = $this->dbh->prepare($sql);
            if ($stmt->execute($params) === false) {
                return false;
            }
            $rows = array();

            while ($r = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $rows[] = $r;
            }
            $stmt->closeCursor();
        } catch (PDOException $e) {
            DBHandler_RuntimeException::handle($e, $sql, $params);
        }
        return $rows;
    }

    public function all($sql, $params = array())
    {
        return $this->find($sql, $params);
    }

    public function first($sql, $params = array())
    {
        try {
            $stmt = $this->dbh->prepare($sql);
            if ($stmt->execute($params) === false) {
                return false;
            }
            $r = $stmt->fetch(PDO::FETCH_ASSOC);

            $stmt->closeCursor();
        } catch (PDOException $e) {
            DBHandler_RuntimeException::handle($e, $sql, $params);
        }
        return $r;
    }

    public function exec($sql, $params = array())
    {
        try {
            $stmt = $this->dbh->prepare($sql);
            if ($stmt->execute($params) === false) {
                return false;
            }
            $count = $stmt->rowCount();
            $stmt->closeCursor();
        } catch (PDOException $e) {
            DBHandler_RuntimeException::handle($e, $sql, $params);
        }
        return $count;
    }
}
