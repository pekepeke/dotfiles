scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" Code style
setl autoindent
setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
setl includeexpr=FormatPyImport(v:fname)
setl path+=;/
" setl textwidth=80 tabstop=8 softtabstop=4 shiftwidth=4 expandtab

inoreabbrev <buffer> true True
inoreabbrev <buffer> false False

if neobundle#is_installed('vim-ref')
  nmap <buffer> K <Plug>(ref-keyword)
endif

" tags
"setlocal tags+=~/.vim/tags/python/python.tags

function! FormatPyImport(str)
  return substitute(substitute(substitute(a:str, '^from \|^import ', '', ''), 'import \a\+', '', ''), '\.', '\/', 'g')
endfunction

let &cpo = s:save_cpo
