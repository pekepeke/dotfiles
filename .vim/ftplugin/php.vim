"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl foldmethod=marker
setl noexpandtab
let b:match_skip = 's:comment\|string'
let b:match_words = '<?\(php\)\?:?>,\<switch\>:\<endswitch\>,' .
    \ '\<if\>:\<elseif\>:\<else\>:\<endif\>,' .
    \ '\<while\>:\<endwhile\>,\<do\>:\<while\>,' .
    \ '\<for\>:\<endfor\>,\<foreach\>:\<endforeach\>' .
    \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
    \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
    \ '<\@<=\([^/?][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>,' .
    \ '<:>,(:),{:},[:]'
let b:match_words = &matchpairs . ',\<try\>:\<catch\>:\<finally\>'


let &cpo = s:save_cpo
