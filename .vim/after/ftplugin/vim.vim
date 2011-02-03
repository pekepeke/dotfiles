scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl nowrap formatoptions-=ro
setl foldmethod=marker

let b:match_words = &matchpairs . ',\<if\>:\<en\%[dif]\>'
let b:match_words += ',\<fu\%[nction]!\=\>:\<endf\%[unction]\>'
let b:match_words += ',\<wh\%[ile]\>:\<endwh\%[ile]\>'
let b:match_words += ',\<for\>:\<endfor\=\>'

let &cpo = s:save_cpo
