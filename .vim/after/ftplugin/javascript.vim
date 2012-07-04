scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

" setl expandtab ts=2 sw=2
" setl formatoptions-=ro
setl iskeyword+=$

nnoremap vam $?\%(.*//.*function\)\@!function<CR>f{%V%0
setl dictionary=~/.vim/dict/javascript.dict
setl dictionary+=~/.vim/dict/qunit.dict
setl dictionary+=~/.vim/dict/wsh.dict

inoremap <buffer> <expr> \  smartchr#one_of('\', 'function(', '\\')
nnoremap [comment-doc] :<C-u>call JsDoc()<CR>

" for vim-syntax-js
" if has('conceal')
"   setl conceallevel=2 concealcursor=nc
" endif

let &cpo = s:save_cpo
