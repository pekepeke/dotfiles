" scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal softtabstop=0 shiftwidth=4 tabstop=4 expandtab

let &cpo = s:save_cpo
unlet! s:save_cpo

