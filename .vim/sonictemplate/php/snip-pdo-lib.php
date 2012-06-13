class DBHandler {
	var $dbh;

	function __construct($dsn, $user = null, $password = null, $attrs = array()) {
		$this->dbh = new PDO($dsn, $user, $password, $attrs);
	}

	function find($sql, $params = array()) {
		$stmt = $this->dbh->prepare($sql);
		if ($stmt->execute($params) === false) {
			return false;
		}
		$rows = array();

		while ($r = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$rows[] = $r;
		}
		$stmt->closeCursor();
		return $rowd;
	}

	function findFirst($sql, $params = array()) {
		$stmt = $this->dbh->prepare($sql);
		if ($stmt->execute($params) === false) {
			return false;
		}
		$r = $stmt->fetch(PDO::FETCH_ASSOC);
		$stmt->closeCursor();
		return $r;
	}

	function exec($sql, $params = array()) {
		$stmt = $this->dbh->prepare($sql);
		if ($stmt->execute($params) === false) {
			return false;
		}
		$count = $stmt->rowCount();
		$stmt->closeCursor();
		return $count;
	}
}
