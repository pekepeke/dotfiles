
compiler css
setl errorformat=%f:%l:%m

if !executable('perl') | finish | endif

if exists("g:loaded_css_flyquickfixmake") | finish | endif

call system("perl -MWebService::Validator::Css::W3C")
if !v:shell_error
  au BufWritePost *.css silent make! %
else
  echoerr '[WebService::Validator::Css::W3C] is not found'
endif

let g:loaded_css_flyquickfixmake=1
