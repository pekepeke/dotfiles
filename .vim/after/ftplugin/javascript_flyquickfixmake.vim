
if executable('gjslint')
  setl makeprg=gjslint\ %
  setl errorformat=
        \%+P-----\ FILE\ \ :\ \ %f\ -----,
        \Line\ %l\\,\ %t:%n:\ %m,
        \%+Q%r
elseif executable('jsl')
  setl makeprg=jsl\ -nologo\ -nofilelisting\ -nosummary\ -nocontext\ -process\ %
  setl errorformat=%f(%l):\ %m
elseif executable('smjs')
  setl makeprg=smjs\ -w\ -s\ -C\ %
  setl errorformat=%f:%l:%m
elseif executable('rhino')
  setl makeprg=rhino\ -w\ -strict\ -debug\ %
  setl errorformat="js: %f, line %l:%m"
endif

if exists("g:loaded_javascript_flyquickfixmake") | finish | endif
let g:loaded_javascript_flyquickfixmake=1

if len(filter(['gjslint', 'jsl', 'smjs', 'rhino'], 'executable(v:val)')) <= 0
  " echoerr "can't execute flyquickfixmake"
  echohl Error | echomsg "can't execute flyquickfixmake" | echohl None
else
  au BufWritePost *.js,*.json silent make!
endif

