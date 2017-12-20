
function mb_chr($num){
  return ($num < 256) ? chr($num) : mb_chr($num / 256).chr($num % 256);
}

function mb_ord($char){
  return (strlen($char) < 2) ?
    ord($char) : 256 * mb_ord(substr($char, 0, -1)) + ord(substr($char, -1));
}

function mb_strtoarray($string)
{
    return array_map(function ($i) use ($string) {
        return mb_substr($string, $i, 1);
    }, range(0, mb_strlen($string) -1));
}
