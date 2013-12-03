let s:save_cpo = &cpo
set cpo&vim

setl iskeyword+=-,+
" setl tabstop=2 shiftwidth=2 textwidth=0 expandtab
inoremap <buffer> <expr> \ synchat#isnt_src()?'\':smartchr#one_of('\', 'function ', '\\')

let s:save_cpo = &cpo
