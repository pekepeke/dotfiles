setl makeprg=zsh\ -n\ %\ $*
setl errorformat=%f:%l:%m
setl shellpipe=2>&1\ \|\ tee

if exists('g:loaded_zsh_flyquickfixmake_ftplugin') | finish | endif

if !executable('zsh')
  " echoerr "can't execute flyquickfixmake"
else
 au BufWritePost *.zsh silent make!
endif

let g:loaded_zsh_flyquickfixmake_ftplugin = 1
