if exists("g:loaded_html_flyquickfixmake") | finish | endif

compiler tidy
setl makeprg=tidy\ -raw\ -quiet\ -errors\ --gnu-emacs\ yes\ \"%\"

if !executable('tidy')
  " echomsg "can't execute flyquickfixmake"
  let g:loaded_html_flyquickfixmake=1
else
  au BufWritePost <buffer> silent make!
endif

