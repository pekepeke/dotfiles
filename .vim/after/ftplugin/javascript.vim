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

if get(g:vimrc_enabled_plugins, 'smartchr', 0)
  inoremap <buffer> <expr> \  synchat#isnt_src()?'\':smartchr#one_of('\', 'function(', '\\')
  inoremap <buffer><expr> @ synchat#isnt_src()?'@':smartchr#one_of('@', 'this.', '@@')
  nmap <silent> [!comment-doc] <Plug>(jsdoc)
endif

" for vim-syntax-js
" if has('conceal')
"   setlocal conceallevel=2 concealcursor=nc
" endif

let &cpo = s:save_cpo
