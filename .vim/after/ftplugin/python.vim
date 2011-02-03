scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" Code style
setlocal autoindent
setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

inoreabbrev <buffer> true True
inoreabbrev <buffer> false False

"syntax highlight
let python_highlight_all=1

" Completion
setlocal omnifunc=pythoncomplete#Complete

" tags
"setlocal tags+=~/.vim/tags/python/python.tags


let &cpo = s:save_cpo
