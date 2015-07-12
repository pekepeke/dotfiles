#!/usr/bin/env php
<?php
    if ($argc == 2) {
        $filename = $argv[1];
        $hasTitleRow = true;
    } else if ($argc == 3 && $argv[1] === '-n') {
        $filename = $argv[2];
        $hasTitleRow = false;
    } else {
        echo "Usage: php csv2plist.php [-f] <filename>\n";
        echo "  -n             The file does not have a title row.\n";
        exit(-1);
    }


    // open file
    if (!file_exists($filename)) {
        echo "No such file $filename\n";
        exit(-2);
    }

    $pos  = strrpos($filename, '.');
    $filename_out = substr($filename, 0, $pos).'.plist';

		$from_encoding = "SJIS-win";
		$to_encoding = "utf8";
    // $fp_in = fopen($filename, "r");
		$src = preg_replace('/\r\n|\r|\n/', "\n", file_get_contents($filename));
		$src = mb_convert_encoding($src, $to_encoding, $from_encoding);
		$fp_in = fopen('php://temp/maxmemory:'. (5*1024*1024), 'r+');
		fwrite($fp_in, $src);
		rewind($fp_in);
    $fp_out = fopen($filename_out, "w");

    // get title
    if ($hasTitleRow) {
        $data = fgetcsv($fp_in, 1000, ",");
        $num = count($data);
        $keys = array();
        for ($i = 0; $i < $num; $i++) {
            $keys[$i] = $data[$i];
        }
    }

    // generate plist
    fwrite($fp_out, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
    fwrite($fp_out, "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n");
    fwrite($fp_out, "<plist version=\"1.0\">\n");
    fwrite($fp_out, "<array>\n");

while ($data = fgetcsv($fp_in, 1000, ",")) {
    $num = count($data);

    fwrite($fp_out, "\t<dict>\n");
    for ($i = 0; $i < $num; $i++) {
        if ($hasTitleRow) {
            fwrite($fp_out, "\t\t<key>$keys[$i]</key>\n");
        } else {
            fwrite($fp_out, "\t\t<key>key$i</key>\n");
        }
        fwrite($fp_out, "\t\t<string>".$data[$i]."</string>\n");
    }
    fwrite($fp_out, "\t</dict>\n");
}
fclose($fp_in);

fwrite($fp_out, "</array>\n");
fwrite($fp_out, "</plist>\n");

fclose($fp_out);

echo "Generated:$filename_out\n";
