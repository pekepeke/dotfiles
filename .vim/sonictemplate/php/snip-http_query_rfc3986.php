function http_build_query_rfc_3986($query_data,$arg_separator='&') {
	$r = '';
	$query_data = (array) $query_data;
	if(!empty($query_data)) {
		foreach($query_data as $k=>$query_var) {
			$r .= $arg_separator;
			$r .= $k;
			$r .= '=';
			$r .= rawurlencode($query_var);
		}
	}
	return trim($r,$arg_separator);
}

