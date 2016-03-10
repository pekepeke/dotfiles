$accept = '192.168.1.1/24';
$remote_ip = $_SERVER['REMOTE_ADDR'];

list($accept_ip,  $mask) = explode('/',  $accept);
$accept_long = ip2long($accept_ip) >> (32 - $mask);
$remote_long = ip2long($remote_ip) >> (32 - $mask);
if ($accept_long == $remote_long) {
}
