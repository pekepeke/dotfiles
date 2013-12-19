let s:save_cpo = &cpo
set cpo&vim
if get(g:vimrc_enabled_plugins, 'smartchr', 0)
  inoremap <buffer><expr> . synchat#isnt_src()?'.':smartchr#one_of('.', '->', '..')
endif

let &cpo = s:save_cpo
