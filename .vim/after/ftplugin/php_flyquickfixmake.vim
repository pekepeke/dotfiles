compiler php

setl makeprg=php\ -l\ %\ $*
setl errorformat=%m\ in\ %f\ on\ line\ %l
""setl errorformat=%f:%l:%m

if exists("g:loaded_php_flyquickfixmake") | finish | endif

if !executable('php')
  echoerr "can't execute flyquickfixmake"
else
  au BufWritePost *.php,*.ctp silent make!
endif

let g:loaded_php_flyquickfixmake = 1
