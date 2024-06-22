scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

" setlocal expandtab ts=2 sw=2
" setlocal formatoptions-=r,o
setlocal formatoptions-=r formatoptions-=o
setlocal iskeyword+=$ iskeyword-=- iskeyword-=:

" setlocal dictionary=~/.vim/dict/javascript.dict
" setlocal dictionary+=~/.vim/dict/qunit.dict
" setlocal dictionary+=~/.vim/dict/wsh.dict
" setlocal tabstop=2 shiftwidth=2 textwidth=0 expandtab

" for vim-syntax-js
" if has('conceal')
"   setlocal conceallevel=2 concealcursor=nc
" endif

let &cpo = s:save_cpo
