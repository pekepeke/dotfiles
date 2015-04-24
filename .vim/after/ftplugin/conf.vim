"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal indentkeys-=0#
setlocal formatoptions-=r formatoptions-=o

let &cpo = s:save_cpo
