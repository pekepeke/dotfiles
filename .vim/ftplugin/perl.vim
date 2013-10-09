"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl expandtab
" setl cindent
let b:match_words = &matchpairs . ',\<if\>:\<elsif\>:\<else\>,\<unless\>:\<else\>'

let &cpo = s:save_cpo
