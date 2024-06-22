scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

" http://hail2u.net/blog/software/only-one-line-life-changing-vimrc-setting.html
setlocal includeexpr=substitute(v:fname,'^\\/','','')
setlocal path+=;/

if &filetype =~# 'html'
  setlocal iskeyword+=-
endif
" setlocal dictionary=~/.vim/dict/html.dict
" setlocal dictionary+=~/.vim/dict/css.dict
" setlocal noexpandtab tabstop=2 shiftwidth=2 textwidth=0
if !exists('b:match_words')
  let b:match_words = ''
endif
let b:match_words .= ',<:>,' .
	\ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
	\ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
	\ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
let b:match_ignorecase = 1

let &cpo = s:save_cpo
