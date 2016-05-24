"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal expandtab
setlocal cinwords=if,elsif,else,for,while,try,except,finally,sub,class,switch,case
" setlocal cindent
let b:match_words = &matchpairs . ',\<if\>:\<elsif\>:\<else\>,\<unless\>:\<else\>'

let &cpo = s:save_cpo
