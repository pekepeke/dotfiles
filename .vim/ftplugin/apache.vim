"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl comments=:#
setl commentstring=#\ %s
if !exists('b:match_words')
  let b:match_words = ''
endif
let b:match_words .= ',<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
let &cpo = s:save_cpo
unlet! s:save_cpo
