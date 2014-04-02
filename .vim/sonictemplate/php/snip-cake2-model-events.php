	public function beforeFind($query) {
		return true;
	}

	public function afterFind($results, $primary = false) {
		return $results;
	}

	public function beforeSave($options = array()) {
		if (!$this->id && empty($this->data[$this->alias][$this->primaryKey])) {
			// insert
		} else {
			// edit
		}
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
