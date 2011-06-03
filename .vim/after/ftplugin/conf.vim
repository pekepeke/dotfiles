"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl indentkeys-=0#
setl formatoptions-=ro

let &cpo = s:save_cpo
