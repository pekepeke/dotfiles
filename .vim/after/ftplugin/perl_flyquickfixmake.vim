setl makeprg=perl\ $HOME/.vim/bin/vimparse.pl\ -c\ %\ $*
setl errorformat=%f:%l:%m
setl shellpipe=2>&1\ >

if exists("g:loaded_perl_flyquickfixmake") | finish | endif

if !executable('perl')
  echoerr "can't execute flyquickfixmake"
else
  au! BufWritePost *.pm,*.pl,*.t silent make!
endif

let g:loaded_perl_flyquickfixmake = 1
