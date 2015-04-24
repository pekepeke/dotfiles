scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" setlocal sw=2 ts=2 expandtab
" setlocal foldmethod=marker
setlocal formatoptions-=r formatoptions-=o
setlocal iskeyword-=#

let b:match_words = &matchpairs . ',\<if\>:\<elseif\>:\<else\>\<en\%[dif]\>'
let b:match_words += ',\<fu\%[nction]!\=\>:\<endf\%[unction]\>'
let b:match_words += ',\<wh\%[ile]\>:\<endwh\%[ile]\>'
let b:match_words += ',\<for\>:\<endfor\=\>'

let &cpo = s:save_cpo
