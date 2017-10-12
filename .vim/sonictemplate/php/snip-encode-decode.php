$salt .= 'saeorj32k42837ndlfk239hl2p3294y';
$method = 'aes-256-ecb';
$str = 'hoge';
$encrypted = openssl_encrypt($str, $method, $salt);
$decrypted = openssl_decrypt($encrypted, $method, $salt);

var_dump($str == $encrypted);
