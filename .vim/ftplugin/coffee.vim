"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl dictionary=~/.vim/dict/coffee.dict
setl tabstop=2 shiftwidth=2 textwidth=0 expandtab
setlocal suffixesadd=.coffee,.js,.jade,.json,.cson

let &cpo = s:save_cpo
