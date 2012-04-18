function array_empty($mixed) {
	if (is_array($mixed)) {
		foreach ($mixed as $value) {
			if (!array_empty($value)) {
				return false;
			}
		}
	} else {
		$mixed = trim($mixed);
		if (!empty($mixed)) {
			return false;
		}
	}
	return true;
}

