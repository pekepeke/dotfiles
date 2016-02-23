"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal foldmethod=marker
let b:match_skip = 's:comment\|string'
if !exists('b:match_words')
  let b:match_words = ''
endif
let b:match_words = &matchpairs . ',\<try\>:\<catch\>:\<finally\>,'
let b:match_words .= '<?\(php\)\?:?>,\<switch\>:\<endswitch\>,' .
  \ '\<if\>:\<elseif\>:\<else\>:\<endif\>,' .
  \ '\<while\>:\<endwhile\>,\<do\>:\<while\>,' .
  \ '\<for\>:\<endfor\>,\<foreach\>:\<endforeach\>,' .
  \ '\<begin\>:\<end/>,' .
  \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
  \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
  \ '<\@<=\([^/?][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>,' .
  \ '<:>,(:),{:},[:]'

if get(g:vimrc_enabled_plugins, 'php_namespace')
  imap <buffer> <C-x>u <Plug>(php-ns-inser-use)
  imap <buffer> <C-x>c <Plug>(php-ns-expand-class)
endif

let &cpo = s:save_cpo
