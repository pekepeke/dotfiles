"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" {{{1
setlocal tabstop=2 shiftwidth=2 textwidth=0 expandtab

function! s:same_indent_re() "{{{
  return '^'.matchstr(getline('.'), '^\s\+').'\S'
endfunction "}}}

nnoremap <silent><buffer> ]] :<C-u>call search(<SID>same_indent_re(), 'We')<CR>
nnoremap <silent><buffer> [[ :<C-u>call search(<SID>same_indent_re(), 'Wbe')<CR>

let &cpo = s:save_cpo
" __END__ {{{1
