scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

" setl expandtab nowrap ts=2 sw=2
" setl formatoptions-=ro
nnoremap vam $?\%(.*//.*function\)\@!function<CR>f{%V%0
setl dictionary=~/.vim/dict/javascript.dict
setl dictionary+=~/.vim/dict/qunit.dict
setl dictionary+=~/.vim/dict/wsh.dict

inoremap <buffer> <expr> \  smartchr#one_of('\', 'function(', '\\')

let &cpo = s:save_cpo
