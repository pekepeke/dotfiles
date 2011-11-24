scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

setl nowrap formatoptions-=ro
setl dictionary=~/.vim/dict/coffee.dict

let &cpo = s:save_cpo
