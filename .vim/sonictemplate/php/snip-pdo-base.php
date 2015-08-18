$dsn = 'mysql:dbname=uriage;host=localhost';
$user = 'testuser';
$password = 'testuser';
$attrs = array(
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::MYSQL_ATTR_INIT_COMMAND => "SET CHARACTER SET `utf8`",
);

try{
    $dbh = new PDO($dsn, $user, $password, $attrs);
    // $dbh->query("SET NAMES 'utf8'");
} catch (PDOException $e){
    die("Error : " . $e->getMessage());
}

try {
    $sql = 'select * from user where id = :id';
    $stmt = $dbh->prepare($sql);
    $stmt->execute(array(
        ":id" => 1,
    ));

    while ($r = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo $r["id"];
    }
    $stmt->closeCursor();
} catch (PDOException $e) {
    die("Error : " . $e->getMessage());
}

