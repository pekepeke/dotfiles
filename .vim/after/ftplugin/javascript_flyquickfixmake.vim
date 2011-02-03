if executable('gjslint')
  setl makeprg=gjslint\ %
  setl errorformat=
        \%+P-----\ FILE\ \ :\ \ %f\ -----,
        \Line\ %l\\,\ %t:%n:\ %m,
        \%+Q%r
else
  setl makeprg=jsl\ -nologo\ -nofilelisting\ -nosummary\ -nocontext\ -process
  setl errorformat=%f(%l):\ %m
endif

if exists("g:loaded_javascript_flyquickfixmake") | finish | endif

let g:loaded_javascript_flyquickfixmake=1
if !executable('gjslint') && !executable('jsl')
  " echoerr "can't execute flyquickfixmake"
else
  au BufWritePost *.js silent make! %
endif

