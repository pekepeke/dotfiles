scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


setl nowrap formatoptions-=ro
setl dictionary=~/.vim/dict/ruby.dict
setl iskeyword+=@,$,?,:
setl iskeyword-=.

" * ~ end block
nnoremap vab 0/end<CR>%V%0
" def ~ end block
nnoremap vam $?\%(.*#.*def\)\@!def<CR>%V%0
" class ~ end block
nnoremap vac $?\%(.*#.*class\)\@!class<CR>%V%0
" module ~ end block
nnoremap vaM $?\%(.*#.*module\)\@!module<CR>%V%0

nnoremap <buffer> <silent> <C-K> :Ref refe<CR>


let &cpo = s:save_cpo
