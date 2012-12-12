scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" Code style
setl autoindent
setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
setl includeexpr=FormatPyImport(v:fname)
setl path+=;/
setl textwidth=80 tabstop=8 softtabstop=4 shiftwidth=4 expandtab

inoreabbrev <buffer> true True
inoreabbrev <buffer> false False

" tags
"setlocal tags+=~/.vim/tags/python/python.tags

if exists('g:loaded_python_ftplugin')
  finish
endif

let g:loaded_python_ftplugin=1

"syntax highlight
let python_highlight_all=1

function! FormatPyImport(str)
  return substitute(substitute(substitute(a:str, '^from \|^import ', '', ''), 'import \a\+', '', ''), '\.', '\/', 'g')
endfunction

let &cpo = s:save_cpo
