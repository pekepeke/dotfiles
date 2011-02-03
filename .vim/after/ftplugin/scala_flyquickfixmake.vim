setl makeprg=scalac
setl errorformat=%f:%l:\ error:\ %m,%-Z%p^,%-C%.%#,%-G%.%#

if exists('g:loaded_scala_flyquickfixmake')
  finish
endif

if !executable('scalac')
  " echoerr "can't execute flyquickfixmake"
else
  "au BufWritePost *.scala silent make! %
endif

let g:loaded_scala_flyquickfixmake=1
