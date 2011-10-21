
if executable('csslint')
  makeprg=csslint\ --format=compact\ %
  errorformat=%A%f:\ line\ %l\\,\ col\ %c\\,\ %m

elseif executable('perl')
  call system("perl -MWebService::Validator::Css::W3C")

  if !v:shell_error
    compiler css
    setl errorformat=%f:%l:%m
  else
    echohl Error | echomsg "[WebService::Validator::Css::W3C] is not found" | echohl None
  endif
else
  finish
endif

if exists("g:loaded_css_flyquickfixmake")
  au BufWritePost *.css silent make! %
endif

let g:loaded_css_flyquickfixmake=1
