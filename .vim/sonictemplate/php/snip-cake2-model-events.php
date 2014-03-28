	public function beforeFind($query) {
		return true;
	}

	public function afterFind($results, $primary = false) {
		return $results;
	}

	public function beforeSave($options = array()) {
		return true;
	}

	public function afterSave($created, $options = array()) { }

	public function beforeDelete($cascade = true) {
		return true;
	}

	public function afterDelete() { }

	public function beforeValidate($options = array()) {
		return true;
	}

	public function afterValidate() { }

	public function onError() { }
