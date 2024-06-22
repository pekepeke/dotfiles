scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

setlocal formatoptions-=r formatoptions-=o
setlocal iskeyword+=@,$,?,!
setlocal iskeyword-=.,:
setlocal expandtab
if !exists('b:match_words')
  let b:match_words = ''
endif
let b:match_words .= '\<\(module\|class\|def\|until\|while\|begin\|do\|if\|unless\|case\)\>:'
      \ . '\<\(elsif\|when\|rescue\)\>:\<\(else\|ensure\)\>:\<end\>'
" setlocal dictionary=~/.vim/dict/ruby.dict
" setlocal tabstop=2 shiftwidth=2 textwidth=0 expandtab

" * ~ end block
" nnoremap vab 0/end<CR>%V%0
" def ~ end block
" nnoremap vam $?\%(.*#.*def\)\@!def<CR>%V%0
" class ~ end block
" nnoremap vac $?\%(.*#.*class\)\@!class<CR>%V%0
" module ~ end block
" nnoremap vaM $?\%(.*#.*module\)\@!module<CR>%V%0
" vnoremap <buffer> [space]xa ! xmpfiler -a
" vnoremap <buffer> [space]xs ! xmpfiler -s
" vnoremap <buffer> [space]xm ! xmpfiler -m

let &cpo = s:save_cpo
