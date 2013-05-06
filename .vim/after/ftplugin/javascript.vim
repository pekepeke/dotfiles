scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

" setl expandtab ts=2 sw=2
" setl formatoptions-=r,o
setl iskeyword+=$,-
setl iskeyword-=:

" setl dictionary=~/.vim/dict/javascript.dict
" setl dictionary+=~/.vim/dict/qunit.dict
" setl dictionary+=~/.vim/dict/wsh.dict
" setl tabstop=2 shiftwidth=2 textwidth=0 expandtab

inoremap <buffer> <expr> \  smartchr#one_of('\', 'function(', '\\')
inoremap <buffer><expr> @ smartchr#one_of('@', 'this.', '@@')
nmap <silent> [comment-doc] <Plug>(jsdoc)

" for vim-syntax-js
" if has('conceal')
"   setl conceallevel=2 concealcursor=nc
" endif

let &cpo = s:save_cpo
