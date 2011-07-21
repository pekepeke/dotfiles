
compiler tidy
setl makeprg=tidy\ -raw\ -quiet\ -errors\ --gnu-emacs\ yes\ \"%\"

if exists("g:loaded_html_flyquickfixmake") | finish | endif
let g:loaded_html_flyquickfixmake=1
if !executable('tidy')
  " echomsg "can't execute flyquickfixmake"
else
  au BufWritePost <buffer> silent make!
endif

