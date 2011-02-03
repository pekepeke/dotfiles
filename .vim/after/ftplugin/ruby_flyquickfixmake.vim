compiler ruby
setl makeprg=ruby\ -cw\ %

if exists("g:loaded_ruby_flyquickfixmake") 
  finish
endif

if !executable('ruby')
  echoerr "can't execute flyquickfixmake"
else
  au BufWritePost *.rb,*.rjs silent make! %
endif

let g:loaded_ruby_flyquickfixmake=1
