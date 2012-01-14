scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_python_ftplugin')
  let g:loaded_python_ftplugin=1

  "syntax highlight
  let python_highlight_all=1

  function! FormatPyImport(str)
    return substitute(substitute(substitute(a:str, '^from \|^import ', '', ''), 'import \a\+', '', ''), '\.', '\/', 'g')
  endfunction
endif

" Code style
setlocal autoindent
setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
setlocal includeexpr=FormatPyImport(v:fname)
setlocal path+=;/

inoreabbrev <buffer> true True
inoreabbrev <buffer> false False

" Completion
setlocal omnifunc=pythoncomplete#Complete

" tags
"setlocal tags+=~/.vim/tags/python/python.tags


let &cpo = s:save_cpo
