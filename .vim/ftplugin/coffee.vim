"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal dictionary=~/.vim/dict/coffee.dict
setlocal tabstop=2 shiftwidth=2 textwidth=0 expandtab
setlocal suffixesadd=.coffee,.js,.jade,.json,.cson

let &cpo = s:save_cpo
