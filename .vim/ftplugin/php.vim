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

if g:vimrc_enabled_plugins.php_namespace
  imap <buffer> <C-x>u <Plug>(php-ns-inser-use)
  imap <buffer> <C-x>c <Plug>(php-ns-expand-class)
endif

if expand('%:p') =~? '\(/\(view\|template\)s\?/\|\.html\.\)'
  let g:php_html_load = 1
  let g:php_html_in_heredoc = 1
  let g:php_sql_heredoc = 0
else
  let g:php_html_load = 0
  let g:php_html_in_heredoc = 0
  let g:php_sql_heredoc = 1
endif

let &cpo = s:save_cpo
