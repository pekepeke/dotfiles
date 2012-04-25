function e($str){
    if(is_array($str)){
        return array_map( "e" , $str );
    }else{
        return mysql_real_escape_string( $str );
    }
}
// 住所から緯度経度に変換
// $xml = address2gps( "東京都千代田区" ); 
// var_dump( $xml );
function address2gps( $address ){
    $APIKEY  = "Google API KEY";
    $url = "http://maps.google.co.jp/maps/geo?key={$APIKEY}&q={$address}&output=xml&ie=UTF-8";
    $file = file_get_contents( $url );
    return $file;
}

// URLやメールアドレスの自動リンク
function convert_link( $val ){
    //タグの除去
    $val = strip_tags( $val );

    //自動リンク
    // $val = mbereg_replace("(https?|ftp|news)"."(://[[:alnum:]¥+¥$¥;¥?¥.%,!#‾*/:@&=_-]+)","[<A href=¥"¥¥1¥¥2¥" target=¥"_blank¥">URL</A>]", $val);
    // $val = mbereg_replace("([0-9A-Za-z¥.¥/¥‾¥-¥+¥:¥;¥?¥=¥&¥%¥#¥_]+@[-0-9A-Za-z¥.¥/¥‾¥-¥+¥:¥;¥?¥=¥&¥%¥#¥_]+)","[<A href=¥"mailto:¥¥1¥">MAIL</A>]", $val);
	$val = preg_replace('/(https?|ftp|news)(:\/\/[[:alnum:]\+\$\;\?\.%,!#~*/:@&=_\-]+)/', '<a href="\1\2" target="_blank">\1\2</a>');
	$val = preg_replace('/([[:alnum:]\.\/\~\-\+\:\;\?\=\&\%\#\_]+@[[:alnum:]\-\.\/\~\-\+\:\;\?\=\&\%\#\_]+)/', '<a href="mailto:\1">\1</a>');

    //改行をbrタグに変換
    $val = nl2br( $val );
    return $val;
}

function is_win() {
	return strtoupper(substr(PHP_OS, 0, 3)) === "WIN";
}

function load_extension($extension) {
	if (extension_loaded($extension)) {
		return true;
	}

	if (defined('PHP_SHLIB_SUFFIX')) {
		$suffix = PHP_SHLIB_SUFFIX;
	} else if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
		$suffix = 'dll';
	} else {
		$suffix = 'so';
	}

	$prefix = $suffix === 'dll' ? 'php_' : '';
	$libraries = array("{$prefix}{$extension}.{$suffix}");
	$libraries[] = "{$extension}.so";
	$libraries[] = "php_{$extension}.dll";
	$libraries = array_unique($libraries);

	foreach ($libraries as $library) {
		if (@dl($library)) {
			return true;
		}
	}

	return false;
}

function pid_exists($pid) {
	if (load_extension('posix')) {
		return posix_kill($pid, 0);
	} else if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
		return intval(exec(sprintf(
			'tasklist /nh /fi "PID eq %s" 2>nul | find /C "%s"',
			$pid, $pid)));
	} else {
		return intval(exec("ps -e|grep '^ *{$pid} '"));
	}
}

function path_join() {
	return implode(func_get_args(), DIRECTORY_SEPARATOR);
}

function tmp_dir() {
	if (function_exists('sys_get_temp_dir')) {
		return sys_get_temp_dir();
	} else if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
		return $_ENV["TEMP"];
	} else {
		return "/tmp";
	}
}

