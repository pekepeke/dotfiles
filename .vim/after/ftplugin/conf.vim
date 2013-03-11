"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl indentkeys-=0#
setl formatoptions-=r,o

let &cpo = s:save_cpo
