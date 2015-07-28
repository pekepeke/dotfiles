let s:save_cpo = &cpo
set cpo&vim

let b:phpunit_skelgen_bootstrap = expand('<sfile>:p:h') . '/bootstrap.php'

let &cpo = s:save_cpo
