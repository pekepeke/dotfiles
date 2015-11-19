"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


setlocal indentkeys-=0#
setlocal cinkeys-=0#
" setlocal noexpandtab
set softtabstop=0 tabstop=4 shiftwidth=4


let &cpo = s:save_cpo
