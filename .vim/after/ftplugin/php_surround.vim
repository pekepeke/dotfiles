let s:save_cpo = &cpo
set cpo&vim

let b:surround_{char2nr('-')} = "<?php \r ?>"
let b:surround_{char2nr('=')} = "<?php echo $\r; ?>"
let b:surround_{char2nr('h')} = "<?php echo h( $\r ); ?>"
let b:surround_{char2nr('#')} = "<?php # \r ?>"
let b:surround_{char2nr('/')} = "<?php // \r ?>"
let b:surround_{char2nr('f')} = "<?php foreach ($\r as $val): ?>\n<?php endforeach; ?>"

let &cpo = s:save_cpo
