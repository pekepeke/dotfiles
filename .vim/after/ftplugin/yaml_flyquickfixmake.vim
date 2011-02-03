if exists('g:loaded_yaml_flyquickfixmake') | finish | endif

if !executable('perl')
  " echoerr "can't execute flyquickfixmake"
else
  au BufWritePost *.yaml silent make! %
endif

let g:loaded_yaml_flyquickfixmake=1
