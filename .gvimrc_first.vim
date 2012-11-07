" vim:fdm=marker sw=2 ts=2 ft=vim expandtab:
let g:gvimrc_first_finish=1

" from /Applications/MacVim.app/Contents/Resources/vim/gvimrc

if has('gui_macvim')
  let $SSH_ASKPASS = simplify($VIM . '/../../MacOS') . '/macvim-askpass'
endif
