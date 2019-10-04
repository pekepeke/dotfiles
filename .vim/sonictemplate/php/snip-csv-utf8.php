<?php

$bom = pack('H*', 'EFBBBF');
fwrite($fp, $bom);

fputcsv($fp, $headers);
