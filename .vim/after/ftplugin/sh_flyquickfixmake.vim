setl makeprg=sh\ -n\ %\ $*
setl errorformat=%f:\ line\ %l:%m
setl shellpipe=2>&1\ \|\ tee

if exists("g:loaded_sh_flyquickfixmake") | finish | endif
let g:loaded_sh_flyquickfixmake = 1

if !executable('sh')
  " echoerr "can't execute flyquickfixmake"
else
 au BufWritePost *.sh silent make!
endif

