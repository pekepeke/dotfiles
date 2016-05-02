mb_language("japanese");
mb_internal_encoding("UTF-8");

$from = mb_encode_mimeheader(mb_convert_encoding("送信者", "JIS"))."<from@example.jp>";
$subject = "テスト件名";
$body = "テスト本文";
$addrs = array(
    "fuga" => "to@example.jp",
);

$toAddrs = array();
foreach ($addrs as $name => $email) {
    if (is_numeric($name)) {
        $toAddrs[] = $email;
    } else {
        $toAddrs[] = sprintf("%s<%s>", mb_encode_mimeheader(mb_convert_encoding("テストTO-1", "JIS")), $email);
    }
}
$to = implode(', ', $toAddrs);

mb_send_mail($to, $subject, $body, "From:".$from);

