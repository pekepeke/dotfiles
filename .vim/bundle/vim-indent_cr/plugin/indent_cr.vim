" indent_cr.vim
" OriginalAuthor: acustodioo <http://github.com/acustodioo>
" Reformer:       pekepeke
" License: GPL

if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_indent_cr')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim


let &cpo = s:save_cpo
inoremap <SID>IndentCR <C-r>=indent_cr#enter()<CR>
imap <script> <Plug>IndentCR <SID>IndentCR

unlet s:save_cpo

let g:loaded_indent_cr = 1

" vim: foldmethod=marker
