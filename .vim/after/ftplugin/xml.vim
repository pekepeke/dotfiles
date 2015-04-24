scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal formatoptions-=r formatoptions-=o
" setlocal tabstop=2 shiftwidth=2 textwidth=0 expandtab

let &cpo = s:save_cpo
