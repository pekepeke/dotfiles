scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

augroup AutoReloadHTML
  au!
  autocmd BufUnload,FileWritePost,BufWritePost * call <SID>AutoReloadHTML()
augroup END

function! s:AutoReloadHTML(...)
  " Check enable
  if !exists('g:autoReload') || g:autoReload == 0
    return
  endif
  silent exe "!autotesthtml.rb > /dev/null 2>&1 &"
endfunction

" http://hail2u.net/blog/software/only-one-line-life-changing-vimrc-setting.html
setl includeexpr=substitute(v:fname,'^\\/','','')
setl path+=;/

setl iskeyword+=-,:
" setl dictionary=~/.vim/dict/html.dict
" setl dictionary+=~/.vim/dict/css.dict
" setl noexpandtab tabstop=2 shiftwidth=2 textwidth=0

inoremap <buffer> <expr> \ synchat#not_src()?'\':smartchr#one_of('\', 'function(', '\\')

if exists('g:loaded_html_after_ftplugin')
  finish
endif

let g:loaded_html_after_ftplugin = 1
" html/indent.vim
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags = "html,body,head,tbody"
" let g:html_indent_autotags = "th,td,tr,tfoot,thead"

let &cpo = s:save_cpo
