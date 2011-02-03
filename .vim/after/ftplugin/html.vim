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

setl dictionary=~/.vim/dict/html.dict
setl dictionary+=~/.vim/dict/css.dict
setl iskeyword+=-,:
"setl noexpandtab wrap ts=2 sw=2 tw=0
inoremap <buffer> <expr> \  smartchr#one_of('\', 'function(', '\\')

let &cpo = s:save_cpo
