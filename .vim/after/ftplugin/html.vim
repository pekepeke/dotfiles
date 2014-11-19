scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

" http://hail2u.net/blog/software/only-one-line-life-changing-vimrc-setting.html
setl includeexpr=substitute(v:fname,'^\\/','','')
setl path+=;/

if &filetype =~# 'html'
  setl iskeyword+=-
endif
" setl dictionary=~/.vim/dict/html.dict
" setl dictionary+=~/.vim/dict/css.dict
" setl noexpandtab tabstop=2 shiftwidth=2 textwidth=0
let b:match_words .= '<:>,' .
	\ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
	\ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
	\ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
let b:match_ignorecase = 1

if get(g:vimrc_enabled_plugins, 'smartchr', 0)
  inoremap <buffer> <expr> \ synchat#isnt_src()?'\':smartchr#one_of('\', 'function(', '\\')
endif

let &cpo = s:save_cpo
