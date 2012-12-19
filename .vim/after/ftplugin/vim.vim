scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl sw=2 ts=2 expandtab
setl formatoptions-=ro
setl foldmethod=marker
setl iskeyword-=#

let b:match_words = &matchpairs . ',\<if\>:\<en\%[dif]\>'
let b:match_words += ',\<fu\%[nction]!\=\>:\<endf\%[unction]\>'
let b:match_words += ',\<wh\%[ile]\>:\<endwh\%[ile]\>'
let b:match_words += ',\<for\>:\<endfor\=\>'

let &cpo = s:save_cpo
