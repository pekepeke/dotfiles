scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl nowrap formatoptions-=ro
compiler yaml

let &cpo = s:save_cpo
