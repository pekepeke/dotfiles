"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal comments=:--
setlocal commentstring=--%s
let b:match_words = &matchpairs . ',\<select\>:\<from\>,\<begin\>:\<end\>'
let b:match_ignorecase = 1

let &cpo = s:save_cpo
