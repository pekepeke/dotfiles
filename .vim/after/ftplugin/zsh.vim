let s:save_cpo = &cpo
set cpo&vim

setl iskeyword+=-,+
inoremap <buffer> <expr> \ smartchr#one_of('\', 'function ', '\\')

let s:save_cpo = &cpo
